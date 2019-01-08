Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F08C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 16:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F227206BB
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 16:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbfAHQDG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 11:03:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:40336 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728211AbfAHQDG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 11:03:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2182DAFFC;
        Tue,  8 Jan 2019 16:03:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 590C5DA7E8; Tue,  8 Jan 2019 17:02:34 +0100 (CET)
Date:   Tue, 8 Jan 2019 17:02:34 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove redundant check for swapfiles when
 reflinking
Message-ID: <20190108160234.GK23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190108114318.3711-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190108114318.3711-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 08, 2019 at 11:43:18AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Checking if either of the inodes corresponds to a swapfile is already
> performed by generic_remap_file_range_prep(), so we do not need to do
> it in the btrfs clone and deduplication functions.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
