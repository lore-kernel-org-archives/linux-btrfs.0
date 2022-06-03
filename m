Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16FA2C43334
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 Jun 2022 16:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343756AbiFCQuT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 3 Jun 2022 12:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbiFCQuS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2022 12:50:18 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4D54D62F
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Jun 2022 09:50:17 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id F170221B92;
        Fri,  3 Jun 2022 16:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654275015;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NKbIOMwzLT/o2qQANarbJsFPN6gYz3egG6Q3+17XBx8=;
        b=aeMTmacDkO7QWgQgixN/9DPuYudayIYdKh48vOidLj9MN6kpDYaL4uOJCTIA/Bu7FMItA2
        7Ppb1fkulIrUw6O4mRUKOA6sNFpgEObBPEk0VXkbnzX6oUpeyeONfk+K3yVO3GwUlc4obv
        Fc9IqfwSx2F+op2B24tfjfokv6LY8R4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654275015;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NKbIOMwzLT/o2qQANarbJsFPN6gYz3egG6Q3+17XBx8=;
        b=DrInb3CWODXFPhS09xJ0m0Nq5/es6hw5UL2go+al2bOy3gKbBpqeUQV2hRKPmHC4UZ4qzP
        Ys9jxyuFaBXlLJBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C086813AA2;
        Fri,  3 Jun 2022 16:50:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id A8IRLsc7mmIFTAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Fri, 03 Jun 2022 16:50:15 +0000
Date:   Fri, 3 Jun 2022 18:45:48 +0200
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.cz>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>, Christoph Hellwig <hch@lst.de>,
        David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 05/10] btrfs: defer I/O completion based on the
 btrfs_raid_bio
Message-ID: <20220603164548.GX20633@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Christoph Hellwig <hch@lst.de>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20220429143040.106889-1-hch@lst.de>
 <20220429143040.106889-6-hch@lst.de>
 <4e93a857-43f2-9e67-9ef8-4db00edd2f6c@gmx.com>
 <6dba9162-c64d-2d27-12eb-d48ac6a4ac8a@gmx.com>
 <20220603164456.GW20633@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603164456.GW20633@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jun 03, 2022 at 06:44:56PM +0200, David Sterba wrote:
> The test passes on my VM setup, the whole suite was run on the patchset
> at least twice.

Oh never mind, this is some old version.
