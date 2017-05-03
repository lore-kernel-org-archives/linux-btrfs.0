Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38697 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752524AbdECOVn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2017 10:21:43 -0400
Received: by mail-wm0-f45.google.com with SMTP id r190so60360635wme.1
        for <linux-btrfs@vger.kernel.org>; Wed, 03 May 2017 07:21:42 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: File system corruption, btrfsck abort
From: Christophe de Dinechin <dinechin@redhat.com>
In-Reply-To: <d043e058-52e2-13d9-fd64-dd7807496e7b@cn.fujitsu.com>
Date: Wed, 3 May 2017 16:21:39 +0200
Cc: linux-btrfs@vger.kernel.org
Message-Id: <3C2BA016-C2EE-4EC1-BDA2-224CC2C0AC37@redhat.com>
References: <D64BF81E-58B3-4B19-AD65-F5056768466C@redhat.com>
 <43eda9a8-e7be-4bc3-bd37-4df44f93f321@cn.fujitsu.com>
 <693E2A30-D8DA-404D-B9C0-4B15D3348808@redhat.com>
 <d043e058-52e2-13d9-fd64-dd7807496e7b@cn.fujitsu.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On 2 May 2017, at 02:17, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> 
> 
> 
> At 04/28/2017 04:47 PM, Christophe de Dinechin wrote:
>>> On 28 Apr 2017, at 02:45, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>> 
>>> 
>>> 
>>> At 04/26/2017 01:50 AM, Christophe de Dinechin wrote:
>>>> Hi,
>>>> I”ve been trying to run btrfs as my primary work filesystem for about 3-4 months now on Fedora 25 systems. I ran a few times into filesystem corruptions. At least one I attributed to a damaged disk, but the last one is with a brand new 3T disk that reports no SMART errors. Worse yet, in at least three cases, the filesystem corruption caused btrfsck to crash.
>>>> The last filesystem corruption is documented here: https://bugzilla.redhat.com/show_bug.cgi?id=1444821. The dmesg log is in there.
>>> 
>>> According to the bugzilla, the btrfs-progs seems to be too old in btrfs standard.
>>> What about using the latest btrfs-progs v4.10.2?
>> I tried 4.10.1-1 https://bugzilla.redhat.com/show_bug.cgi?id=1435567#c4.
>> I am currently debugging with a build from the master branch as of Tuesday (commit bd0ab27afbf14370f9f0da1f5f5ecbb0adc654c1), which is 4.10.2
>> There was no change in behavior. Runs are split about evenly between list crash and abort.
>> I added instrumentation and tried a fix, which brings me a tiny bit further, until I hit a message from delete_duplicate_records:
>> Ok we have overlapping extents that aren't completely covered by each
>> other, this is going to require more careful thought.  The extents are
>> [52428800-16384] and [52432896-16384]
> 
> Then I think lowmem mode may have better chance to handle it without crash.

I tried it and got:

[root@rescue ~]# /usr/local/bin/btrfsck --mode=lowmem --repair /dev/sda4
enabling repair mode
ERROR: low memory mode doesn't support repair yet

The problem only occurred in —repair mode anyway.


> 
>>> Furthermore for v4.10.2, btrfs check provides a new mode called lowmem.
>>> You could try "btrfs check --mode=lowmem" to see if such problem can be avoided.
>> I will try that, but what makes you think this is a memory-related condition? The machine has 16G of RAM, isn’t that enough for an fsck?
> 
> Not for memory usage, but in fact lowmem mode is a completely rework, so I just want to see how good or bad the new lowmem mode handles it.

Is there a prototype with lowmem and repair?


Thanks
Christophe

> 
> Thanks,
> Qu
> 
>>> 
>>> For the kernel bug, it seems to be related to wrongly inserted delayed ref, but I can totally be wrong.
>> For now, I’m focusing on the “repair” part as much as I can, because I assume the kernel bug is there anyway, so someone else is bound to hit this problem.
>> Thanks
>> Christophe
>>> 
>>> Thanks,
>>> Qu
>>>> The btrfsck crash is here: https://bugzilla.redhat.com/show_bug.cgi?id=1435567. I have two crash modes: either an abort or a SIGSEGV. I checked that both still happens on master as of today.
>>>> The cause of the abort is that we call set_extent_dirty from check_extent_refs with rec->max_size == 0. I’ve instrumented to try to see where we set this to 0 (see https://github.com/c3d/btrfs-progs/tree/rhbz1435567), and indeed, we do sometimes see max_size set to 0 in a few locations. My instrumentation shows this:
>>>> 78655 [1.792241:0x451fe0] MAX_SIZE_ZERO: Add extent rec 0x139eb80 max_size 16384 tmpl 0x7fffffffd120
>>>> 78657 [1.792242:0x451cb8] MAX_SIZE_ZERO: Set max size 0 for rec 0x139ec50 from tmpl 0x7fffffffcf80
>>>> 78660 [1.792244:0x451fe0] MAX_SIZE_ZERO: Add extent rec 0x139ed50 max_size 16384 tmpl 0x7fffffffd120
>>>> I don’t really know what to make of it.
>>>> The cause of the SIGSEGV is that we try to free a list entry that has its next set to NULL.
>>>> #0  list_del (entry=0x555555db0420) at /usr/src/debug/btrfs-progs-v4.10.1/kernel-lib/list.h:125
>>>> #1  free_all_extent_backrefs (rec=0x555555db0350) at cmds-check.c:5386
>>>> #2  maybe_free_extent_rec (extent_cache=0x7fffffffd990, rec=0x555555db0350) at cmds-check.c:5417
>>>> #3  0x00005555555b308f in check_block (flags=<optimized out>, buf=0x55557b87cdf0, extent_cache=0x7fffffffd990, root=0x55555587d570) at cmds-check.c:5851
>>>> #4  run_next_block (root=root@entry=0x55555587d570, bits=bits@entry=0x5555558841
>>>> I don’t know if the two problems are related, but they seem to be pretty consistent on this specific disk, so I think that we have a good opportunity to improve btrfsck to make it more robust to this specific form of corruption. But I don’t want to hapazardly modify a code I don’t really understand. So if anybody could make a suggestion on what the right strategy should be when we have max_size == 0, or how to avoid it in the first place.
>>>> I don’t know if this is relevant at all, but all the machines that failed that way were used to run VMs with KVM/QEMU. DIsk activity tends to be somewhat intense on occasions, since the VMs running there are part of a personal Jenkins ring that automatically builds various projects. Nominally, there are between three and five guests running (Windows XP, WIndows 10, macOS, Fedora25, Ubuntu 16.04).
>>>> Thanks
>>>> Christophe de Dinechin
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> 
>>> 
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

