Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:1670 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaFSDVe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 23:21:34 -0400
Message-ID: <53A2573B.1060901@hp.com>
Date: Wed, 18 Jun 2014 23:21:31 -0400
From: Waiman Long <waiman.long@hp.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: Marc Dionne <marc.c.dionne@gmail.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, t-itoh@jp.fujitsu.com
Subject: Re: Lockups with btrfs on 3.16-rc1 - bisected
References: <CAB9dFdsyB40V2BGwdQKzSSz7YUWMh-C2AWdDNK=PMG9h+BO57w@mail.gmail.com>	<53A20FFF.3010807@hp.com>	<53A2125B.3050701@fb.com>	<53A21702.8090109@hp.com>	<53A21C78.1040809@fb.com>	<53A21E84.2050103@hp.com>	<53A22064.7080400@fb.com>	<53A2212E.7090907@hp.com>	<53A2268F.3080807@fb.com>	<CAB9dFds5J8Ti3CgtxHrgqM3j1TiwqYCnhP+A3Nb0q-FNgmQbXA@mail.gmail.com>	<53A22A01.7080505@hp.com>	<CAB9dFdvD9QMZ_rONhhP5ZD2E7+A7qxnsY978Snc3zHEbdPRszw@mail.gmail.com> <CAB9dFdtTFN+uQ8=WXVa0Y5GbBSYM5iVLgTaEeh_FqHt=XFKNvQ@mail.gmail.com> <53A246C6.5050408@fb.com>
In-Reply-To: <53A246C6.5050408@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/18/2014 10:11 PM, Chris Mason wrote:
> On 06/18/2014 10:03 PM, Marc Dionne wrote:
>> On Wed, Jun 18, 2014 at 8:41 PM, Marc Dionne<marc.c.dionne@gmail.com>  wrote:
>>> On Wed, Jun 18, 2014 at 8:08 PM, Waiman Long<waiman.long@hp.com>  wrote:
>>>> On 06/18/2014 08:03 PM, Marc Dionne wrote:
>> And for an additional data point, just removing those
>> CONFIG_DEBUG_LOCK_ALLOC ifdefs looks like it's sufficient to prevent
>> the symptoms when lockdep is not enabled.
> Ok, somehow we've added a lock inversion here that wasn't here before.
> Thanks for confirming, I'll nail it down.
>
> -chris
>

I am pretty sure that the hangup is caused by the following kind of code 
fragment in the locking.c file:

  if (eb->lock_nested) {
                 read_lock(&eb->lock);
                 if (eb->lock_nested && current->pid == eb->lock_owner) {

Is it possible to do the check without taking the read_lock?

-Longman


