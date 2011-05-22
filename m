From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/2] fs: add a DCACHE_NEED_LOOKUP flag for d_flags V2
Date: Sun, 22 May 2011 03:11:30 +0100
Message-ID: <20110522021130.GI19987@ZenIV.linux.org.uk>
References: <1305913471-3150-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger@dilger.ca, hch@lst.de
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305913471-3150-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 20, 2011 at 01:44:30PM -0400, Josef Bacik wrote:
> +		if (unlikely(d_need_lookup(dentry))) {
> +			if (nameidata_dentry_drop_rcu(nd, dentry))
> +				return -ECHILD;
> +			dput(dentry);
> +			dentry = NULL;
> +			goto retry;

Yecchhh...  How about simple goto unlazy; here instead and doing the rest
there?  Especially since you have the same kind of thing elsewhere in the
same sucker.  It had been bloody painful to untangle that thing; let's not
add to the rat's nest that still remains...
