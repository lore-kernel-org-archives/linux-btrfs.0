Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF38CC433FE
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Mar 2022 15:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235844AbiCAPkA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 10:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235855AbiCAPj6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2022 10:39:58 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CD8AA2D0
        for <linux-btrfs@vger.kernel.org>; Tue,  1 Mar 2022 07:39:16 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D0405218D9;
        Tue,  1 Mar 2022 15:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1646149154;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L1DDsqF94b2sYY0QW5l//1eSrFOPNj1pnGCYDOANX6E=;
        b=tAfaxToIaXsoeqcRAFJS0V/wW9cs2tDSoSCGIHtfjmVyEzEVowmuktABAZGlfOmR+NWWYO
        oeBINyoqIVBqCpoWiuU1KA8zkT1LSVIUDWiAijtpSgaDU3jUVw9wIGFTdN+Rv9z39pCDcq
        pP3pvlBwebS5fyf/liPb49YyFWqgooA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1646149154;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L1DDsqF94b2sYY0QW5l//1eSrFOPNj1pnGCYDOANX6E=;
        b=38StR+8Onj3uE1GT5WtPuezrXOwsNueTuRs/N8IKXrD5fbAu9NCv39jCtsQ/wbKYnZq/Lx
        ZhbnUke9wxASmBAA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id CAA00A3B8C;
        Tue,  1 Mar 2022 15:39:14 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 69E4FDA80E; Tue,  1 Mar 2022 16:35:23 +0100 (CET)
Date:   Tue, 1 Mar 2022 16:35:23 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs: fix missing delayed items run after unlink
 during log replay
Message-ID: <20220301153523.GO12643@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <cover.1646064823.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1646064823.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 28, 2022 at 04:29:27PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> This fixes a couple places that miss running delayed items after doing an
> unlink during log replay. The first patch is the actual fix, while the
> second one is just a small refactoring to avoid duplication.
> 
> Filipe Manana (2):
>   btrfs: add missing run of delayed items after unlink during log replay
>   btrfs: add and use helper for unlinking inode during log replay

Added to misc-next, thanks.
