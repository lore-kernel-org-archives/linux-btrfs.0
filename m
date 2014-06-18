Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30161 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752463AbaFRW1w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 18:27:52 -0400
Message-ID: <53A2125B.3050701@fb.com>
Date: Wed, 18 Jun 2014 15:27:39 -0700
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Waiman Long <waiman.long@hp.com>, Marc Dionne <marc.c.dionne@gmail.com>
CC: <linux-btrfs@vger.kernel.org>, <clm@fb.com>, <t-itoh@jp.fujitsu.com>
Subject: Re: Lockups with btrfs on 3.16-rc1 - bisected
References: <CAB9dFdsyB40V2BGwdQKzSSz7YUWMh-C2AWdDNK=PMG9h+BO57w@mail.gmail.com> <53A20FFF.3010807@hp.com>
In-Reply-To: <53A20FFF.3010807@hp.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/18/2014 03:17 PM, Waiman Long wrote:
> On 06/18/2014 04:57 PM, Marc Dionne wrote:
>> Hi,
>>
>> I've been seeing very reproducible soft lockups with 3.16-rc1 similar
>> to what is reported here:
>> https://urldefense.proofpoint.com/v1/url?u=http://marc.info/?l%3Dlinux-btrfs%26m%3D140290088532203%26w%3D2&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=aoagvtZMwVb16gh1HApZZL00I7eP50GurBpuEo3l%2B5g%3D%0A&s=c62558feb60a480bbb52802093de8c97b5e1f23d4100265b6120c8065bd99565
>> , along with the
>> occasional hard lockup, making it impossible to complete a parallel
>> build on a btrfs filesystem for the package I work on.  This was
>> working fine just a few days before rc1.
>>
>> Bisecting brought me to the following commit:
>>
>>    commit bd01ec1a13f9a327950c8e3080096446c7804753
>>    Author: Waiman Long<Waiman.Long@hp.com>
>>    Date:   Mon Feb 3 13:18:57 2014 +0100
>>
>>        x86, locking/rwlocks: Enable qrwlocks on x86
>>
>> And sure enough if I revert that commit on top of current mainline,
>> I'm unable to reproduce the soft lockups and hangs.
>>
>> Marc
>
> The queue rwlock is fair. As a result, recursive read_lock is not
> allowed unless the task is in an interrupt context. Doing recursive
> read_lock will hang the process when a write_lock happens somewhere in
> between. Are recursive read_lock being done in the btrfs code?
>

We walk down a tree and read lock each node as we walk down, is that 
what you mean?  Or do you mean read_lock multiple times on the same lock 
in the same process, cause we definitely don't do that.  Thanks,

Josef
