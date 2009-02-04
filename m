From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] New fs-specific Kconfig options should go in
 fs/$FS/Kconfig, not fs/Kconfig.
Date: Wed, 04 Feb 2009 13:59:31 -0500
Message-ID: <1233773971.20318.62.camel@think.oraclecorp.com>
References: <1233716308-19702-1-git-send-email-jeffm@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Btrfs Development List <linux-btrfs@vger.kernel.org>,
	Jeff Mahoney <jeffm@suse.com>
To: Jeff Mahoney <jeffm@jeffreymahoney.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1233716308-19702-1-git-send-email-jeffm@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-02-03 at 21:58 -0500, Jeff Mahoney wrote:
> Commit 699b6faa2ab283219914501d5117f8a93c7e441b allowed btrfs ACLs to
>  be selectable, but put the option in the main fs/Kconfig, and didn't
>  make it depend on btrfs.
> 
>  This patch moves the option and adds the dependency.
> 

FYI, I did merge this but folded it into the original ACL patch.  I
rebased the tree because Yan found a bug that could cause corruption
during btrfs-vol -b processing.

So, if you've pulled the unstable tree, you'll want to pull again and
git gc

-chris


