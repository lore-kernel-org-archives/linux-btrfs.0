Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33812 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbbEEH2y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 May 2015 03:28:54 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YpXHg-0006gs-Ha
	for linux-btrfs@vger.kernel.org; Tue, 05 May 2015 09:28:52 +0200
Received: from c-24-5-205-109.hsd1.ca.comcast.net ([24.5.205.109])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 May 2015 09:28:52 +0200
Received: from obiwantje by c-24-5-205-109.hsd1.ca.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 May 2015 09:28:52 +0200
To: linux-btrfs@vger.kernel.org
From: TheJay <obiwantje@gmail.com>
Subject: Re: [REQ] Help to gain access to btrfsraid6 pool that won't mount
Date: Tue, 5 May 2015 07:28:46 +0000 (UTC)
Message-ID: <mi9rfe$ri6$2@ger.gmane.org>
References: <mi8452$i00$1@ger.gmane.org> <5547E3BF.4090901@inwind.it>
	<mi8op3$ri6$1@ger.gmane.org>
	<CAJCQCtRy+RppYv5AnVb1BACWmud_yTN8qsRY2MHBKZv2K37Ykw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 05 May 2015 00:52:16 -0600, Chris Murphy wrote:

> On Mon, May 4, 2015 at 3:36 PM, TheJay <obiwantje@gmail.com> wrote:
> 
>> [Mon May  4 14:33:17 2015] BTRFS: bdev (null) errs: wr 3, rd 28773, flush 2, corrupt 0, gen 0
> 
> So there might be more than one thing going wrong and they're
> colliding to make a worse problem. You've got three write and 2 flush
> errors, and many thousands of read errors (probably due to missing
> devices).
> 
> It might be worth trying -o degraded,recovery because recovery can't
> work with devices missing, and degraded alone won't run the recovery
> code.
> 
> 
> -- 
> Chris Murphy

$ mount  -o degraded,recovery /dev/sdz /mnt/roms03
mount: wrong fs type, bad option, bad superblock on /dev/sdy,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

$ dmesg -T|tail
[Tue May  5 00:26:01 2015] BTRFS info (device sdaa): enabling auto recovery
[Tue May  5 00:26:01 2015] BTRFS info (device sdaa): disk space caching is enabled
[Tue May  5 00:26:01 2015] BTRFS: has skinny extents
[Tue May  5 00:26:01 2015] BTRFS: bdev (null) errs: wr 3, rd 28773, flush 2, corrupt 0, gen 0
[Tue May  5 00:26:05 2015] BTRFS (device sdaa): bad tree block start 8714499618262386624 1585233920
[Tue May  5 00:26:05 2015] BTRFS (device sdaa): bad tree block start 8714499618262386624 1585233920
[Tue May  5 00:26:05 2015] BTRFS (device sdaa): bad tree block start 8714499618262386624 1585233920
[Tue May  5 00:26:05 2015] BTRFS (device sdaa): bad tree block start 8714499618262386624 1585233920
[Tue May  5 00:26:05 2015] BTRFS: Failed to read block groups: -5
[Tue May  5 00:26:06 2015] BTRFS: open_ctree failed

