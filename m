Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbaETQcu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 12:32:50 -0400
Message-ID: <537B83AD.5010901@redhat.com>
Date: Tue, 20 May 2014 11:32:45 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
CC: rm@romanrm.net
Subject: Re: [PATCH 1/2 v2] btrfs: label should not contain return char
References: <1400519071-5580-1-git-send-email-anand.jain@oracle.com> <1400567808-9494-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1400567808-9494-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/20/14, 1:36 AM, Anand Jain wrote:
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
> +	if (!label)
> +		return -ENOMEM;
> +
> +	memcpy(label, buf, len);

  +     strlcpy(label, buf, len);

would ensure that the resulting string is null-terminated... I don't know
if "buf" comes in 0-terminated or not, or if len includes \0.  *shrug*
these are strings after all...

> +	if ((pos = strchr(label, '\n')))
> +		*pos = '\0';

label = strstrip(label); might be simpler/better?

(this would strip all leading & trailing whitespace, I presume that'd
be desirable, but then maybe someone really does want " mylabel \t " ?)

> +
> +	if (strlen(label) >= BTRFS_LABEL_SIZE) {

hm, strlen doesn't include the \0 right?  so if we had 256 chars + \0, this
would pass, and the subsequent strcpy will copy 257 bytes into a 256-byte
buffer, right?

(I'm terrible at string handling in C, so I might be wrong... you all
can point and laugh if I am)

>  		pr_err("BTRFS: unable to set label with more than %d bytes\n",
>  		       BTRFS_LABEL_SIZE - 1);
> +		kfree(label);
>  		return -EINVAL;
>  	}
>  
>  	trans = btrfs_start_transaction(root, 0);
> -	if (IS_ERR(trans))
> +	if (IS_ERR(trans)) {
> +		kfree(label);
>  		return PTR_ERR(trans);
> +	}
>  
>  	spin_lock(&root->fs_info->super_lock);
> -	strcpy(fs_info->super_copy->label, buf);
> +	strcpy(fs_info->super_copy->label, label);
>  	spin_unlock(&root->fs_info->super_lock);
>  	ret = btrfs_commit_transaction(trans, root);
>  
> +	kfree(label);

after the 3rd kfree() maybe an

out:

target would be better....

(Random aside: why does btrfs support online fs relabeling, anyway?)

-Eric

>  	if (!ret)
>  		return len;
>  
> 

