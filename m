Return-Path: <SRS0=BNt3=S4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F4E7C43219
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 14:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C13720656
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 14:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfDZOMk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Apr 2019 10:12:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:53000 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726120AbfDZOMj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Apr 2019 10:12:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 25916AFFB;
        Fri, 26 Apr 2019 14:12:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 32B31DA847; Fri, 26 Apr 2019 16:13:39 +0200 (CEST)
Date:   Fri, 26 Apr 2019 16:13:38 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johnny Chang <johnnyc@synology.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Check the compression level before getting a
 workspace
Message-ID: <20190426141337.GS20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johnny Chang <johnnyc@synology.com>,
        linux-btrfs@vger.kernel.org
References: <1556247665-22859-1-git-send-email-johnnyc@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556247665-22859-1-git-send-email-johnnyc@synology.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 26, 2019 at 11:01:05AM +0800, Johnny Chang wrote:
> When a file's compression property is set as zlib or zstd but leave
> the compression mount option not be set, that means btrfs will try
> to compress the file with default compression level. But in
> btrfs_compress_pages(), it calls get_workspace() with level = 0.
> This will return a workspace with a wrong compression level.
> For zlib, the compression level in the workspace will be 0
> (that means "store only"). And for zstd, the compression in the
> workspace will be 1, not the default level 3.
> 
> How to reproduce:
> mkfs -t btrfs /dev/sdb
> mount /dev/sdb /mnt/
> mkdir /mnt/zlib
> btrfs property set /mnt/zlib/ compression zlib
> dd if=/dev/zero of=/mnt/zlib/compression-friendly-file-10M bs=1M count=10
> sync
> btrfs-debugfs -f /mnt/zlib/compression-friendly-file-10M
> 
> btrfs-debugfs output:
> * before:
> ...
> (258 9961472): ram 524288 disk 1106247680 disk_size 524288
> file: ... extents 20 disk size 10485760 logical size 10485760 ratio 1.00
> 
> * after:
> ...
> (258 10354688): ram 131072 disk 14217216 disk_size 4096
> file: ... extents 80 disk size 327680 logical size 10485760 ratio 32.00
> 
> The steps for zstd are similar, but need to put a degging message to
> show the level of the return workspace in zstd_get_workspace().
> 
> This commit adds a check of the compression level before getting a
> workspace by set_level().

Good catch. I think it's safest set the level at btrfs_compress_pages
though it means one extra call, compared to setting it when the property
is set. This will change once the properties store the level too as it
has to be combined with fs_info::compress_level.

Reviewed-by: David Sterba <dsterba@suse.com>
