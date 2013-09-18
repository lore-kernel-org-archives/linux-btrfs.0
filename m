Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52817 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915Ab3IRQba (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 12:31:30 -0400
Date: Wed, 18 Sep 2013 18:31:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: dsterba@suse.cz, Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] Btrfs-progs: add super-recover to recover bad supers
Message-ID: <20130918163127.GF6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1379492856-30639-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1379492856-30639-5-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <20130918151304.GD6810@twin.jikos.cz>
 <936776EC-7D7D-458F-960E-E1CB56F9B4BA@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <936776EC-7D7D-458F-960E-E1CB56F9B4BA@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 18, 2013 at 11:31:16PM +0800, Wang Shilong wrote:
> >> static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
> >> 					     u64 sb_bytenr,
> >> 					     u64 root_tree_bytenr, int writes,
> >> -					     int partial, int restore)
> >> +					     int partial, int restore,
> >> +					     int run_ioctl)
> > 
> > Yet another parameter to __open_ctree_fd, this really needs a cleanup.
> > (Later is fine.)
> 
> I have considered about this, __open_ctree_fd() is a *static* helper, if i don't
> add another parameter to it. I have to move out of __open_ctree_fd()  into
> open_ctree_with_broken_super() which also seems  not good!

The idea is that all open_ctree* variants will take one parameter that
accumulates what's currently passed via writes/partial/restore/run_ioctl:

#define OPEN_CTREE_PARTIAL 	(1 << 0ULL)
#define OPEN_CTREE_WRITES	(1 << 1ULL)
etc ...

static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
					     u64 sb_bytenr,
					     u64 root_tree_bytenr,
					     unsigned open_flags)

and the callers updated accordingly. The calls then look like

- open_ctree_fs_info_restore(target, 0, 0, 0, 1);
+ open_ctree_fs_info_restore(target, 0, 0, OPEN_CTREE_PARTIAL);
