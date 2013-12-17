Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57978 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab3LQPJU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 10:09:20 -0500
Date: Tue, 17 Dec 2013 16:09:19 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, miaox@cn.fujitsu.com, mwd@md5i.com
Subject: Re: [PATCH] Btrfs-progs: receive: fix the case that we can not find
 subvolume
Message-ID: <20131217150919.GP6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1387271629-11315-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1387271629-11315-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 17, 2013 at 05:13:49PM +0800, Wang Shilong wrote:
> If we change our default subvolume, btrfs receive will fail to find
> subvolume. To fix this problem, i have two ideas.
> 
> 1.make btrfs snapshot ioctl support passing source subvolume's objectid

> 2.when we want to using interval subvolume path, we mount it other place
> that use subvolume 5 as its default subvolume.

3. Tell the user to mount the toplevel subvol by himself and run receive
   again

> We'd better use the second approach because it won't bother kernel change.

I don't think that the silent mount is the right way to fix it, that way
the btrfs tool tooks responsibility not to break anything.  Like the
unhandled umount failure below. I think admins and power users do not
like to see some random tool mess with the system like this.

> @@ -199,6 +200,10 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
>  	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
>  	struct btrfs_ioctl_vol_args_v2 args_v2;
>  	struct subvol_info *parent_subvol = NULL;
> +	char *dev = NULL;
> +	char tmp_name[15] = "btrfs-XXXXXX";
> +	char tmp_dir[30] = "/tmp";

Mounting valuable data under /tmp is dangerous, what if some /tmp
cleaner starts to remove old files. I've seen that happen in practice.

> @@ -269,10 +308,14 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
>  		fprintf(stderr, "ERROR: creating snapshot %s -> %s "
>  				"failed. %s\n", parent_subvol->path,
>  				path, strerror(-ret));
> -		goto out;
>  	}
>  
> +out_umount:
> +	umount(tmp_dir);

umount fails for whatever reason,

> +	rmdir(tmp_dir);

at least this does not delete the files recursively.
