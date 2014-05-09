Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757189AbaEIUx1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 16:53:27 -0400
Date: Fri, 9 May 2014 13:53:25 -0700
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add a extent ref verify tool V2
Message-ID: <20140509205325.GC23244@lenny.home.zabbo.net>
References: <1399582528-24698-1-git-send-email-jbacik@fb.com>
 <20140508233414.GC12210@lenny.home.zabbo.net>
 <536D3E51.80209@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <536D3E51.80209@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 09, 2014 at 04:45:05PM -0400, Josef Bacik wrote:
> On 05/08/2014 07:34 PM, Zach Brown wrote:
> >>+#ifdef CONFIG_BTRFS_FS_REF_VERIFY
> >>+int btrfs_build_ref_tree(struct btrfs_fs_info *fs_info);
> >>+void btrfs_free_ref_cache(struct btrfs_fs_info *fs_info);
> >>+int btrfs_ref_tree_mod(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
> >>+		       u64 parent, u64 ref_root, u64 owner, u64 offset,
> >>+		       int action);
> >>+void btrfs_free_ref_tree_range(struct btrfs_fs_info *fs_info, u64 start,
> >>+			       u64 len);
> >>+#else
> >>+
> >>+#define btrfs_free_ref_cache(fs_info) do { } while (0)
> >>+#define btrfs_ref_tree_mod(root, bytenr, num_bytes, parent, ref_root,	\
> >>+			   owner, offset, action) do { } while (0)
> >>+#define btrfs_free_ref_tree_range(fs_info, start, len) do { } while (0)
> >>+
> >>+#endif /* CONFIG_BTRFS_FS_REF_VERIFY */
> >>+#endif /* _REF_VERIFY__ */
> >
> >Don't just omit the arguments when the config isn't enabled.  That can
> >let these calls bit rot over time as everyone build tests their changes
> >with the config disabled, as they will.
> >
> >	int derp;
> >
> >	...
> >
> >	btrfs_free_ref_cache(derp);
> >
> >	...
> >
> >-	derp++;
> >
> >
> >Will have gcc warn that derp is unused.  They'll delete it and send out
> >the patch.  You'll later turn on the config and get undefined derp
> >warnings.
> >
> >inline stubs are the best way out.  They'll still warn if the arg is
> >used undefined.  Putting (void)arg; in the macros doesn't warn in that
> >case.
> 
> Gcc doesn't complain when I build with it off but I can switch to inline
> stubs if that makes you feel better.  Thanks,

It's not about the code now.  It's about the code changing over time as
people only build it it disabled and break the build with it enabled.
This has happened to lots of interfaces in the kernel in the past.
This is why, for example, pr_devel() calls no_printk() instead of just
dropping the arguments on the floor.

- z
