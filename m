Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:43403 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaELCrg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 May 2014 22:47:36 -0400
Received: by mail-pa0-f44.google.com with SMTP id ld10so7326652pab.31
        for <linux-btrfs@vger.kernel.org>; Sun, 11 May 2014 19:47:36 -0700 (PDT)
Date: Mon, 12 May 2014 10:42:53 +0800
From: Guangliang Zhao <lucienchao@gmail.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove OPT_acl parse when acl disabled
Message-ID: <20140512024253.GA8573@work-station>
References: <1399524992-10810-1-git-send-email-lucienchao@gmail.com>
 <20140509132109.GZ5988@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140509132109.GZ5988@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 09, 2014 at 03:21:09PM +0200, David Sterba wrote:
> On Thu, May 08, 2014 at 12:56:32PM +0800, Guangliang Zhao wrote:
> > Even CONFIG_BTRFS_FS_POSIX_ACL is not defined, the acl still could
> > been enabled using a mount option, and now fs/btrfs/acl.o is not
> > built, so the mount options will appear to be supported but will
> > be silently ignored.
> > 
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -579,9 +579,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
> >  				goto out;
> >  			}
> >  			break;
> > +#ifdef CONFIG_BTRFS_FS_POSIX_ACL
> >  		case Opt_acl:
> >  			root->fs_info->sb->s_flags |= MS_POSIXACL;
> >  			break;
> > +#endif
> 
> This will still silently accept the 'acl' mount option:
> 
>   token = match_token(p, tokens, args);
> 
> token will be Opt_acl
> 
> and in the switch(token), caught by the default: branch and will return 0.

Didn't take care of it, good catch :-). I will send V2 ASAP.

> 
> What' needed here is a #if/#else/#endif sequence where the #else block
> says that something like "acls requested but not compiled in".
> 
> Similar to how the Opt_check_integrity* options are handled.
> 
> >  		case Opt_noacl:
> >  			root->fs_info->sb->s_flags &= ~MS_POSIXACL;
> >  			break;

-- 
Best regards,
Guangliang
