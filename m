From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [Btrfs-devel] transaction ioctls
Date: Tue, 22 Apr 2008 13:29:25 -0700
Message-ID: <480E4AA5.1070700@oracle.com>
References: <Pine.LNX.4.64.0804221210130.23551@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: btrfs-devel@oss.oracle.com, linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804221210130.23551@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>


> A misbehaving application could also deliberately hold a transaction open, 
> effectively locking up the FS, so it may make sense to restrict something 
> like this to root or something.

I suspect it doesn't have to be deliberate.

Have you tried this under memory pressure?  I wonder if the application
can get stuck waiting for memory which will only be freed once the
transaction closes.

I'm reasonably sure that we've discussed this persistent theoretical
problem with these kinds of interfaces ;).

- z
