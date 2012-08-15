Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:59461 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2HOEAy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Aug 2012 00:00:54 -0400
Date: Tue, 14 Aug 2012 21:00:53 -0700
From: Marc MERLIN <marc@merlins.org>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: linux 3.5.0: BTRFS error in compress_file_range:581 (failed to join transaction)
Message-ID: <20120815040053.GA22300@merlins.org>
References: <20120814182314.GF12659@merlins.org> <20120815024856.GL12659@merlins.org> <502B1147.5070901@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <502B1147.5070901@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 15, 2012 at 11:02:31AM +0800, Liu Bo wrote:
> On 08/15/2012 10:48 AM, Marc MERLIN wrote:
> > On Tue, Aug 14, 2012 at 11:23:14AM -0700, Marc MERLIN wrote:
> >> My laptop oopsed due to a wireless bug
> >>
> >> When I rebooted, the system came back ok, and seemed to work, but soon went
> >> to read only with the error in the subject line.
> >>
> >> I have hourly snapshots for each of the 5 subvolumes in that btrfs
> >> filesystem.
> >>
> >> How do I recover from this? Revert all the snapshots one hour, find/guess
> >> which one caused the problem somehow and revert just that one? (the error
> >> message didn't give a subvolume or directory).
> >>
> >> Also, before I do this, is there debug info I can get off my system?
> > 
> > I'm likely to have to do this tonight to get back to a working system.
> > 
> > If someone wants debug info before I lose it potentially, please ask soon ;)
> 
> What does the 'ret' shows?  Is it -ENOSPC?

I got nothing else in my logs.

I powered the laptop back on and it came up like nothing ever happened.

[   15.626700] device label btrfs_pool1 devid 1 transid 10222 /dev/mapper/cryptroot
[   15.627161] btrfs: disk space caching is enabled
[   15.631704] btrfs: bdev /dev/mapper/cryptroot errs: wr 0, rd 0, flush 0, corrupt 0, gen 0

It looks like the SSD was loose inside the laptop (the tray that holds it isn't quite the
right size it seems).
I think it may not have had a good connection, but what's interesting is that I 
got absolutely no lower level errors in dmesg (which didn't get written to disk).

All that said, I think it may just have been a write error due to a hardware 
connection problem (no way to prove this now).
If there is nothing suspicious in the code around that line, let's just ignore 
my report.

For what it's worth, I do have plenty of space left:
Label: 'btrfs_pool1'  uuid: 92584fa9-85cd-4df6-b182-d32198b76a0b
	Total devices 1 FS bytes used 227.44GB
	devid    1 size 441.70GB used 297.04GB path /dev/dm-0

Thanks for your reply.
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
