Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28834C001B0
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Aug 2023 19:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjHITmY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 9 Aug 2023 15:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjHITmX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Aug 2023 15:42:23 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098BCC6
        for <linux-btrfs@vger.kernel.org>; Wed,  9 Aug 2023 12:42:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B2DC821871;
        Wed,  9 Aug 2023 19:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1691610141;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7CpTYulqxRLdFS7MiSJnjrm2v8QX1v8Jwx25YIx8cds=;
        b=V+REZDAl3dMfh+kfyR+LKERUbvyEApAcIJa6TEWTkMs2PUYun+kmvv8W6pFwx9Q4AVsvhi
        8gSW6SYknMq/f7qwdRlaiMUVGAxklwOedKQ7+aAcIruMj/VXuTsUsMXnYw/UcVQxruH2wx
        cepr0brG7ZDyNumN2ODSG/mbd/NiJA4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1691610141;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7CpTYulqxRLdFS7MiSJnjrm2v8QX1v8Jwx25YIx8cds=;
        b=gEO89PWlPScVnUH/ECKPiY2gT1ZpkgtDGIPucnRecQst5J3lP4ceeoSXAUA9eOCjNeE+gs
        j/reov+F4kYxgrCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 93E2713251;
        Wed,  9 Aug 2023 19:42:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KDBMIx3s02QuNgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 09 Aug 2023 19:42:21 +0000
Date:   Wed, 9 Aug 2023 21:42:20 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 0/3] btrfs: fix an ASSERT() triggered inside
 prepare_to_merge()
Message-ID: <ZNPsHMUPvmw5usqB@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1691054362.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1691054362.git.wqu@suse.com>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Aug 03, 2023 at 05:20:40PM +0800, Qu Wenruo wrote:
> [CHANGELOG]
> v4:
> - Remove the remaining commas inside the root key prompt of the 2nd
>   patch

Patches added to misc-next, with the WARN_ONs for now but I'd really
like to get them removed once we discuss it.
