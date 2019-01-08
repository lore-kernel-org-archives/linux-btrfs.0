Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 131BAC43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 15:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF62220663
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 15:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbfAHP6N (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 10:58:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:39046 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728041AbfAHP6N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 10:58:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B8730AF1A;
        Tue,  8 Jan 2019 15:58:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0B49DDA7E8; Tue,  8 Jan 2019 16:57:41 +0100 (CET)
Date:   Tue, 8 Jan 2019 16:57:41 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: do not overwrite error return value in the
 device replace ioctl
Message-ID: <20190108155741.GI23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181214194532.21841-1-fdmanana@kernel.org>
 <20190108114209.2137-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190108114209.2137-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 08, 2019 at 11:42:09AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If the call to btrfs_dev_replace_by_ioctl() failed we would overwrite the
> error returned to user space with -EFAULT if the call to copy_to_user()
> failed as well. Fix that by calling copy_to_user() only if no error
> happened before or a device replace operation was canceled.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
