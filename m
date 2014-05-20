Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbaETQd4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 12:33:56 -0400
Date: Tue, 20 May 2014 18:33:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, sandeen@redhat.com, rm@romanrm.net
Subject: Re: [PATCH 1/2 v2] btrfs: label should not contain return char
Message-ID: <20140520163352.GL31608@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1400519071-5580-1-git-send-email-anand.jain@oracle.com>
 <1400567808-9494-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1400567808-9494-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 20, 2014 at 02:36:48PM +0800, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> generally if you use
>   echo "test" > /sys/fs/btrfs/<fsid>/label
> it would introduce return char at the end and it can not
> be part of the label. The correct command is
>   echo -n "test" > /sys/fs/btrfs/<fsid>/label
> 
> This patch will check for this user error
> 
> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
> ---
>  v2: accepts review comments. Thanks Eric and Roman
> 
>  fs/btrfs/sysfs.c |   20 +++++++++++++++++---
>  1 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index c5eb214..ca63fcd 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -373,22 +373,36 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
>  	struct btrfs_trans_handle *trans;
>  	struct btrfs_root *root = fs_info->fs_root;
>  	int ret;
> +	char *label;
> +	char *pos;
>  
> -	if (len >= BTRFS_LABEL_SIZE) {
> +	label = kzalloc(len, GFP_NOFS);

You can avoid allocating the buffer entirely:

- search for '\n', if found, use only that amount of bytes
- check for maximum size, copy to label if ok
