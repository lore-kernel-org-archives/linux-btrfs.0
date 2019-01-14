Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9CDFC43444
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 13:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A527920873
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 13:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfANN7q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 08:59:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:51186 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726515AbfANN7q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 08:59:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7EBD7AC95;
        Mon, 14 Jan 2019 13:59:44 +0000 (UTC)
Date:   Mon, 14 Jan 2019 14:59:44 +0100
From:   David Disseldorp <ddiss@suse.de>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 1/3] Btrfs-progs: fix mount point detection due to
 partial prefix match
Message-ID: <20190114145944.609d56b6@suse.de>
In-Reply-To: <20190114133024.18320-1-fdmanana@kernel.org>
References: <20190114133024.18320-1-fdmanana@kernel.org>
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.31; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, 14 Jan 2019 13:30:24 +0000, fdmanana@kernel.org wrote:

> From: Filipe Manana <fdmanana@suse.com>
> 
> When attempting to find the mount point of a path we can end up returning
> an incorrect mount point. This happens because we consider a mount point
> valid for the given path even if it matches only partially the patch.

s/patch/path/? "...even if it only partially matches" might be a bit
clearer.

> diff --git a/utils.c b/utils.c
> index 3a4bc92a..6616630b 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -2064,7 +2064,8 @@ int find_mount_root(const char *path, char **mount_root)
>  
>  	while ((ent = getmntent(mnttab))) {
>  		len = strlen(ent->mnt_dir);
> -		if (strncmp(ent->mnt_dir, path, len) == 0) {
> +		if (strncmp(ent->mnt_dir, path, len) == 0 &&
> +		    (path[len] == '/' || path[len] == '\0')) {

Looks good and works for me.
Reviewed-by: David Disseldorp <ddiss@suse.de>
