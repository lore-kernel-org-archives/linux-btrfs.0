Return-Path: <SRS0=LIGD=RL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD7EC43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 14:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 719D72087C
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 14:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfCHOvK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Mar 2019 09:51:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:49312 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726294AbfCHOvJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Mar 2019 09:51:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BE2C5AFBB;
        Fri,  8 Mar 2019 14:51:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2FD0FDA93A; Fri,  8 Mar 2019 15:52:26 +0100 (CET)
Date:   Fri, 8 Mar 2019 15:52:25 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 6/9] btrfs: start transaction in btrfs_set_acl
Message-ID: <20190308145225.GR31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1551414895-22925-1-git-send-email-anand.jain@oracle.com>
 <1551414895-22925-7-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551414895-22925-7-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 01, 2019 at 12:34:52PM +0800, Anand Jain wrote:
> The main motivation is to avoid NULL for the trans argument reaching
> btrfs_set_xattr(). This patch does the following in btrfs_set_acl().
>   Create transaction and handle the inode changes update, (copies code
>     from btrfs_setxattr() as in the original, which needs a fix).
>   Rename __btrfs_set_acl to do_set_acl as this is a helper function.

>   Fix a c-code style, expand function declaration to max length 80 char.

You don't need to mention fixing the coding style unless it's the sole
purpose of the patch.

> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v5: change log update. Use BUG_ON instead of ASSERT.
> v4: born
>  fs/btrfs/acl.c | 36 ++++++++++++++++++++++++++----------
>  1 file changed, 26 insertions(+), 10 deletions(-)
> 
> -int btrfs_init_acl(struct btrfs_trans_handle *trans,
> -		   struct inode *inode, struct inode *dir)
> +int btrfs_init_acl(struct btrfs_trans_handle *trans, struct inode *inode,
> +		   struct inode *dir)

Please don't do such drive-by changes, there's no difference but one has
still make sure there is none and that it's not an accidental edit.
It's ok if you rename or move a function to fix the indentation but
otherwise I have to review it and then undo it.
