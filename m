Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12208 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753256AbaF3SbD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jun 2014 14:31:03 -0400
Message-ID: <53B1ACAA.5040505@fb.com>
Date: Mon, 30 Jun 2014 14:30:02 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Cody P Schafer <dev@codyps.com>, Chris Samuel <chris@csamuel.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Blocked tasks on 3.15.1
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>	<4623589E-3298-4980-A257-665CFA9FB61B@colorremedies.com>	<pan$26aa0$13a0ca68$c41d00a9$e8c14640@cox.net>	<3081460.dX0cLeJPhK@quad> <CAPoQQ-093rEw6mRRDCS4bq8oGOvmuR_a6UAVOjK_ytb=Yq2BSw@mail.gmail.com> <53B1A862.50503@fb.com>
In-Reply-To: <53B1A862.50503@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/30/2014 02:11 PM, Chris Mason wrote:
> On 06/29/2014 04:02 PM, Cody P Schafer wrote:
>> On Fri, Jun 27, 2014 at 7:22 PM, Chris Samuel <chris@csamuel.org> wrote:
>>> On Fri, 27 Jun 2014 05:20:41 PM Duncan wrote:
>>>
>>>> If I'm not mistaken the fix for the 3.16 series bug was:
>>>>
>>>> ea4ebde02e08558b020c4b61bb9a4c0fcf63028e
>>>>
>>>> Btrfs: fix deadlocks with trylock on tree nodes.
>>>
>>> That patch applies cleanly to 3.15.2 so if it is indeed the fix it should
>>> probably go to -stable for the next 3.15 release..
>>>
>>> Unfortunately my test system died a while ago (hardware problem) and I've not
>>> been able to resurrect it yet.
>>
>> I'm also seeing stuck tasks on btrfs (3.14.4, 3.15.1, 3.15.2).
>> I've also tried 3.15.2 with ea4ebde02e08558b020c4b61bb9a4c applied on
>> top with similar results.
>> I've been triggering the hang with 'rsync -hPaHAXx --del /mnt/home/a/
>> /home/a/' where /mnt/home and /home are 2 separate btrfs filesystems
>> on 2 separate disks.
>>
>> dmesg with w-trigger: http://bpaste.net/show/419555
>> --
> 
> These traces show us waiting for IO, but it doesn't show anyone doing
> the IO.  Either we're failing to kick off our work queues or they are
> stuck on something else.
> 
> Could you please send a sysrq-t and sysrq-l while you're stuck?  That
> will show us all the procs and all the CPUs.

Also, do you have any nodatacow files in here?  Please say yes.

-chris

