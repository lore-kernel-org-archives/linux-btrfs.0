Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEBE3C4338F
	for <linux-btrfs@archiver.kernel.org>; Thu, 12 Aug 2021 16:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D70846103E
	for <linux-btrfs@archiver.kernel.org>; Thu, 12 Aug 2021 16:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhHLQCv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 12:02:51 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:50986 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhHLQCs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Aug 2021 12:02:48 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 697461FF5F;
        Thu, 12 Aug 2021 16:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1628784142;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X2alePlHBv22eBlBVPmhnI7tl+frZ2QZKsXKRrOVB94=;
        b=1jjnvXYeeaKwRQQEwepDaeyI1ytPEm/W3Gqc/sgMLD3Kfs0/B/mn6dsXmn3ynd/8pvPxc4
        jJhQqLwkzNAmUNeQduZbh+A1zmaD96XBoAAUmkBwMpWpsLrgI1CZ2EC6gpQ9orZ2atBHv4
        Z5MuIQvQ6O/ewZmg7M5BxrvJMdg4B8E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1628784142;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X2alePlHBv22eBlBVPmhnI7tl+frZ2QZKsXKRrOVB94=;
        b=MDkKJgjcSJc6eCZqUj8CfYGzoq+jWZbydUH1CEmV4MLgYr43hIYnU2u7fT1ukEMrC+vPsw
        Qprf3cGOEnxkffDA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 624A8A3F6F;
        Thu, 12 Aug 2021 16:02:22 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4B513DA733; Thu, 12 Aug 2021 17:59:28 +0200 (CEST)
Date:   Thu, 12 Aug 2021 17:59:27 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] btrfs: sysfs: bytes_zone_unusable is not under
 CONFIG_BTRFS_DEBUG
Message-ID: <20210812155927.GM5047@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <8585061cc6672a4f3b985b7c387c7a8040af2a73.1628125287.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8585061cc6672a4f3b985b7c387c7a8040af2a73.1628125287.git.anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Aug 05, 2021 at 09:07:00AM +0800, Anand Jain wrote:
> Sysfs zoned file is under CONFIG_BTRFS_DEBUG (now there is a patch to
> bring it under CONFIG_BLK_DEV_ZONED). But sysfs file bytes_zone_unusable
> has escaped the CONFIG_BTRFS_DEBUG config. There is no problem with this
> as bytes_zone_unusable with no zoned configured shall display 0, so it is
> just a matter of fixing the consistency.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> RFC because in my understanding, there is no way to fix this
> inconsistency without failing the ABI compliance test, so it is just
> better to leave it as it is.

Good find but I think we can keep it there unconditionally, that's the
long term plan. Hiding zoned mode behind debug option was meant only for
the beginning until the worst bugs are ironed out.
