Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6A7EC0015E
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Jul 2023 16:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjG1Q5b (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Jul 2023 12:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbjG1Q5T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2023 12:57:19 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DE84483
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jul 2023 09:57:02 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DABB91F853;
        Fri, 28 Jul 2023 16:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1690563420;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cB3b2RteAJTicCMa04OTTGBeRFsXbKxK1XcIggZI2AU=;
        b=pTCxgUB467kOJalRwySFTQyubC+ILW17hcRfmTtjm9h/N8CYwIF8WwAWr3VZoKODRG4Tr0
        9H93EyqJebhWiAPzdPHkIr56ftVIdVas7pwcqmxhX04CqH708ic/uokq3KgtRS/Gazsihe
        vu8w7qGJmG+/r1vnsmhnsFt4aVSfkQA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1690563420;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cB3b2RteAJTicCMa04OTTGBeRFsXbKxK1XcIggZI2AU=;
        b=ZqxqpKb01a+cmTIpv2muvwiVqozzVICBMPbrjfmKe7ErggpqpP1IGHJh73dcjw6JuY4Ihc
        o4M2uq8kTzoWnFAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8EC2613276;
        Fri, 28 Jul 2023 16:57:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dd5rIFzzw2S8aQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Fri, 28 Jul 2023 16:57:00 +0000
Date:   Fri, 28 Jul 2023 18:50:37 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Martin Steigerwald <martin@lichtvoll.de>
Cc:     linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH 0/5] btrfs: scrub: improve the scrub performance
Message-ID: <20230728165037.GJ17922@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1690542141.git.wqu@suse.com>
 <6543972.G0QQBjFxQf@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6543972.G0QQBjFxQf@lichtvoll.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jul 28, 2023 at 02:38:35PM +0200, Martin Steigerwald wrote:
> Qu Wenruo - 28.07.23, 13:14:03 CEST:
> > The first 3 patches would greately improve the scrub read performance,
> > but unfortunately it's still not as fast as the pre-6.4 kernels.
> > (2.2GiB/s vs 3.0GiB/s), but still much better than 6.4 kernels
> > (2.2GiB vs 1.0GiB/s).
> 
> Thanks for the patch set.
> 
> What is the reason for not going back to the performance of the pre-6.4 
> kernel? Isn't it possible with the new scrubbing method? In that case 
> what improvements does the new scrubbing code have that warrant to have 
> a lower performance?

Lower performance was not expected and needs to be brought back. A minor
decrease would be tolerable but that's something around 5%, not 60%.

> Just like to understand the background of this a bit more. I do not mind 
> a bit lower performance too much, especially in case it is outweighed by 
> other benefits.

The code in scrub was from 3.0 times and since then new features have
been implemented, extending the code became hard over time so a bigger
update was done restructuring how the IO is done.
