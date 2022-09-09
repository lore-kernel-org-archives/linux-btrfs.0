Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC3D5C6FA82
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Sep 2022 14:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbiIIOtj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Sep 2022 10:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbiIIOtf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Sep 2022 10:49:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A39B15A25;
        Fri,  9 Sep 2022 07:49:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6B5BA1F8FB;
        Fri,  9 Sep 2022 14:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662734971;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gaael0CnI+T+Fan9Q5U4UOyHvyNFIkhZ/P10JsrjeEI=;
        b=eBaVj44RJa6/uYOJaQcGuN+GeB455veuSalLKa9CdXWb61DlZmNkmPOdjAp7h/BxqNJo1j
        JR3pjux135yPZ5HpcFD/7GwJI6kvGCn10kkdQuUefA3LOYD8JsMmil002TnfJOvlIiD8LA
        9nASDJ1uMSierKbQYy2IbkbvrlbECCM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662734971;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gaael0CnI+T+Fan9Q5U4UOyHvyNFIkhZ/P10JsrjeEI=;
        b=/EtFrOEaMAZ/BxSlQLZKa8Uc9B5qDPUq1+Yp/qqqoOiTcoWHqMgOzMT06GSco9X51B3xCO
        Ea9o8Am2mZBUU9DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3A7E813A93;
        Fri,  9 Sep 2022 14:49:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Nhs+DXtSG2P3YwAAMHmgww
        (envelope-from <dsterba@suse.cz>); Fri, 09 Sep 2022 14:49:31 +0000
Date:   Fri, 9 Sep 2022 16:44:06 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: qgroup: Fix a typo in a comment
Message-ID: <20220909144406.GA32411@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <c81a4f359ff8a1443168b9c308dcd621ba24e5c5.1659814948.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c81a4f359ff8a1443168b9c308dcd621ba24e5c5.1659814948.git.christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Aug 06, 2022 at 09:42:34PM +0200, Christophe JAILLET wrote:
> Add a missing 'r'.
> s/qgoup/qgroup/

I don't know why codespell does not catch it, I don't have other typo
fixes so I'll apply this. Thanks.
