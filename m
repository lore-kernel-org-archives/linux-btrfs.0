Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:59831 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab2HTWYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Aug 2012 18:24:17 -0400
Received: by ggdk6 with SMTP id k6so5472727ggd.19
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Aug 2012 15:24:17 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
Subject: Re: btrfs and mdadm raid 6
From: Curtis Jones <curtis.jones@gmail.com>
In-Reply-To: <20120820230603.1ba1afca@natsu>
Date: Mon, 20 Aug 2012 18:24:10 -0400
Message-Id: <2D811613-9EF6-4C5E-84A3-CB0E8D425B0B@gmail.com>
References: <8AE790DA-04B5-4407-A5FE-D0AC4560B415@gmail.com> <20120820230603.1ba1afca@natsu>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman,

Thanks a lot for your response.

Through no small miracle, I am in a position to start over without risking my data. You mentioned that btrfs was going to set aside a ton of space for metadata. Is that entirely due to going ext4 -> btrfs? Since I can now create a btrfs file system from scratch, is it a non-issue or is there a parameter I can use to avoid that - without having to recompile my kernel with that patch?

Thanks again.

--
Curtis Jones
curtisjones.us
404.492.6437




On Aug 20, 2012, at 13.06.03, Roman Mamedov <rm@romanrm.ru> wrote:

> On Mon, 20 Aug 2012 12:22:31 -0400
> Curtis Jones <curtis.jones@gmail.com> wrote:
> 
>> 	1. is btrfs-convert on /dev/md0 stable/reliable/tested/not-a-stupid-thing-to-do?
> 
> btrfs-convert does not care on what kind of block device an FS resides, so it's OK.
> 
>> 	2. based on the reading I've done, resizing btrfs is supported. can you confirm?
> 
> Yes, both growing and shrinking.
> 
>> 	3. there aren't any known compatibility or other issues with running btrfs on top of mdadm (raid 6)
> 
> Not that I know of.
> 
> But... if we were a year into the future and there was working btrfs RAID6,
> then that configuration (btrfs native RAID6 rather than single-device btrfs on
> top of mdadm) would provide more resilience, as blocks with failed checksums
> could be automatically reconstructed from 'good' data on other devices in the
> array.
> 
> In the current situation though, btrfs checksums will only tell you that you
> lost data due to some corruption underneath, in (unlikely)case that it
> happens and mdadm lets it through.
> 
>> 	4. any other caveats I might want to consider?
> 
> 1) AFAIK the patch [1] is still not in the mainline, so you'll either have to
> include it into your kernels yourself, or you will end up with a truly and
> enormous metadata allocation size, if I'm counting correctly on your array with
> 42 TB of usable space you will have 840GB * 2 = 1700 GB reserved for metadata.
> 
> [1] http://comments.gmane.org/gmane.comp.file-systems.btrfs/19200
> 
> 2) On filesystem converted with btrfs-convert the metadata allocation is
> unnecessarily large due to some other, conversion-related reasons; but this
> can be fixed with "btrfs filesystem balance -musage=5 /mount/point" (do
> several runs increasing the value from 5 to 10, 20 or more, if it fails to
> free up a sufficient amount of space). This will defragment metadata and free
> up chunks which end up being completely unused (which will be a lot of them),
> but only down to the kernel's desired minimum allocation, see point #1.
> 
> 3) Due to the point #1 and in general for performance reasons, considering
> also that you're already running on top of a parity-protected RAID, you might
> want to consider switching the metadata profile from DUP to single (i.e. just
> one copy of metadata on the device, not two).
> "btrfs fi balance start -mconvert=single /mnt/point"
> 
> Regarding balance, see https://btrfs.wiki.kernel.org/index.php/Balance_Filters
> 
>> I just upgraded from kernel v3.5.1 to v3.5.2 and I have the btrfs-tools (v0.19) compiled straight from git.
> 
> You're doing great :)
> 
> Also, btw, I hope you have a full backup of everything you care about.
> 
> -- 
> With respect,
> Roman
> 
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~
> "Stallman had a printer,
> with code he could not see.
> So he began to tinker,
> and set the software free."

