Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03AF3C5ACCC
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 16:46:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF5E12145D
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 16:46:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF5E12145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbeJSAsp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 20:48:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:38352 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727294AbeJSAsp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 20:48:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A6367AF3E;
        Thu, 18 Oct 2018 16:46:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 04451DAE03; Thu, 18 Oct 2018 18:46:49 +0200 (CEST)
Date:   Thu, 18 Oct 2018 18:46:49 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com, fdmanana@suse.com
Subject: Re: [PATCH 18/42] btrfs: move the dio_sem higher up the callchain
Message-ID: <20181018164649.GK29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com, fdmanana@suse.com
References: <20181012193256.13735-1-josef@toxicpanda.com>
 <20181012193256.13735-19-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181012193256.13735-19-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 12, 2018 at 03:32:32PM -0400, Josef Bacik wrote:
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -4374,7 +4374,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
>  
>  	INIT_LIST_HEAD(&extents);
>  
> -	down_write(&inode->dio_sem);

I'll add lockdep_assert_held(&inode->dio_sem) so it's documented and
runtime checked.

>  	write_lock(&tree->lock);
>  	test_gen = root->fs_info->last_trans_committed;
>  	logged_start = start;
> @@ -4440,7 +4439,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
>  	}
>  	WARN_ON(!list_empty(&extents));
>  	write_unlock(&tree->lock);
> -	up_write(&inode->dio_sem);
>  
>  	btrfs_release_path(path);
>  	if (!ret)
> -- 
> 2.14.3
