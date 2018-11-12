Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12704C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 18:28:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB5212245E
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 18:28:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB5212245E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730297AbeKMEWr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Nov 2018 23:22:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:49414 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727712AbeKMEWr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Nov 2018 23:22:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BB367AFB5;
        Mon, 12 Nov 2018 18:28:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EB363DAFAE; Mon, 12 Nov 2018 19:28:05 +0100 (CET)
Date:   Mon, 12 Nov 2018 19:28:05 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove no longer used io_err from btrfs_log_ctx
Message-ID: <20181112182805.GL24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181112102430.16096-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181112102430.16096-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 12, 2018 at 10:24:30AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The io_err field of struct btrfs_log_ctx is no longer used after the
> recent simplification of the fast fsync path, where we now wait for
> ordered extents to complete before logging the inode. We did this in
> commit b5e6c3e170b7 ("btrfs: always wait on ordered extents at fsync
> time") and commit a2120a473a80 ("btrfs: clean up the left over
> logged_list usage") removed its last use.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
