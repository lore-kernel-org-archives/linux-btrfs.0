Return-Path: <SRS0=LIGD=RL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C93ECC43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 14:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 998DB2087C
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 14:47:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfCHOr6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Mar 2019 09:47:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:48646 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726528AbfCHOr6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Mar 2019 09:47:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F2FFFAEE8;
        Fri,  8 Mar 2019 14:47:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 493F8DA93A; Fri,  8 Mar 2019 15:49:14 +0100 (CET)
Date:   Fri, 8 Mar 2019 15:49:14 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 4/9] btrfs: refactor btrfs_set_prop add
 btrfs_set_prop_trans
Message-ID: <20190308144913.GQ31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1551414895-22925-1-git-send-email-anand.jain@oracle.com>
 <1551414895-22925-5-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551414895-22925-5-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 01, 2019 at 12:34:50PM +0800, Anand Jain wrote:
> btrfs_set_prop() accepts transaction pointer as the first argument,
> however in ioctl.c for the purpose of setting the compression property,
> we call btrfs_set_prop() with NULL transaction pointer. Down in
> the call chain  btrfs_setxattr() starts transaction to update the
> attribute and also to update the inode. So for better clarity, create
> btrfs_set_prop_trans() with no transaction pointer as argument, in
> preparation to start transaction here instead of doing it down the
> call chain at btrfs_setxattr().
> 
> Also now the btrfs_set_prop() is a static function.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v5: change log updated, fix c-style.
> v4: born
> 
> Its named btrfs_set_prop_trans() instead of btrfs_set_prop_notrans()
> because in the next patch I am starting the transaction in
> btrfs_set_prop_trans().

That's right, it should be _trans.

> I am ok if this and the next patch are squashed
> during integration, as it is separated only for the purpose of easy review.

No, the patch separation does make it easier to review.
