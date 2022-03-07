Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0582AC433EF
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Mar 2022 12:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239730AbiCGMc7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Mar 2022 07:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242320AbiCGMcx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Mar 2022 07:32:53 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B3085BF5
        for <linux-btrfs@vger.kernel.org>; Mon,  7 Mar 2022 04:31:59 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D42C3210E4;
        Mon,  7 Mar 2022 12:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1646656317;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MZX02P5TdjEHkzXbxOlabgNsphfNsaSS0ZY6UxPtYyE=;
        b=2mgjgiWP/3pHd+L0Yv40ZSKshW40qLZo+JnivB4S1666hLRBySRu98Hy8OJE7cm2XdqNdy
        d2wv9fT4wIEGuuPLLplp8NzPym7WXBKnw9k/FLVJVXc2klFxO8ax1Urm9fXs0gWUoX3b2E
        zLRabVcBvPSk/I0/TsiOcGwwyNWb764=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1646656317;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MZX02P5TdjEHkzXbxOlabgNsphfNsaSS0ZY6UxPtYyE=;
        b=g09xR7chyxQo14NthGiLnLdyjB25qkqTTYMxXlbc7NNVthGfwlOgkYirK6Qacy54qK+HV8
        mui26zDPanJq+MBg==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id C9822A3B85;
        Mon,  7 Mar 2022 12:31:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5D728DA7F7; Mon,  7 Mar 2022 13:28:03 +0100 (CET)
Date:   Mon, 7 Mar 2022 13:28:03 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 12/12] btrfs: rework inode creation to fix several issues
Message-ID: <20220307122803.GC12643@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1646348486.git.osandov@fb.com>
 <c7edee49c1935f66c07c5c2c1aa98a599e4a11ad.1646348486.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7edee49c1935f66c07c5c2c1aa98a599e4a11ad.1646348486.git.osandov@fb.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 03, 2022 at 03:19:02PM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>

>  fs/btrfs/acl.c   |  36 +--
>  fs/btrfs/ctree.h |  39 ++-
>  fs/btrfs/inode.c | 801 +++++++++++++++++++++++------------------------
>  fs/btrfs/ioctl.c | 174 +++++-----
>  fs/btrfs/props.c |  40 +--
>  fs/btrfs/props.h |   4 -
>  6 files changed, 508 insertions(+), 586 deletions(-)

Can this be split into more patches? All fine from 1 to 11 and now this,
it's just too much code change and I don't want to take risk by yet
another rewrite.
