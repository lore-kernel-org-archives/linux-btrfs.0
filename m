Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbaKGSQa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Nov 2014 13:16:30 -0500
Date: Fri, 7 Nov 2014 19:16:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: fix wrong num_devices for btrfs fi show
 with seed devices
Message-ID: <20141107181628.GE25615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1415326063-8838-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <1415326063-8838-3-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1415326063-8838-3-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 07, 2014 at 10:07:43AM +0800, Gui Hecheng wrote:
> The @fi_args->num_devices in @get_fs_info() does not include seed devices.
> We could just correct it by searching the chunk tree and count how
> many dev_items there are in total which includes seed devices.
> 
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> ---
> *Note*
> This is just a temporary workaround to fix this problem in order to
> make users happy, because a new ioctl or sysfs interface to handle this
> problem needs more discussions and efforts. After the work implemented
> and accepted, we could drop this.

Nice, thanks. I agree that this kind of workaround is best possible for
the moment, and I'm glad to see that it's not that much code to get the
seeding devices right. This would also work with older kernels without
the updated sysfs/ioctl interfaces, so this is likely to stay for a long
time.

> +u64 find_max_id(struct btrfs_ioctl_search_args *search_args, int nr_items)

That's a very generic name for a function that does a very specialized
thing, but I don't have a suggestion right now.

> +int correct_fs_info(int fd, struct btrfs_ioctl_fs_info_args *fi_args)

Same here, make fs_info correct but in what way? A comment would be good
as well.
