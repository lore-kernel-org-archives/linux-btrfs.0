From: Sage Weil <sage@newdream.net>
Subject: Re: [Btrfs-devel] transaction ioctls
Date: Tue, 22 Apr 2008 13:52:53 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0804221349200.23551@cobra.newdream.net>
References: <Pine.LNX.4.64.0804221210130.23551@cobra.newdream.net>
 <480E4AA5.1070700@oracle.com> <200804221641.34817.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: btrfs-devel@oss.oracle.com, Zach Brown <zach.brown@ORACLE.COM>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@ORACLE.COM>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200804221641.34817.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 22 Apr 2008, Chris Mason wrote:
> Ok, really though, I seem to remember that ceph needed to do file + xattr 
> operations in one atomic shot, were there others?

The transactions generally look like

 write(a)
 setxattr(a)
 write(b)
 setxattr(b)

It _could_ be broken down into write intent, do X, log X, such that the 
atomicity isn't strictly necessary, but itd be so much nicer to just wrap 
things up into tidy transactions.

sage
