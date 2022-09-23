Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA825ECAAD8
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Sep 2022 09:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbiIWJW6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 05:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbiIWJW4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Sep 2022 05:22:56 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73545E10AB
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Sep 2022 02:22:55 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D27101FA3F;
        Fri, 23 Sep 2022 09:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1663924973;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OBAwlW6CZ1RyiBzd/6fzfDAPzH207gpdN/u4x6RvjKo=;
        b=DP3YxgWhl1DXUslGNULaDQcQIaRmU1eWBo3e6YmNhoMGewdHEw/X415p/TJWEAEueaItYn
        zIHi58xI+kNsGO1/YXCxV8z2Tqt7ndOlA57ZZyAJzfGNibnWgCvImMPTaMJnlyO1mn7AwC
        CALTHUH26KkNeNMWPE7RRXg55n+z8Q8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1663924973;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OBAwlW6CZ1RyiBzd/6fzfDAPzH207gpdN/u4x6RvjKo=;
        b=DkR7in6ZRuqU+BousenvHm4MyuwaShX5Oq+hByUv/yT7gxhVesSmhqvPGIiCVSHFkj5oCM
        5QOaKYKwJBCBQwAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B4AC113A00;
        Fri, 23 Sep 2022 09:22:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Sa4gK+16LWOQIgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Fri, 23 Sep 2022 09:22:53 +0000
Date:   Fri, 23 Sep 2022 11:17:21 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sidong Yang <realwakka@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: doc: Add cross reference for manual
Message-ID: <20220923091721.GP32411@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20220808072856.5155-1-realwakka@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220808072856.5155-1-realwakka@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Aug 08, 2022 at 07:28:56AM +0000, Sidong Yang wrote:
> RST format provides cross reference function that users can navigate
> manual pages click. This patch is written by macro that replace old
> reference to doc role in RST format.
> 
> Signed-off-by: Sidong Yang <realwakka@gmail.com>

Thank you, added to devel. I've seen some missing references eg. to
mkfs.btrfs but this can be added incrementally now that the formatting
is established.
