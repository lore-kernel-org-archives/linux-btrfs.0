Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:47339 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726003AbeHOFnR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 01:43:17 -0400
Date: Wed, 15 Aug 2018 10:52:56 +0800
From: Liu Bo <bo.liu@linux.alibaba.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove duplicated btrfs_release_path in
 btrfs_unlink_subvol
Message-ID: <20180815025256.6fftocnncloellm3@rsjd01523.et2sqa>
Reply-To: bo.liu@linux.alibaba.com
References: <1534214829-26202-1-git-send-email-bo.liu@linux.alibaba.com>
 <20180814104600.GE24025@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180814104600.GE24025@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 14, 2018 at 12:46:00PM +0200, David Sterba wrote:
> On Tue, Aug 14, 2018 at 10:47:09AM +0800, Liu Bo wrote:
> > The btrfs_release_path() is just useless as path is only used in error handling.
> 
> Where is it duplicated? And I don't think it's useless, while the
> changelog does not explain why and it's not obvious from the context. If
> the path is locked, then releasing it right after it's not needed makes
> sense.  There are several potentially heavyweight operations between the
> release and final free.

I see, the diff context is a little bit misleading, the logic in
btrfs_unlink_subvol() is like,

{
	...
	btrfs_delete_one_dir_name(path);
	btrfs_release_path(path);

	ret = btrfs_del_root_ref(); <<<< path is not used here.
	if (ret < 0) {
	   	btrfs_search_dir_index_item(path);
		btrfs_release_path(path);
	}
	btrfs_release_path(path);   <<<< path has been released anyway.
	...
}

thanks,
-liubo
