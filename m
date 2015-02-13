Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbbBMPuh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Feb 2015 10:50:37 -0500
Date: Fri, 13 Feb 2015 16:50:35 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v8 9/9] btrfs: Use sb_want_write() to protect sysfs
 feature change.
Message-ID: <20150213155035.GJ8720@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1423705814-18007-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423705814-18007-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 12, 2015 at 09:50:14AM +0800, Qu Wenruo wrote:
> Just like label change, use sb_want_write() to do a correct protection.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> v4:
>   Newly introduced.
> v5:
>   Change to sb_want_write().
> v6:
>   Move sb_want_write() to the beginning of the function.
> v7:
>   None
> v8:
>   Move sb_want_write() after get fs_info.
> ---
>  fs/btrfs/sysfs.c | 27 ++++++++++++++++++---------
>  1 file changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 7e548f7..2e8cc34 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -119,12 +119,16 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
>  
>  	fs_info = to_fs_info(kobj);
>  	if (!fs_info)
> -		return -EPERM;
> +		ret = -EPERM;

Same patch version (v8), different code and buggy in a different way :)
but the fix is the same.
