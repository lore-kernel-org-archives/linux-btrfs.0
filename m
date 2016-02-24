Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:32938 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbcBXDCp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 22:02:45 -0500
Received: by mail-io0-f169.google.com with SMTP id z135so15998646iof.0
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Feb 2016 19:02:44 -0800 (PST)
Received: from gmail.com (blk-11-122-84.eastlink.ca. [76.11.122.84])
        by smtp.gmail.com with ESMTPSA id n5sm12440096iga.15.2016.02.23.19.02.43
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 23 Feb 2016 19:02:43 -0800 (PST)
Date: Tue, 23 Feb 2016 23:02:38 -0400
From: Kenny MacDermid <kenny.macdermid@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Input/Output errors
Message-ID: <20160224030236.GA30797@gmail.com>
References: <20160224004045.GA20632@gmail.com>
 <20160224015658.GY22487@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160224015658.GY22487@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 23, 2016 at 05:56:58PM -0800, Marc MERLIN wrote:
> On Tue, Feb 23, 2016 at 08:40:46PM -0400, Kenny MacDermid wrote:
> > I'm running btrfs on DM-Crypt Luks running on LVM.
> > 
> > Occasionally I get files that are unreadable for some period of time.
> > Attempting to read from them results in an 
> > 
> > Input/output error
> > 
> > Sometimes they'll come back on their own, and sometimes a scrub seems to
> > help, but sometimes I just have to delete them.
> > 
> > Nothing shows up in dmesg when these occur, and I can't predict which
> > files it will be, or what causes it.
> > 
> > It's currently happening running 4.4.1-2-ARCH, but I've seen the same
> > thing for many previous kernel versions.
> > 
> > Does anyone have any suggestions?
> 
> That's weird to say the least, you should at least get *something* in
> dmesg.
> And you are getting other error messages and btrfs kernel messages in
> your logs?
> 
> When whatever app you have that's trying to read them fails, I assume
> they also fail with cat or less?

I am getting other, normal btrfs messages. I'll include them at the end.
When it happens I get nothing at all in dmesg/logs.

And yes, cat will fail. I can move the file to another name though,
which I often do to get it out of the way.

They're mounted with:

rw,noatime,compress=lzo,ssd,discard,space_cache,autodefrag,inode_cache

issue_discards=1 is in lvm.conf, and discard in /etc/crypttab. (I'm now
reading that I probably shouldn't have it in fstab though and just run
fstrim.)

I don't know if this is related yet at all, but it /seems/ more likely
to happen after I delete a bunch of data. That could be a red herring
though.

When the file becomes readable again it's perfectly fine. Scrub never
finds any errors.

$ dmesg | grep -i btrfs
[   11.837137] Btrfs loaded
[   11.837403] BTRFS: device label root devid 1 transid 508963 /dev/dm-3
[   11.856203] BTRFS info (device dm-3): disk space caching is enabled
[   11.879366] BTRFS: detected SSD devices, enabling SSD mode
[   12.160267] BTRFS info (device dm-3): turning on discard
[   12.160272] BTRFS info (device dm-3): enabling auto defrag
[   12.160275] BTRFS info (device dm-3): enabling inode map caching
[   12.160277] BTRFS info (device dm-3): disk space caching is enabled
[   14.979093] BTRFS: device label home devid 1 transid 705779 /dev/dm-5
[   15.013978] BTRFS info (device dm-5): use ssd allocation scheme
[   15.013983] BTRFS info (device dm-5): turning on discard
[   15.013987] BTRFS info (device dm-5): enabling auto defrag
[   15.013989] BTRFS info (device dm-5): enabling inode map caching
[   15.013991] BTRFS info (device dm-5): disk space caching is enabled
[   15.100779] BTRFS error (device dm-5): could not find root 8
[   15.102889] BTRFS error (device dm-5): could not find root 8
[   15.105833] BTRFS error (device dm-3): could not find root 8
[   15.105838] BTRFS error (device dm-3): could not find root 8

