Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:36720 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaETQvt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 12:51:49 -0400
Received: by mail-ig0-f174.google.com with SMTP id h3so5098549igd.13
        for <linux-btrfs@vger.kernel.org>; Tue, 20 May 2014 09:51:49 -0700 (PDT)
Message-ID: <1400604702.21590.7.camel@sasami.ottawa.blindsidenetworks.com>
Subject: Re: btrfs fi df output is not updated in a timely manner after
 subvolumes have been deleted
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Astro Xe <astroxeu@yahoo.it>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Tue, 20 May 2014 12:51:42 -0400
In-Reply-To: <1400593601.31978.YahooMailNeo@web172201.mail.ir2.yahoo.com>
References: <1400593601.31978.YahooMailNeo@web172201.mail.ir2.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2014-05-20 at 14:46 +0100, Astro Xe wrote:
> On my box, the "used" value in the output of "btrfs filesystem df" is
> not updated in a timely manner, after that one or more subvolumes have
> been deleted. I need to execute "btrfs filesystem sync", in order to
> update the value. Could someone fix this, please? I suspect the cause
> is that subvolumes are marked immediately as deleted, but cleanedup at
> a later time, is this right?

Yes, this is exactly true. After you delete a subvolume on btrfs, the
"btrfs-cleaner" kernel process has to before the space is actually freed
up. This process goes through all the contents of the subvolume,
determines which files aren't being shared with other subvolumes or
reflinks, and frees the space for those.

The problem is that it doesn't make sense to update the free space
immediately - and it's not really possible to do it either.

It doesn't make sense to update the free space immediately, because the
space isn't actually usable immediately. Before you can create new files
that use this space, you have to wait for the cleaner process to run and
delete the old files.

It's not really possible to update the free space immediately, because
the filesystem doesn't actually know how much space would be freed! In
order to determine this number, the filesystem has to check all the
files in the subvolume - which is what btrfs-cleaner is doing.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

