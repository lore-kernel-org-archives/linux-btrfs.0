Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530AbaEINVK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 09:21:10 -0400
Date: Fri, 9 May 2014 15:21:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Guangliang Zhao <lucienchao@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove OPT_acl parse when acl disabled
Message-ID: <20140509132109.GZ5988@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1399524992-10810-1-git-send-email-lucienchao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1399524992-10810-1-git-send-email-lucienchao@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 08, 2014 at 12:56:32PM +0800, Guangliang Zhao wrote:
> Even CONFIG_BTRFS_FS_POSIX_ACL is not defined, the acl still could
> been enabled using a mount option, and now fs/btrfs/acl.o is not
> built, so the mount options will appear to be supported but will
> be silently ignored.
> 
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -579,9 +579,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>  				goto out;
>  			}
>  			break;
> +#ifdef CONFIG_BTRFS_FS_POSIX_ACL
>  		case Opt_acl:
>  			root->fs_info->sb->s_flags |= MS_POSIXACL;
>  			break;
> +#endif

This will still silently accept the 'acl' mount option:

  token = match_token(p, tokens, args);

token will be Opt_acl

and in the switch(token), caught by the default: branch and will return 0.

What' needed here is a #if/#else/#endif sequence where the #else block
says that something like "acls requested but not compiled in".

Similar to how the Opt_check_integrity* options are handled.

>  		case Opt_noacl:
>  			root->fs_info->sb->s_flags &= ~MS_POSIXACL;
>  			break;
