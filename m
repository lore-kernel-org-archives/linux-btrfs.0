Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.114.20]:44045 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbbACV6i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Jan 2015 16:58:38 -0500
Date: Sun, 4 Jan 2015 02:58:35 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: I need to P. are we almost there yet?
Message-ID: <20150104025835.02f0d6b8@natsu>
In-Reply-To: <pan$872b8$2e173aaa$59613c61$c4e30dfd@cox.net>
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>
 <54A7D3D1.10508@shiftmail.org>
 <pan$872b8$2e173aaa$59613c61$c4e30dfd@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 3 Jan 2015 13:11:57 +0000 (UTC)
Duncan <1i5t5.duncan@cox.net> wrote:

> > What about using btrfs on top of MD raid?
> 
> The problem with that is data integrity.  mdraid doesn't have it.  btrfs 
> does.

Most importantly however, you aren't any worse off with Btrfs on top of MD,
than with Btrfs on a single device, or with Ext4/XFS/JFS/etc on top of MD.

Sure you don't get checksum-based recovery from partial corruption of a RAID,
but you do get other features of Btrfs, such as robust snapshot support,
ability to online-resize up and down, compression, and actually, checksum
verification: even if it won't be able to recover from a corruption, at least
it will warn you of it (and you could recover from backups), while other FSes
will pass through the corrupted data silently.

So until Btrfs multi-device support is feature-complete (and yes that includes
performance-wise), running Btrfs in single-device mode on top of MD RAID is
arguably the most optimal way to use Btrfs in a RAID setup.

(Personally I am running Btrfs on top of 7x2TB MD RAID6, 3x2TB MD RAID5 and
2x2TB MD RAID1).

-- 
With respect,
Roman
