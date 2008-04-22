From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Btrfs-devel] transaction ioctls
Date: Tue, 22 Apr 2008 16:55:37 -0400
Message-ID: <200804221655.38102.chris.mason@oracle.com>
References: <Pine.LNX.4.64.0804221210130.23551@cobra.newdream.net> <200804221641.34817.chris.mason@oracle.com> <Pine.LNX.4.64.0804221349200.23551@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: btrfs-devel@oss.oracle.com, Zach Brown <zach.brown@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804221349200.23551@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 22 April 2008, Sage Weil wrote:
> On Tue, 22 Apr 2008, Chris Mason wrote:
> > Ok, really though, I seem to remember that ceph needed to do file + xattr
> > operations in one atomic shot, were there others?
>
> The transactions generally look like
>
>  write(a)
>  setxattr(a)
>  write(b)
>  setxattr(b)

Hmm, is this whole thing the atomic unit, or can a and b be done separately?

-chris
