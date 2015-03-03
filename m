Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35143 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756958AbbCCPgE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Mar 2015 10:36:04 -0500
Date: Tue, 3 Mar 2015 10:35:53 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs:__add_inode_ref: out of bounds memory read when
 looking for extended ref.
To: Quentin Casasnovas <quentin.casasnovas@oracle.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mark Fasheh <mfasheh@suse.de>, David Sterba <dsterba@suse.cz>
Message-ID: <1425396953.29552.3@mail.thefacebook.com>
In-Reply-To: <1425396698-31009-1-git-send-email-quentin.casasnovas@oracle.com>
References: <1425396236.29552.2@mail.thefacebook.com>
	<1425396698-31009-1-git-send-email-quentin.casasnovas@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Tue, Mar 3, 2015 at 10:31 AM, Quentin Casasnovas 
<quentin.casasnovas@oracle.com> wrote:
> Improper arithmetics when calculting the address of the extended ref 
> could
> lead to an out of bounds memory read and kernel panic.
> 
> Signed-off-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
> ---
>  fs/btrfs/tree-log.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git fs/btrfs/tree-log.c fs/btrfs/tree-log.c
> index 9a37f8b..c5b8ba3 100644
> --- fs/btrfs/tree-log.c
> +++ fs/btrfs/tree-log.c
> @@ -1012,7 +1012,7 @@ again:
>  		base = btrfs_item_ptr_offset(leaf, path->slots[0]);
> 
>  		while (cur_offset < item_size) {
> -			extref = (struct btrfs_inode_extref *)base + cur_offset;
> +			extref = (struct btrfs_inode_extref *)(base + cur_offset);
> 
>  			victim_name_len = btrfs_inode_extref_name_len(leaf, extref);
> 

Thanks, this goes back to 3.7+ (Mark's original extref code).  I'll tag 
for stable and add Dave's reviewed by:

Reviewed-by: David Sterba <dsterba@suse.cz>

-chris



