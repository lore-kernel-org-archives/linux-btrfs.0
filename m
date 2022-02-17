Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B52BBC433EF
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Feb 2022 04:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbiBQE7c (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Feb 2022 23:59:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiBQE7b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Feb 2022 23:59:31 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F0529B9C4;
        Wed, 16 Feb 2022 20:59:17 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 41EFC1F383;
        Thu, 17 Feb 2022 04:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1645073956; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NaB287qY6Sq9OrLedRTVWDC3xRuYw7cJ7bIzzw85xvM=;
        b=YaLC3Zbb+UZWyfamZpmrp8CUo0diFJFgnY5Deu338jK4X/8qYXSLSuSwYnwk5HetgL1vVJ
        DIRFi1UxVxgZOAodPECxw8Fr9YExBd7Zs4tA+uiAGU99pRQZJ/v7llINjHJB/xd4VBKZS1
        n3cpvzRwPnNGDwusCfTYTWjWLxiT4j0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1645073956;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NaB287qY6Sq9OrLedRTVWDC3xRuYw7cJ7bIzzw85xvM=;
        b=mkff9+yZr2N4RJwNZHkn+bvuiluYeR/gPxc+3eTZsqfhIa0pfVZHLMCy732WUl5eezSIQ2
        71HgyPRN9yivgAAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 697C61348D;
        Thu, 17 Feb 2022 04:59:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WkBXCiLWDWJ4SwAAMHmgww
        (envelope-from <neilb@suse.de>); Thu, 17 Feb 2022 04:59:14 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Wang Yugui" <wangyugui@e16-tech.com>
Cc:     "Josef Bacik" <josef@toxicpanda.com>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] fs: allow cross-vfsmount reflink/dedupe
In-reply-to: <20220217125253.0F07.409509F4@e16-tech.com>
References: =?utf-8?q?=3C67ae4c62a4749ae6870c452d1b458cc5f48b8263=2E16450428?=
 =?utf-8?q?35=2Egit=2Ejosef=40toxicpanda=2Ecom=3E=2C?=
 <20220217125253.0F07.409509F4@e16-tech.com>
Date:   Thu, 17 Feb 2022 15:59:11 +1100
Message-id: <164507395131.10228.17031212675231968127@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, 17 Feb 2022, Wang Yugui wrote:
> Hi,
> Cc: NeilBrown
> 
> btrfs cross-vfsmount reflink works well now with these 2 patches.
> 
> [PATCH] fs: allow cross-vfsmount reflink/dedupe
> [PATCH] btrfs: remove the cross file system checks from remap
> 
> But nfs over btrfs still fail to do cross-vfsmount reflink.
> need some patch for nfs too?

NFS doesn't support reflinks at all, does it?

NeilBrown
