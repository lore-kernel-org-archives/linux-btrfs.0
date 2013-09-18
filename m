Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50038 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab3IRPNH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 11:13:07 -0400
Date: Wed, 18 Sep 2013 17:13:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] Btrfs-progs: add super-recover to recover bad supers
Message-ID: <20130918151304.GD6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1379492856-30639-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1379492856-30639-5-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1379492856-30639-5-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 18, 2013 at 04:27:36PM +0800, Wang Shilong wrote:
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -982,7 +982,8 @@ int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info)
>  static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
>  					     u64 sb_bytenr,
>  					     u64 root_tree_bytenr, int writes,
> -					     int partial, int restore)
> +					     int partial, int restore,
> +					     int run_ioctl)

Yet another parameter to __open_ctree_fd, this really needs a cleanup.
(Later is fine.)

> +	root = open_ctree_with_broken_super(record->device_name,
> +					record->bytenr, O_RDWR);

The last parameter is 'writes', I think it's 0/1, not the open() flags.

> +	BUG_ON(!root);

Is it a fatal error to BUG_ON here? Please add proper error handling.

thanks,
david
