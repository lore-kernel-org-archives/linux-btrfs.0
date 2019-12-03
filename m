Return-Path: <SRS0=ifAh=ZZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDDAC432C0
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Dec 2019 19:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB5FC20674
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Dec 2019 19:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbfLCTLx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 14:11:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:33082 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726932AbfLCTLw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Dec 2019 14:11:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 55DFAB2AF6;
        Tue,  3 Dec 2019 19:11:51 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8B053DA7D9; Tue,  3 Dec 2019 20:11:46 +0100 (CET)
Date:   Tue, 3 Dec 2019 20:11:46 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] Btrfs: make tree checker detect checksum items
 with overlapping ranges
Message-ID: <20191203191146.GX2734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20191129151410.32219-1-fdmanana@kernel.org>
 <20191202110103.20456-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202110103.20456-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 02, 2019 at 11:01:03AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Having checksum items, either on the checksums tree or in a log tree, that
> represent ranges that overlap each other is a sign of a corruption. Such
> case confuses the checksum lookup code and can result in not being able to
> find checksums or find stale checksums.
> 
> So add a check for such case.
> 
> This is motivated by a recent fix for a case where a log tree had checksum
> items covering ranges that overlap each other due to extent cloning, and
> resulted in missing checksums after replaying the log tree. It also helps
> detect past issues such as stale and outdated checksums due to overlapping,
> commit 27b9a8122ff71a ("Btrfs: fix csum tree corruption, duplicate and
> outdated checksums").
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
