Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74D74C4332F
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Nov 2022 17:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiKURan (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 12:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiKURai (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Nov 2022 12:30:38 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1448CFEB4;
        Mon, 21 Nov 2022 09:30:36 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 60FF11F8B5;
        Mon, 21 Nov 2022 17:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1669051835;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YC/w1ZEf/yD+TKSVm+XUDS5wiWuV45v3F3idSErZQMA=;
        b=eZc9FKzLIkXrJrcU19DEQfSb8rSNHkirEGnbdq2370z/w68KZ1Acq/KfMSPCzUKK+gdnQt
        Cu7QglOARinVzB13G9d6vn/YiAr2mAKFACiA/gv0iVLJ7of9BGILGI0TJ21XMW1mu2D7lr
        RU1fd9gKNPeeIl0KqQQlycob4ldMk7U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1669051835;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YC/w1ZEf/yD+TKSVm+XUDS5wiWuV45v3F3idSErZQMA=;
        b=o1N2cd5tBR413l9hk59J6J+bkfq/70MWFTXCOF5/uXk3W1tpIlZSZqsvEVd28yqfguqhpi
        3JdJ8IdPFRyYXhAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 236171376E;
        Mon, 21 Nov 2022 17:30:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id inarB7u1e2PbBAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 21 Nov 2022 17:30:35 +0000
Date:   Mon, 21 Nov 2022 18:30:05 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fsdevel@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs: replace INT_LIMIT(loff_t) with OFFSET_MAX
Message-ID: <20221121173005.GX5824@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20221121024418.1800-1-thunder.leizhen@huawei.com>
 <20221121024418.1800-2-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121024418.1800-2-thunder.leizhen@huawei.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 21, 2022 at 10:44:17AM +0800, Zhen Lei wrote:
> OFFSET_MAX is self-annotated and more readable.
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>

Acked-by: David Sterba <dsterba@suse.com>
