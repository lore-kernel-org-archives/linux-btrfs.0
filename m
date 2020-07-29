Return-Path: <SRS0=lAVn=BI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB4DC433DF
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Jul 2020 18:50:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 683B32075D
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Jul 2020 18:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgG2SuV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 29 Jul 2020 14:50:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:53734 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbgG2SuV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Jul 2020 14:50:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 940EDAAC7;
        Wed, 29 Jul 2020 18:50:31 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0B4B2DA882; Wed, 29 Jul 2020 20:49:49 +0200 (CEST)
Date:   Wed, 29 Jul 2020 20:49:48 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix memory leaks after failure to lookup
 checksums during inode logging
Message-ID: <20200729184948.GD3703@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20200729091750.2538306-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729091750.2538306-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jul 29, 2020 at 10:17:50AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> While logging an inode, at copy_items(), if we fail to lookup the checksums
> for an extent we release the destination path, free the ins_data array and
> then return immediately. However a previous iteration of the for loop may
> have added checksums to the ordered_sums list, in which case we leak the
> memory used by them.
> 
> So fix this by making sure we iterate the ordered_sums list and free all
> its checksums before returning.
> 
> Fixes: 3650860b90cc2a ("Btrfs: remove almost all of the BUG()'s from tree-log.c")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
