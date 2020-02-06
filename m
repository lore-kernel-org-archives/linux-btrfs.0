Return-Path: <SRS0=9o53=32=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F745C33CAC
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Feb 2020 16:26:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C96E214AF
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Feb 2020 16:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbgBFQ0f (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 11:26:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:58398 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727574AbgBFQ0f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Feb 2020 11:26:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2DFFEAEE2;
        Thu,  6 Feb 2020 16:26:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BAE59DA952; Thu,  6 Feb 2020 17:26:19 +0100 (CET)
Date:   Thu, 6 Feb 2020 17:26:19 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 27/44] btrfs: hold a ref on the root in
 btrfs_recover_relocation
Message-ID: <20200206162619.GZ2654@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
References: <20200124143301.2186319-1-josef@toxicpanda.com>
 <20200124143301.2186319-28-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124143301.2186319-28-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 24, 2020 at 09:32:44AM -0500, Josef Bacik wrote:
> @@ -4593,6 +4593,10 @@ int btrfs_recover_relocation(struct btrfs_root *root)
>  		if (btrfs_root_refs(&reloc_root->root_item) > 0) {
>  			fs_root = read_fs_root(fs_info,
>  					       reloc_root->root_key.offset);
> +			if (!btrfs_grab_fs_root(fs_root)) {
> +				err = -ENOENT;
> +				goto out;
> +			}
>  			if (IS_ERR(fs_root)) {
>  				ret = PTR_ERR(fs_root);
>  				if (ret != -ENOENT) {
> @@ -4604,6 +4608,8 @@ int btrfs_recover_relocation(struct btrfs_root *root)
>  					err = ret;
>  					goto out;
>  				}
> +			} else {
> +				btrfs_put_fs_root(fs_root);
>  			}
>  		}

The order of IS_ERR and btrfs_grab_fs_root is reversed but then it looks
strange:

  4637                         fs_root = read_fs_root(fs_info,
_ 4638                                                reloc_root->root_key.offset);
  4639                         if (IS_ERR(fs_root)) {
  4640                                 ret = PTR_ERR(fs_root);
  4641                                 if (ret != -ENOENT) {
  4642                                         err = ret;
  4643                                         goto out;
  4644                                 }
  4645                                 ret = mark_garbage_root(reloc_root);
  4646                                 if (ret < 0) {
  4647                                         err = ret;
  4648                                         goto out;
  4649                                 }
  4650                         } else {
+ 4651                                 if (!btrfs_grab_fs_root(fs_root)) {
+ 4652                                         err = -ENOENT;
+ 4653                                         goto out;
+ 4654                                 }
  4655                                 btrfs_put_fs_root(fs_root);
  4656                         }
  4657                 }

Seems that the refcounting is not necessary here at all, it just tries
to read the fs root and handle errors if it does not exist, no operation
that would want to keep the fs_root.
