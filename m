Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbaFBR1j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jun 2014 13:27:39 -0400
Date: Mon, 2 Jun 2014 19:27:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH v2 3/4] Btrfs-progs: fsck: deal with corrupted csum root
Message-ID: <20140602172736.GE22324@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401357597-9494-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1401357597-9494-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401357597-9494-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 29, 2014 at 05:59:57PM +0800, Wang Shilong wrote:
> If checksum root is corrupted, fsck will get segmentation. This
> is because if we fail to load checksum root, root's node is NULL which
> cause NULL pointer deferences later.
> 
> To fix this problem, we just did something like extent tree rebuilding.
> Allocate a new one and clear uptodate flag. We will do sanity check
> before fsck going on.

I'm a bit worried about recommending --init-csum-root, though in this
case there's not much else left to do. A filesystem with initialized
csum tree will mount, but reading non-inline data will produce 'csum
missing' errors.

> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -6963,6 +6963,11 @@ int cmd_check(int argc, char **argv)
>  		ret = -EIO;
>  		goto close_out;
>  	}
> +	if (!extent_buffer_uptodate(info->csum_root->node)) {
> +		fprintf(stderr, "Checksum root corrupted, rerun with --init-csum-tree option\n");
> +		ret = -EIO;
> +		goto close_out;

So this should prevent segfaults due to missing csum tree, fine. The
error message can copy what the broken extent tree reports a few lines
above.

And now that I'm looking at other extent_buffer_uptodate(tree) checks in
the function, for clarity, each root check should be done separately and
followed by a message that says which tree is broken.

The idea behind this is to do improve the error reporting and then
document what type of breakage can be fixed and how.

I'm CCing Chris, as this is a matter of design and direction of fsck,
more oppinions are desirable.
