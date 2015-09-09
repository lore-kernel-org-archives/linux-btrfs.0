Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbbIIPm0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Sep 2015 11:42:26 -0400
Date: Wed, 9 Sep 2015 17:41:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs-progs: Avoid uninitialized data in output of
 btrfs-convert
Message-ID: <20150909154139.GK8891@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1441718128.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1441718128.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 08, 2015 at 09:16:48PM +0800, Zhao Lei wrote:
> sequence, transid and reserved field of inode was write to disk
> with uninitizlized value, this patchset fixed it, also fixed some
> other typo.
> 
> Zhao Lei (3):
>   btrfs-progs: fix set_get typo of btrfs_inode_item->sequence
>   btrfs-progs: Avoid uninitialized data in output of btrfs-convert
>   btrfs-progs: add ext2fs_close_inode_scan to copy_inodes

Applied, thanks.
