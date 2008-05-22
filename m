From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC][PATCH]btrfs delete ordered inode handling fix
Date: Thu, 22 May 2008 18:23:26 -0400
Message-ID: <200805221823.26532.chris.mason@oracle.com>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net> <200805221347.22421.chris.mason@oracle.com> <1211488759.8596.54.camel@BVR-FS.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1211488759.8596.54.camel@BVR-FS.beaverton.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 22 May 2008, Mingming wrote:

[ ... ]

> > I get around this by testing for dirty/writeback pages before removing
> > the inode from the ordered list.  If another writer allocates blocks to
> > the file, it will be added back to the list.
>
> I see.:) How about patch below?

Looks good, I'll give it a shot here.

-chris
