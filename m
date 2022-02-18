Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C9DC433F5
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Feb 2022 14:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235983AbiBROVH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Feb 2022 09:21:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbiBROVG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Feb 2022 09:21:06 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BF5D1D6A
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Feb 2022 06:20:49 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 03EEE219A8;
        Fri, 18 Feb 2022 14:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1645194048;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S5UXMYM+qW3iOnvMHCpI93j4VqBsvURVbux0JHKZUz0=;
        b=hq8b51zSANOCi3RQmBwWB/7uEioKthMWTtPTghay9csqSrLbhmrJuUOVbYR/Qiuh6+X0Un
        Eqsb6PELxihNHfmwzo6iAVEIXGXsYEdcmMC1x7U1qWDUWZK5ulTNJ4vZ4QOTOibjLfhzXd
        HtYjD4+Ny++cnY+LJ3YWm6VTmZNZXOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1645194048;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S5UXMYM+qW3iOnvMHCpI93j4VqBsvURVbux0JHKZUz0=;
        b=FZHytzWXP4L7R17qT88UkO6pVLrGQIAFQJ5TfGhjbEU6K+HJBuQf5+bIebXqd7jGquLWyX
        K/m+lsddpcZ+3NDg==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id F23ECA3B8F;
        Fri, 18 Feb 2022 14:20:47 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5F4E6DA829; Fri, 18 Feb 2022 15:17:02 +0100 (CET)
Date:   Fri, 18 Feb 2022 15:17:02 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: add zoned_profile_supported function stub
Message-ID: <20220218141702.GU12643@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anthony Iliopoulos <ailiop@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20220215171213.5173-1-ailiop@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215171213.5173-1-ailiop@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 15, 2022 at 06:12:12PM +0100, Anthony Iliopoulos wrote:
> The zoned_profile_supported function is only defined if BTRFS_ZONED is
> defined, and thus compilation breaks when progs are configured without
> zoned block device support. Add the stub function so that progs can be
> compiled without zoned support.
> 
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>

Thanks, this has been fixed in 5.16.2.
