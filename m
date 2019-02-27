Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 533ABC4360F
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 16:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2254220C01
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 16:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729893AbfB0QPD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 11:15:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:53472 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727400AbfB0QO5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 11:14:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 936CCAD47;
        Wed, 27 Feb 2019 16:14:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 43F48DA83C; Wed, 27 Feb 2019 17:16:17 +0100 (CET)
Date:   Wed, 27 Feb 2019 17:16:17 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 09/10] btrfs: btrfs_setxattr argument trans is never
 NULL
Message-ID: <20190227161617.GV24609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
 <1550857192-10513-10-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1550857192-10513-10-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Feb 23, 2019 at 01:39:51AM +0800, Anand Jain wrote:
> The following patches
>    btrfs: cleanup btrfs_set_acl
>    btrfs: start transaction in btrfs_xattr_handler_set
>    btrfs: create transaction in btrfs_set_prop_notrans
> 
> made the btrfs_setxattr() argument trans to be never NULL, so delete the
> code when trans is NULL in btrfs_setxattr(). Also fix the c-code style.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v4: born
>  fs/btrfs/xattr.c | 28 +++++-----------------------
>  1 file changed, 5 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
> index 8e301a1ae304..b3281d4d95b9 100644
> --- a/fs/btrfs/xattr.c
> +++ b/fs/btrfs/xattr.c
> @@ -220,35 +220,17 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
>  /*
>   * @value: "" makes the attribute to empty, NULL removes it
>   */
> -int btrfs_setxattr(struct btrfs_trans_handle *trans,
> -		     struct inode *inode, const char *name,
> -		     const void *value, size_t size, int flags)
> +int btrfs_setxattr(struct btrfs_trans_handle *trans, struct inode *inode,
> +		   const char *name, const void *value, size_t size, int flags)
>  {
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
> -	int ret;
> +
> +	ASSERT(!trans);

Isn't this reversed?

	ASSERT(trans == 0) is not what we want
