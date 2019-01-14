Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6579FC43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 14:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4073E20657
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 14:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbfANODB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 09:03:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:52068 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726470AbfANODB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 09:03:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 212B4AD25;
        Mon, 14 Jan 2019 14:03:00 +0000 (UTC)
Date:   Mon, 14 Jan 2019 15:02:59 +0100
From:   David Disseldorp <ddiss@suse.de>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 2/3] Btrfs-progs: add missing error handling in
 find_mount_root()
Message-ID: <20190114150259.26190266@suse.de>
In-Reply-To: <20190114133134.18374-1-fdmanana@kernel.org>
References: <20190114133134.18374-1-fdmanana@kernel.org>
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.31; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, 14 Jan 2019 13:31:34 +0000, fdmanana@kernel.org wrote:

> From: Filipe Manana <fdmanana@suse.com>
> 
> The strdup() function can fail, in which case it returns NULL and sets
> errno [1]. Therefore add the missing error check after calling strdup()
> at find_mount_root().
> 
> [1] - http://man7.org/linux/man-pages/man3/strdup.3p.html
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  utils.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

Looks good:
Reviewed-by: David Disseldorp <ddiss@suse.de>
