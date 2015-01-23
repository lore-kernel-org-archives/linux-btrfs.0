Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbbAWRjK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 12:39:10 -0500
Date: Fri, 23 Jan 2015 18:39:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Miao Xie <miaoxie@huawei.com>, Chris Mason <clm@fb.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Don't call btrfs_start_transaction() on frozen fs
 to avoid deadlock.
Message-ID: <20150123173909.GS13289@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <54BEF99D.7090104@cn.fujitsu.com>
 <1421802329.27917.8@mail.thefacebook.com>
 <54BEFC56.3000403@cn.fujitsu.com>
 <1421802656.27917.9@mail.thefacebook.com>
 <54BF189C.4070201@huawei.com>
 <54BF19DD.8060600@cn.fujitsu.com>
 <54BF1C5B.509@huawei.com>
 <54BF22BE.3080606@cn.fujitsu.com>
 <54BF4F62.3010805@huawei.com>
 <54BF59AA.9070408@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54BF59AA.9070408@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 21, 2015 at 03:47:54PM +0800, Qu Wenruo wrote:
> To David:
> I'm a little curious about why inode_cache needs to be delayed to next 
> transaction.
> In btrfs_remount() we have s_umount mutex, and we synced the whole 
> filesystem already,
> so there should be no running transaction and we can just set any mount 
> option into fs_info.

See our discussion under the noinode_cache option:

http://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg30075.html
http://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg30414.html

> What do you think about reverting the whole patchset and rework the 
> sysfs interface?

IMO reverting should be the last option, we have a minimal fix to the
sync deadlock and you've proposed the per-trasaction mount options to
replace the pending inode_change.
