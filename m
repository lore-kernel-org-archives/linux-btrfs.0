From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] fix wrong value returned from btrfs_listxattr when
 buffer is too small
Date: Thu, 18 Dec 2008 20:42:22 -0500
Message-ID: <1229650942.27170.220.camel@think.oraclecorp.com>
References: <a37615150812121436w57f43184g71b297369f3923e1@mail.gmail.com>
	 <Pine.LNX.4.64.0812181623440.10436@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org,
	Yehuda Sadeh Weinraub <yehudasa@gmail.com>
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0812181623440.10436@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-12-18 at 16:25 -0800, Sage Weil wrote:
> BTW it looks like the commit log made it into git, but not the patch 
> itself... :)
> 

Ugh.  The patch was malformed and I thought I fixed it.  I think guilt
is making it easy for me to mess this up ;)  Thanks, will fix.

-chris


