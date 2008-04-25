From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [Btrfs-devel] cloning file data
Date: Fri, 25 Apr 2008 10:04:43 -0700
Message-ID: <48120F2B.9050009__49768.625960178$1209143179$gmane$org@oracle.com>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net> <200804250941.35343.chris.mason@oracle.com> <48120BDC.9000900@oracle.com> <200804251258.21129.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Sage Weil <sage@newdream.net>, btrfs-devel@oss.oracle.com,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200804251258.21129.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>


> Running debug-tree on a live FS is a very good way to learn about trees that 
> get left around while snapshot deletion is happening and cache aliasing 
> caused by the way Btrfs puts metadata into its own address space.
> 
> But, if you're trying to learn the disk format, I'd stick an unmount between 
> the dd and the debug-tree ;)

Haha, true, true.  If you don't know to watch for confusing racey
results, indeed, serialize around each dump :).

- z
