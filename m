Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50228 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751075AbcLECcm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Dec 2016 21:32:42 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cDj51-0005Nv-BS
        for linux-btrfs@vger.kernel.org; Mon, 05 Dec 2016 03:32:35 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: system hangs due to qgroups
Date: Mon, 5 Dec 2016 02:32:27 +0000 (UTC)
Message-ID: <pan$8ca94$cc30e15b$935bf922$c3b45b75@cox.net>
References: <1776088.42rHLKPlSp@thetick> <3405186.JXS0fWUK5s@thetick>
        <pan$69035$81ae24e2$d7110ac$22963947@cox.net> <5831203.ygVuIMpfzH@thetick>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc Joliet posted on Sun, 04 Dec 2016 20:20:51 +0100 as excerpted:

> On Sunday 04 December 2016 18:24:08 Duncan wrote:
>> Marc Joliet posted on Sun, 04 Dec 2016 17:02:48 +0100 as excerpted:

>> > [After trying it]
>> > 
>> > Well, crap, I was able to get images of the file system (one
>> > sanitized),
>> > but mounting always fails with "device or resource busy" (with no
>> > corresponding dmesg output).  (Also, that drive's partitions weren't
>> > discovered on bootup, I had to run partprobe first.)  I never see
>> > that in the initramfs, so I'm not sure what's causing that.
>> 
>> If I understand correctly what you're doing, that part is easily enough
>> explained.
>> 
>> Remember that btrfs, unlike most filesystems, is multi-device capable.
>> The way it tracks which devices belong to which filesystems is by UUID,
>> universally *UNIQUE* ID.  If you image a device via dd or similar, you
>> of course image its UUID as well, destroying the "unique" assumption in
>> UUID and confusing btrfs, which will consider it part of the existing
>> filesystem if the original devices with that filesystem UUID remain
>> hooked up.
>> 
>> So if you did what I believe you did, try to mount the image while the
>> original filesystem devices remain attached and mounted, btrfs is
>> simply saying that filesystem (which btrfs identifies by UUID) is
>> already mounted: "device or resource busy".
> [...]
> 
> Nope, sorry if I wasn't clear, I didn't mean that I tried to mount the
> image (can you even mount images created with btrfs-image?).  Plus the
> images are xz-compressed.

Namespace collision.

I interpreted "image" as referring to an "image" taken with dd or 
similar, which as I explained naturally copies the filesystem UUID as 
well, and if both that dd-created image and the original filesystem are 
visible to btrfs at the same time, bad things happen because btrfs 
considers them part of the same filesystem.

And if you tried to mount /that/ image while the original filesystem was 
already mounted, you /might/ get a busy error as it could think it was 
already mounted.  (And you'd be lucky if so, because it just might save 
you serious corruption, tho corruption might still happen due to btrfs 
writing to the image instead of the mounted original filesystem.)

I wasn't considering trying to mount the btrfs-created metadata images...

Anyway, as long as you weren't trying to mount or work with the dd-
created image at the same time as the original was mounted, you should be 
good.  Just remove one (or don't create the loopback device out of the 
image file so it's not exposed as a device that btrfs can see) before 
trying to mount the other and you should be good.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

