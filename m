From: Andi Drebes <lists-receive@programmierforen.de>
Subject: Re: [PATCH] Prevent btrfsck to run on mounted filesystems
Date: Sat, 31 Oct 2009 21:46:21 +0100
Message-ID: <200910312146.21384.lists-receive@programmierforen.de>
References: <200910292152.15564.lists-receive@programmierforen.de> <20091030050243.GA17714@infradead.org> <20091030130510.GD2750@think>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091030130510.GD2750@think>
List-ID: <linux-btrfs.vger.kernel.org>

> > Just open the nodes with O_EXCL and you'll get all the checking for
> > free.  Also make sure that for a pure, read-only checks instead of a
> > repair to allow running on at least a read-only mounted filesystem.
> 
> Thanks for working on this patch Andi.
> 
> In this case O_EXCL is going to be more accurate just because the
> mounted check doesn't cover every disk in the FS.  For now btrfsck
> doesn't really give consistent results even readonly on a mounted
> filesystem.  We should prevent it with a message just to prevent
> confusion.
Thanks for the reply. I'll do this as soon as I understand the code that is affected by those changes (I'm still in the learning phase and stepping through the code).

	Cheers,
		Andi
