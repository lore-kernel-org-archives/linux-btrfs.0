Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36164 "EHLO
	blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S965064AbcHJS7C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Aug 2016 14:59:02 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bXNCi-0007PC-5B
	for linux-btrfs@vger.kernel.org; Wed, 10 Aug 2016 08:41:28 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS: error (device sda1) in btrfs_run_delayed_refs:2963:
 errno=-17 Object already exists
Date: Wed, 10 Aug 2016 06:41:21 +0000 (UTC)
Message-ID: <pan$c10ae$cb8cb4bc$c1fc453b$eddc13d5@cox.net>
References: <a70af895-6d3e-3b8a-eeb3-71d6609f8154@techsquare.com>
	<CAJCQCtReDSm46LVVZaiMO3oSRgi9EBQnY9+JkH6Fia1SFH4AWg@mail.gmail.com>
	<CAJCQCtSR6S_RQ5eMjQC9qwifEakme58uw11wHcewiDxqNfq_kw@mail.gmail.com>
	<34532105-4411-2a21-a83d-e48f4311400a@techsquare.com>
	<CAJCQCtRJhvwS2w1iRTxZbQ0tyfDH6Ser1=DBH6w+2Rq4pguf2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 09 Aug 2016 20:25:39 -0600 as excerpted:

> 1 size 50.93TiB used 22.67TiB path /dev/sda1
> 
> What is the exact nature of this block device?
> 
> If getting this back up and running is urgent I suggest inquiring on IRC
> what the next steps are.
> 
> In the meantime I'd get a btrfs-image (which is probably going to be
> quite large given metadata is 60GiB), if that pukes then see if 'btrfs
> inspect-internal dump-tree /dev/sda1 > dumptree.log' which may also fail
> but before it fails might contain something useful. Obviously btrfs
> check shouldn't crash so that's a bug already.

I'd suggest that at 50+ TB size, 22+ TB used, given btrfs check's known 
memory usage, the crash may well simply be due to lack of memory.  It's 
very likely that will require well over the 16 GiB memory that's 
reasonably common these days, and if there's no swap to fill in the gap...

There's a low memory mode check under development right now, but it's not 
complete yet.

(FWIW my usage is at the other extreme, quarter TB SSDs and partitioned 
down beyond that, so the largest btrfs is well under 50 GiB usable, tho 
it's pair-device raid1 so about 50 GiB total.  That's too small to be 
practical for many, but at least until the low-memory btrfs check or 
until 32 and 64 GiB RAM becomes common, single filesystems in the double-
digit TB may arguably be too big to be practical, at least for other than 
the lucky few with the sort of memory required, as well.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

