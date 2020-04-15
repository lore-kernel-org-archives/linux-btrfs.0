Return-Path: <SRS0=FXaq=57=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CB9CC2BA19
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Apr 2020 15:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DD2C2078B
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Apr 2020 15:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1414707AbgDOP1T (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 11:27:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:45904 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbgDOP1R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Apr 2020 11:27:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C7838ABCF;
        Wed, 15 Apr 2020 15:27:14 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 903C3DA727; Wed, 15 Apr 2020 17:26:35 +0200 (CEST)
Date:   Wed, 15 Apr 2020 17:26:35 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Make btrfs_read_disk_super return struct
 btrfs_disk_super
Message-ID: <20200415152635.GE5920@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200415125346.468-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415125346.468-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 15, 2020 at 03:53:46PM +0300, Nikolay Borisov wrote:
> @@ -1337,7 +1336,8 @@ struct btrfs_device *btrfs_scan_one_device(const char *path, fmode_t flags,
>  	if (IS_ERR(bdev))
>  		return ERR_CAST(bdev);
>  
> -	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super)) {
> +	disk_super = btrfs_read_disk_super(bdev, bytenr);
> +	if (IS_ERR(disk_super)) {
>  		device = ERR_PTR(-EINVAL);

This should forward the error value from btrfs_read_disk_super, like

		device = disk_super;
