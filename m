Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-11.server.virginmedia.net ([80.0.253.75]:53037
	"EHLO know-smtprelay-omc-11.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756261AbbLDRIA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Dec 2015 12:08:00 -0500
Subject: Re: btrfs crashing the kernel with Seagate 8TB SMR drives.
References: <566084F8.5050705@birds-are-nice.me>
 <5661AF77.6000009@render-wahnsinn.de>
To: linux-btrfs@vger.kernel.org
From: Birdsarenice <Quail@birds-are-nice.me>
Message-ID: <5661C672.50203@birds-are-nice.me>
Date: Fri, 4 Dec 2015 16:59:30 +0000
MIME-Version: 1.0
In-Reply-To: <5661AF77.6000009@render-wahnsinn.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I did suspect that NCQ may be involved, but I had no clear evidence - 
until I noticed that my drives had also incremented the 'end to end 
error' count in SMART, which does match accounts of the NCQ issue. That 
suggests there are two interlinked issues: The issue with those Seagate 
drives and NCQ, combined with btrfs causing a kernel lock under certain 
error circumstances when it would be more appropriate to remount ro. 
Looks like the NCQ issue is already being addressed, but I did uncover a 
new and unusual error condition that btrfs needs to handle - and looking 
at the patch, it's a trivial thing to fix, so bothering the mailing list 
with it has made btrfs better in a tiny way. I don't usually report 
errors, assuming that people far more capable than I are already on top 
of them, but when I saw one that gave a description right down to the 
line number I thought it might be something that could be looked into 
very easily.

I'm still impressed with the resilience of btrfs though - after all this 
abuse of crashing during rebalancing, corrupted filesystem structures 
and out-of-order commands, all my data is still undamaged. No 
conventional RAID could have endured that.

Thanks for the patch, but I'd rather not fiddle with he kernel and have 
to repeat every time a new version comes out. I'll just disable NCQ 
until the fix is mainlined and SUSE incorporates it.

uOn 04/12/15 15:21, Robert Krig wrote:
> As Chris mentioned, check out the Bug report here:
> https://bugzilla.kernel.org/show_bug.cgi?id=93581
>
>
> I have a 8TB SMR Drive and the kernel was reporting drive errors.
> Switching to Kernel 3.16 (Standard Debian Jessie kernel) fixed it for me
> ( for the moment).
>
> >From what I read in that kernel bug report. The patch has been submitted
> for kernel 4.4.
>
> On 03.12.2015 19:07, Codebird wrote:
>> I've got a nice bug for you - because I can offer you what everyone
>> likes to see, a precise error message.
>>
>> I've got a btrfs filesystem spread over six devices, RAID1 mode. Four
>> of these are Seagate 8TB archive drives - those SMR ones that a few
>> others have reported failing when used with btrfs. I've had that issue
>> too, and I just can't explain why, other than to say that it only
>> occurs when using them on my mainboard SATA ports, not via USB dock.
>> But that's not what I'm reporting - that's just the source of the
>> problem that causes the crash I am reporting.
>>
>> The crash occurs when scrubbing, after some time and some terabytes -
>> or possibly just when reading a certain place, I'm not sure - and it
>> gives this helpful error left on the screen along with a system so
>> unresponsive numlock won't flash:
>>
>> BTRFS: Error (device sdg1) in  __btrfs_free_extent:6360: errno=-5 IO
>> failure
>> BTRFS: Error (device sdg1) in  __btrfs_free_extent:6360: errno=-5 IO
>> failure
>> BTRFS: Error (device sdg1) in  btrfs_run_delayed_refs:2851: errno=-5
>> IO failure
>> BTRFS: Error (device sdg1) in  btrfs_run_delayed_refs:2851: errno=-5
>> IO failure
>> BTRFS: Error (device sdg1) in  btrfs_run_delayed_refs:2851: errno=-5
>> IO failure
>> <long indent, as if a CR was lost> BTRFS: assertion failed:
>> f(fs_info->sb->s_flags & MS  <Cut by edge of screen>
>> -----------[ cut here ]------------
>> kernel BUG at ../fs/btrfs/ctree.h:4057!
>>
>> Not sure if some of those 5 might be 6, as I was in a hurry to get it
>> back up both times and just got a blurry photo. But it looks to me
>> like there might be a chunk of code that doesn't handle a hardware
>> fault - rather than cleanly return an error it's causing the kernel to
>> hang entirely. I've managed to get this to happen twice now, so it's
>> certainly something worth looking into. This is on SUSE tumbleweed,
>> with kernel 4.3.0-2-default.
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

