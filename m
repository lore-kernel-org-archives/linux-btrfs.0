Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48624 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752674AbeGBRjS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2018 13:39:18 -0400
Date: Mon, 2 Jul 2018 10:39:14 -0700
From: Marc MERLIN <marc@merlins.org>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20180702173914.b3rddxjp67jhqrkf@merlins.org>
References: <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com>
 <20180629064354.kbaepro5ccmm6lkn@merlins.org>
 <20180701232202.vehg7amgyvz3hpxc@merlins.org>
 <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com>
 <20180702032259.GD5567@merlins.org>
 <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com>
 <20180702140527.wfbq5jenm67fvvjg@merlins.org>
 <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com>
 <20180702151903.j3j522urrtyznylf@merlins.org>
 <20180702223309.582f4e19@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180702223309.582f4e19@natsu>
Subject: Re: So, does btrfs check lowmem take days? weeks?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 02, 2018 at 10:33:09PM +0500, Roman Mamedov wrote:
> On Mon, 2 Jul 2018 08:19:03 -0700
> Marc MERLIN <marc@merlins.org> wrote:
> 
> > I actually have fewer snapshots than this per filesystem, but I backup
> > more than 10 filesystems.
> > If I used as many snapshots as you recommend, that would already be 230
> > snapshots for 10 filesystems :)
> 
> (...once again me with my rsync :)
> 
> If you didn't use send/receive, you wouldn't be required to keep a separate
> snapshot trail per filesystem backed up, one trail of snapshots for the entire
> backup server would be enough. Rsync everything to subdirs within one
> subvolume, then do timed or event-based snapshots of it. You only need more
> than one trail if you want different retention policies for different datasets
> (e.g. in my case I have 91 and 31 days).

This is exactly how I used to do backups before btrfs.
I did 

cp -al backup.olddate backup.newdate
rsync -avSH src/ backup.newdate/

You don't even need snapshots or btrfs anymore.
Also, sorry to say, but I have different data retention needs for
different backups. Some need to rotate more quickly than others, but if
you're using rsync, the method I gave above works fine at any rotation
interval you need.

It is almost as efficient as btrfs on space, but as I said, the time
penalty on all those stats for many files was what killed it for me.
If I go back to rsync backups (and I'm really unlikely to), then I'd
also go back to ext4. There would be no point in dealing with the
complexity and fragility of btrfs anymore.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
