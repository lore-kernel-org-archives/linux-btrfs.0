Return-Path: <SRS0=9Op2=AZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67BDDC433E0
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 Jul 2020 14:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 519F42242E
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 Jul 2020 14:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgGNOPx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 10:15:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:34238 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725803AbgGNOPw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Jul 2020 10:15:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9D050AC85;
        Tue, 14 Jul 2020 14:15:53 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 197FEDA790; Tue, 14 Jul 2020 16:15:29 +0200 (CEST)
Date:   Tue, 14 Jul 2020 16:15:28 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix double free on ulist after backref resolution
 failure
Message-ID: <20200714141528.GR3703@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20200713141156.1772789-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713141156.1772789-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jul 13, 2020 at 03:11:56PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
[...]
> Fixes: 8da6d5815c592b ("Btrfs: added btrfs_find_all_roots()")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
