Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C853C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 14:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03E0220657
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 14:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfANOIT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 09:08:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:53208 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726470AbfANOIS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 09:08:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CB36FAD25;
        Mon, 14 Jan 2019 14:08:17 +0000 (UTC)
Date:   Mon, 14 Jan 2019 15:08:17 +0100
From:   David Disseldorp <ddiss@suse.de>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 3/3] Btrfs-progs: add test for receive
Message-ID: <20190114150817.394e4f7d@suse.de>
In-Reply-To: <20190114133146.18424-1-fdmanana@kernel.org>
References: <20190114133146.18424-1-fdmanana@kernel.org>
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.31; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, 14 Jan 2019 13:31:46 +0000, fdmanana@kernel.org wrote:

> From: Filipe Manana <fdmanana@suse.com>
> 
> Add a test for a scenario that used to fail due to find_mount_root()
> incorrectly determining the mount point for the receive path due to the
> fact that a different mount point with a path that is a prefix of the
> receive path exists.
> 
> This is fixed by a recent patch titled:
> 
>   "Btrfs-progs: fix mount point detection due to partial prefix match"
> 
> Reported-by: David Disseldorp <ddis@suse.com>

My address has an extra 's' (ddiss). This also applies to PATCH 1/3.

> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  .../034-receive-common-mount-point-prefix/test.sh  | 47 ++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
>  create mode 100755 tests/misc-tests/034-receive-common-mount-point-prefix/test.sh

Looks good.
Reviewed-by: David Disseldorp <ddiss@suse.de>
