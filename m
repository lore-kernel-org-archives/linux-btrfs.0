Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbbA2MiA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Jan 2015 07:38:00 -0500
Date: Thu, 29 Jan 2015 13:37:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        viro@ZenIV.linux.org.uk
Subject: Re: [PATCH RESEND v4 6/8] vfs: Add get_vfsmount_sb() function to get
 vfsmount from a given sb.
Message-ID: <20150129123758.GJ3641@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1422498281-20493-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1422498281-20493-7-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422498281-20493-7-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adding Al Viro into CC

On Thu, Jan 29, 2015 at 10:24:39AM +0800, Qu Wenruo wrote:
> +struct vfsmount *get_vfsmount_sb(struct super_block *sb)
> +{
> +	struct vfsmount *ret_vfs = NULL;
> +	struct mount *mnt;
> +	int ret = 0;
> +
> +	lock_mount_hash();
> +	if (list_empty(&sb->s_mounts))
> +		goto out;
> +	mnt = list_entry(sb->s_mounts.next, struct mount, mnt_instance);

from include/linux/fs.h:

struct super_block {
...
	struct list_head        s_mounts;       /* list of mounts; _not_ for fs use */
...
};

I hear a storm in the distance coming our direction ... so I'll
preemptively NAK this change.
