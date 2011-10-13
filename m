From: "krzf83@gmail.com " <krzf83@gmail.com>
Subject: Re: is space really freed after deleting large subvolume?
Date: Thu, 13 Oct 2011 23:03:57 +0200
Message-ID: <CAJ1PRS=d4Ly3p-t1L9-wXcaHA=zw05Lu=84+=AnF+77HJJLvfg@mail.gmail.com>
References: <CAJ1PRSmDmd4mrUaQAhjCt1SMtVaBVxq3dCVjCuT20Y4Wf+Ch+Q@mail.gmail.com>
	<20111013162104.GG21931@carfax.org.uk>
	<CAJ1PRSmHecopafvi_oXDjeSFntZHWH2a714usf7ujrUA14SHCQ@mail.gmail.com>
	<CAJ1PRS=hJmj-sFRmAqtWcvwawNmCzWvfa3paH5dc_mfTgnUn7g@mail.gmail.com>
	<4E9743A8.1050806@electric-spoon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
To: David Pottage <david@electric-spoon.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E9743A8.1050806@electric-spoon.com>
List-ID: <linux-btrfs.vger.kernel.org>

>btrfs like ext4 has support for extents, which can be >any size, so
>typically if you delete a large file, then it occupies only >one extent,
>so only that one extent needs to be marked as free, so a >lot less I/O.

I know, I know. Issue is with many (small) files.

> If you delete a large number of files, then there is no avoiding the
> fact that a lot of metadata needs to be updated. In this respect btrfs
> is unlikely to be significantly faster than any other filing system.

Are you sure? That would mean that instant deletion of subvolume in
btrfs is actualy taking ??SAME?? time and io power in BACKGROUND like
deleting by rm -rf in any filesystem.
Common misconception would be that subvolume deletion is much more
efficient and near zero time consuming. I think it is very important
to clear that up.
