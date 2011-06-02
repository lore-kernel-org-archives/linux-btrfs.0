From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: different st_dev's in one subvolume
Date: Thu, 2 Jun 2011 01:59:25 +0100
Message-ID: <20110602005925.GB4319@yahoo.fr>
References: <20110602003941.GA4319@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110602003941.GA4319@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

2011-06-02 01:39:41 +0100, Stephane Chazelas:
[...]
> /mnt/1# zstat +device ./**/*
> . 25
> A 26
> A/B 27
> A/B/inB 27
> A/inA 26
> A.snap 28
> A.snap/B 23
> A.snap/inA 28
> 
> Why does A.snap/B have a different st_dev from A.snap's?
[...]
> If I create another snap of A or A.snap, the "B" in there gets
> the same st_dev (23).
[...]

And same inode, ctime, mtime, atime... And when I create a new
snapshot, all those (regardless of where they are) have their
times updated at once.

I also noticed the st_nlink is always one but then came accross
http://thread.gmane.org/gmane.comp.file-systems.btrfs/4580

-- 
Stephane
