Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56529 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752978AbaFSUF1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 16:05:27 -0400
Message-ID: <53A343B9.3000900@fb.com>
Date: Thu, 19 Jun 2014 16:10:33 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Waiman Long <waiman.long@hp.com>
CC: Marc Dionne <marc.c.dionne@gmail.com>, Josef Bacik <jbacik@fb.com>,
        <linux-btrfs@vger.kernel.org>, <t-itoh@jp.fujitsu.com>
Subject: Re: Lockups with btrfs on 3.16-rc1 - bisected
References: <CAB9dFdsyB40V2BGwdQKzSSz7YUWMh-C2AWdDNK=PMG9h+BO57w@mail.gmail.com>	<53A20FFF.3010807@hp.com>	<53A2125B.3050701@fb.com>	<53A21702.8090109@hp.com>	<53A21C78.1040809@fb.com>	<53A21E84.2050103@hp.com>	<53A22064.7080400@fb.com>	<53A2212E.7090907@hp.com>	<53A2268F.3080807@fb.com>	<CAB9dFds5J8Ti3CgtxHrgqM3j1TiwqYCnhP+A3Nb0q-FNgmQbXA@mail.gmail.com>	<53A22A01.7080505@hp.com>	<CAB9dFdvD9QMZ_rONhhP5ZD2E7+A7qxnsY978Snc3zHEbdPRszw@mail.gmail.com> <CAB9dFdtTFN+uQ8=WXVa0Y5GbBSYM5iVLgTaEeh_FqHt=XFKNvQ@mail.gmail.com> <53A246C6.5050408@fb.com> <53A2573B.1060901@hp.com> <53A31514.8030308@fb.com> <53A32353.5000104@hp.com>
In-Reply-To: <53A32353.5000104@hp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/19/2014 01:52 PM, Waiman Long wrote:
> On 06/19/2014 12:51 PM, Chris Mason wrote:
>> On 06/18/2014 11:21 PM, Waiman Long wrote:
>>> On 06/18/2014 10:11 PM, Chris Mason wrote:
>>>> On 06/18/2014 10:03 PM, Marc Dionne wrote:
>>>>> On Wed, Jun 18, 2014 at 8:41 PM, Marc
>>>>> Dionne<marc.c.dionne@gmail.com>   wrote:
>>>>>> On Wed, Jun 18, 2014 at 8:08 PM, Waiman Long<waiman.long@hp.com>
>>>>>> wrote:
>>>>>>> On 06/18/2014 08:03 PM, Marc Dionne wrote:
>>>>> And for an additional data point, just removing those
>>>>> CONFIG_DEBUG_LOCK_ALLOC ifdefs looks like it's sufficient to prevent
>>>>> the symptoms when lockdep is not enabled.
>>>> Ok, somehow we've added a lock inversion here that wasn't here before.
>>>> Thanks for confirming, I'll nail it down.
>>>>
>>>> -chris
>>>>
>>> I am pretty sure that the hangup is caused by the following kind of code
>>> fragment in the locking.c file:
>>>
>>>   if (eb->lock_nested) {
>>>                  read_lock(&eb->lock);
>>>                  if (eb->lock_nested&&  current->pid ==
>>> eb->lock_owner) {
>>>
>>> Is it possible to do the check without taking the read_lock?
>> I think you're right, we haven't added any new recursive takers of the
>> lock.  The path where we are deadlocking has an extent buffer that isn't
>> in the path yet locked.  I think we're taking the read lock while that
>> one is write locked.
>>
>> Reworking the nesting a big here.
>>
>> -chris
> 
> I would like to take back my comments. I took out the read_lock, but the
> process still hang while doing file activities on btrfs filesystem. So
> the problem is trickier than I thought. Below are the stack backtraces
> of some of the relevant processes.
> 

You weren't wrong, but it was also the tree trylock code.  Our trylocks
only back off if the blocking lock is held.  btrfs_next_leaf needs it to
be a true trylock.  The confusing part is this hasn't really changed,
but one of the callers must be a spinner where we used to have a blocker.

-chris
