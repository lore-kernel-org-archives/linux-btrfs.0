Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB477C433F5
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Mar 2022 21:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344864AbiCWVUB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 17:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240180AbiCWVUA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Mar 2022 17:20:00 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCEF5FDD
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Mar 2022 14:18:30 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id EE9761F387;
        Wed, 23 Mar 2022 21:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648070308;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WR5sFyXKtnpRVkMmUa1D3Y0gTCGPQQrtgYZJTMshC8Y=;
        b=D8aIQlaRZVtLsCWh7KrJm62Jw66H72VvAdbWCODfERF5OJ2s8ykT88/MgQoMdNVDOmevmx
        Ra8QpDq3AjDdl6oKa4T4vguXHFLUt9AtJVqczN2NAOex038XjomJN+e5xL4EGl1G7qLcI8
        oTcLNMGBOn3b3lHx9PE2JBp+d7SCTA4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648070308;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WR5sFyXKtnpRVkMmUa1D3Y0gTCGPQQrtgYZJTMshC8Y=;
        b=VjP93876BOZu88kPB5j5iiMv9BE9fYPWUO3LlmEWEWQrna9rrNeMzHr1aQIetvZ5KPy72k
        IKlzKq1mqIoTI7DA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id E39D4A3B83;
        Wed, 23 Mar 2022 21:18:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 79B20DA7DA; Wed, 23 Mar 2022 22:14:34 +0100 (CET)
Date:   Wed, 23 Mar 2022 22:14:34 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     boris@bur.io, linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs-progs: add print support for verity items.
Message-ID: <20220323211434.GD2237@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>, boris@bur.io,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20220323194504.1777182-1-sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323194504.1777182-1-sweettea-kernel@dorminy.me>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 23, 2022 at 03:45:05PM -0400, Sweet Tea Dorminy wrote:
> 'btrfs inspect-internals dump-tree' doesn't currently know about the two
> types of verity items and prints them as 'UNKNOWN.36' or 'UNKNOWN.37'.
> So add them to the known item types.
> 
> Suggested-by: Boris Burkov <boris@bur.io>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

Added to devel, thanks.
