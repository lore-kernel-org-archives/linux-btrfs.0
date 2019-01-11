Return-Path: <SRS0=hHgh=PT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC1AC43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 14:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67CCA206B6
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 14:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388128AbfAKO4M (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Jan 2019 09:56:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:53386 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731882AbfAKO4L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Jan 2019 09:56:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9C1E7AE3F;
        Fri, 11 Jan 2019 14:56:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C46A9DA780; Fri, 11 Jan 2019 15:55:35 +0100 (CET)
Date:   Fri, 11 Jan 2019 15:55:34 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] Btrfs: move duplicated nodatasum check into common
 reflink/dedupe helper
Message-ID: <20190111145534.GG27146@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181212180559.15249-1-fdmanana@kernel.org>
 <20181212180559.15249-2-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181212180559.15249-2-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 12, 2018 at 06:05:56PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Move the check that verifies if both inodes have checksums disabled or
> both have them enabled, from the clone and deduplication functions into
> the new common helper btrfs_remap_file_range_prep().
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Added to misc-next, thanks.
