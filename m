From: Stewart Smith <stewart@flamingspork.com>
Subject: Re: [PATCH][RFC] Complex filesystem operations: split and join
Date: Tue, 22 Jun 2010 09:26:16 +0800
Message-ID: <87fx0fuabr.fsf@willster.local.flamingspork.com>
References: <201006092035.46481.knikanth@novell.com> <87aaqzp39a.fsf@devron.myhome.or.jp> <201006151611.36443.knikanth@novell.com> <e4ea1892f15eaac945c151ea14a5d2d9.squirrel@www.chrestomanci.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@lst.de>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: David Pottage <david@electric-spoon.com>,
	Nikanth Karthikesan <knikanth@novell.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e4ea1892f15eaac945c151ea14a5d2d9.squirrel@www.chrestomanci.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 15 Jun 2010 16:16:06 +0100, "David Pottage" <david@electric-spoon.com> wrote:
> On the other hand, perhaps databases such as SQLite or MySQL would
> benifit from this feature for improving their backend storage, especaly
> if large amounts of BLOB data is inserted or deleted?

unlikely.

1) these operations aren't available everywhere
2) kind of incompatible with how things are stored now
3) no doubt incredibly fun with high concurrency (readers streaming out
BLOBs from later in the file while you go and change everything)
4) a background thread that goes around repacking things if you need to
trim the end off the file just isn't that bad.
   (sure, a nice api call to 'instantly' copy/swap parts of a file could
   be fun... but then it's relying on the OS and file system to get this
   right... which is almost always a bad idea)

cheers,

Stewart "spending way too much time inside databases to maintain sanity" Smith
