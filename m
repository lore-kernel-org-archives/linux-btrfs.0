Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:35410 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaHDOr0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 10:47:26 -0400
From: Russell Coker <russell@coker.com.au>
To: Peter Waller <peter@scraperwiki.com>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC with mkdir and rename
Date: Tue, 05 Aug 2014 00:47:21 +1000
Message-ID: <6493655.Zcj5VSyTA2@xev>
In-Reply-To: <CAFChkqv3N27jWxL=URgkZ1G86BFBo+-Cmg9emOO3G80OKY2n4g@mail.gmail.com>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com> <20140804113231.GD31950@carfax.org.uk> <CAFChkqv3N27jWxL=URgkZ1G86BFBo+-Cmg9emOO3G80OKY2n4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 4 Aug 2014 14:17:02 Peter Waller wrote:
> For anyone else having this problem, this article is fairly useful for
> understanding disk full problems and rebalance:
> 
> http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-> Full-Problems.html
> 
> It actually covers the problem that I had, which is that a rebalance
> can't take place because it is full.
> 
> I still am unsure what is really wrong with this whole situation. Is
> it that I wasn't careful to do a rebalance when I should have been
> doing? Is it that BTRFS doesn't do a rebalance automatically when it
> could in principle?

Yes and yes.  The fact that BTRFS can't avoid getting into such situations and 
can't recover when it does are both bugs in BTRFS.  The fact that you didn't 
run a balance to prevent this is due to not being careful enough with a 
filesystem that's still in a development stage.

> It's pretty bad to end up in a situation (with spare space) where the
> only way out is to add more storage, which may be impractical,
> difficult or expensive.

Absolutely.

> I conclude that now since I have added more storage, the rebalance
> won't fail and if I keep rebalancing from a cron job I won't hit this
> problem again

Yes.

> (unless the filesystem fills up very fast! what then?).
> I don't know however what value to assign to `-dusage` in general for
> the cron rebalance. Any hints?

If you regularly run a scrub with options such as "-dusage=50 -musage=10" then 
the amount of free space in metadata chunks will tend to be a lot greater than 
that in data chunks.

Another option I've considered is to write a program that creates millions of 
files with 1000 byte random file names.  After creating a filesystem I could 
run that program to cause a sufficient number of metadata chunks to be 
allocated and then remove the subvol containing all those files (which 
incidentally is a lot faster than "rm -rf").

Another thing I've considered is making a filesystem for a file server with a 
RAID-1 array of SSDs and running the above program to allocate all chunks for 
metadata.  Then when the SSDs are totally assigned to metadata I would add a 
pair of SATA disks for data.  A filesystem with all metadata on SSD and all 
data on SATA disks should give great performance as well as having lots of 
space.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

