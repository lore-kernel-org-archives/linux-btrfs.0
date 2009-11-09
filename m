From: Andi Drebes <lists-receive@programmierforen.de>
Subject: Re: [PATCH] Prevent btrfsck to run on mounted filesystems
Date: Mon, 9 Nov 2009 15:59:06 +0100
Message-ID: <200911091559.06478.lists-receive@programmierforen.de>
References: <200910292152.15564.lists-receive@programmierforen.de> <20091030130510.GD2750@think> <200910312146.21384.lists-receive@programmierforen.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200910312146.21384.lists-receive@programmierforen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

> > In this case O_EXCL is going to be more accurate just because the
> > mounted check doesn't cover every disk in the FS.  For now btrfsck
> > doesn't really give consistent results even readonly on a mounted
> > filesystem.  We should prevent it with a message just to prevent
> > confusion.
> Thanks for the reply. I'll do this as soon as I understand the code
> that is affected by those changes (I'm still in the learning phase
> and stepping through the code).   

OK, I've stepped through the code so far and I think I now have an idea of what should be changed. However, concerning the solution, I was confusing two things.

Christoph Hellwig earlier wrote:
> Just open the nodes with O_EXCL and you'll get all the checking for
> free.
I thought that open() with O_EXCL would fail if the file is already opened RW somewhere else. But the man page for open() says something else:

"O_EXCL: Ensure that this call creates the file: if this flag  is  specified  in  conjunction with O_CREAT, and pathname already exists, then open() will fail."

And especially:

"The behavior of O_EXCL is  undefined if O_CREAT is not specified."

After having read this, I don't see how this can help to prevent btrfsck to open a device that is mounted. What am I getting wrong? Currently, I would do the same check as in the original patch, but in btrfs_open_devices() instead of main().

	Cheers,
		Andi
