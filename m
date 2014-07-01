Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18019 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753142AbaGAVFA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Jul 2014 17:05:00 -0400
Message-ID: <53B32275.6010200@fb.com>
Date: Tue, 1 Jul 2014 17:04:53 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Cody P Schafer <dev@codyps.com>
CC: Chris Samuel <chris@csamuel.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: Blocked tasks on 3.15.1
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>	<4623589E-3298-4980-A257-665CFA9FB61B@colorremedies.com>	<pan$26aa0$13a0ca68$c41d00a9$e8c14640@cox.net>	<3081460.dX0cLeJPhK@quad>	<CAPoQQ-093rEw6mRRDCS4bq8oGOvmuR_a6UAVOjK_ytb=Yq2BSw@mail.gmail.com>	<53B1A862.50503@fb.com>	<53B1ACAA.5040505@fb.com> <CAPoQQ-14VPzzwTDDXmLSmEUs2Rm_HyukoYjeFfOi9LOjqaRCWw@mail.gmail.com>
In-Reply-To: <CAPoQQ-14VPzzwTDDXmLSmEUs2Rm_HyukoYjeFfOi9LOjqaRCWw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/30/2014 07:42 PM, Cody P Schafer wrote:
> On Mon, Jun 30, 2014 at 1:30 PM, Chris Mason <clm@fb.com> wrote:
>> On 06/30/2014 02:11 PM, Chris Mason wrote:
>>> On 06/29/2014 04:02 PM, Cody P Schafer wrote:
>>>> On Fri, Jun 27, 2014 at 7:22 PM, Chris Samuel <chris@csamuel.org> wrote:
>>>>> On Fri, 27 Jun 2014 05:20:41 PM Duncan wrote:
>>>>>
>>>>>> If I'm not mistaken the fix for the 3.16 series bug was:
>>>>>>
>>>>>> ea4ebde02e08558b020c4b61bb9a4c0fcf63028e
>>>>>>
>>>>>> Btrfs: fix deadlocks with trylock on tree nodes.
>>>>>
>>>>> That patch applies cleanly to 3.15.2 so if it is indeed the fix it should
>>>>> probably go to -stable for the next 3.15 release..
>>>>>
>>>>> Unfortunately my test system died a while ago (hardware problem) and I've not
>>>>> been able to resurrect it yet.
>>>>
>>>> I'm also seeing stuck tasks on btrfs (3.14.4, 3.15.1, 3.15.2).
>>>> I've also tried 3.15.2 with ea4ebde02e08558b020c4b61bb9a4c applied on
>>>> top with similar results.
>>>> I've been triggering the hang with 'rsync -hPaHAXx --del /mnt/home/a/
>>>> /home/a/' where /mnt/home and /home are 2 separate btrfs filesystems
>>>> on 2 separate disks.
>>>>
>>>> dmesg with w-trigger: https://urldefense.proofpoint.com/v1/url?u=http://bpaste.net/show/419555&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=SAjzDO8AnhJBEWtUi6s8VGVQd2sORQ%2FJz5tWH4nOYWg%3D%0A&s=2c4ff3f7f39b2e6d3dcd4947905df54d6a534b35adf63c55d8c50e28ef5781b6
>>>> --
>>>
>>> These traces show us waiting for IO, but it doesn't show anyone doing
>>> the IO.  Either we're failing to kick off our work queues or they are
>>> stuck on something else.
>>>
>>> Could you please send a sysrq-t and sysrq-l while you're stuck?  That
>>> will show us all the procs and all the CPUs.
>>
>> Also, do you have any nodatacow files in here?  Please say yes.
>>
> 
> kernel log from 3.15.2 + ea4ebde02 showing the blocked tasks,
> sysrq-{w,t,l} included
> https://urldefense.proofpoint.com/v1/url?u=http://bpaste.net/show/423296/&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=SAjzDO8AnhJBEWtUi6s8VGVQd2sORQ%2FJz5tWH4nOYWg%3D%0A&s=5af8bc75059925af242b0eef1f4b94348d233d79968d53ff36b7c2594c9dd6b9
> 
> I haven't explicitely created any nodatacow files, is there a quick
> way to tell if there are any? Right now I'm doing
> `lsattr -R /mnt/home/a/ 2>/dev/null | grep -- '^-*C-* '` to try and check.
> 
> (2>/dev/null is hiding lots of "Operation not supported While reading
> flags on" warnings)
> 

If you haven't turned nodatacow on intentionally, you don't have any
nodatacow files ;)  I have been trying to reproduce this with rsync and
other code that hammers on the ordered writeback, but no luck yet.

Before we spend too much time triggering it again, I'd like you to
please try a patch from Filipe that is in current mainline.  I've cherry
picked on top of 3.15.3 in a branch called v3.15.y:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git v3.15.y

-chris

