From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] rewrite btrfs_readdir()
Date: Mon, 18 Aug 2008 14:46:56 -0400
Message-ID: <1219085216.14063.9.camel@think.oraclecorp.com>
References: <200807210201.56690.balajirrao@gmail.com>
	 <200808171821.43874.balajirrao@gmail.com>
	 <1218977763.3184.288.camel@pmac.infradead.org>
	 <200808171854.14275.balajirrao@gmail.com>
	 <1218979817.3184.296.camel@pmac.infradead.org>
	 <1218982640.3184.307.camel@pmac.infradead.org>
	 <1218989400.3184.315.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Balaji Rao <balajirrao@gmail.com>, linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218989400.3184.315.camel@pmac.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2008-08-17 at 17:10 +0100, David Woodhouse wrote:
> On Sun, 2008-08-17 at 15:17 +0100, David Woodhouse wrote:
> > Subject: [PATCH] Remove special cases for "." and ".."
> > 
> > We never get asked by the VFS to lookup either of them, and we can
> > handle the readdir() case a lot more simply, too.
> 
> And a few other minor cleanups... some cosmetic, but note the
> WARN_ON().

> +
> +			/* If there's more than one directory entry in each
> +			   item, then the offset isn't unique. Seeking in 
> +			   directories will be broken. Can this ever actually
> +			   happen? */
> +			WARN_ON(di_cur != di_total);
>  		}

It can happen today for the tree of tree roots (directory of subvolumes
and named snapshots).  It happens when the name hashes collide.  For
real directories we use the sequence number index instead of the name
hash index, so it normally won't happen.

Longer term the directory of subvolumes is going to be a real directory
and this special case will go away.

-chris


