Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD88C76196
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Mar 2023 18:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjC1SAD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 28 Mar 2023 14:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjC1R7u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2023 13:59:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E4312054
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Mar 2023 10:59:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2F1A71FDEC;
        Tue, 28 Mar 2023 17:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1680026379;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SeBC3vuiySZ/ySrTfWiMeHWxcfe+rFxO88TZdHR0ecA=;
        b=gQ/pXET6R4KCZDg//rxyqybDd/Ow1vdbgjnkZKuyj1hvAcBrYL6lbpqdkMgO3l5OMMhKyC
        TAtJilPhMu/IpQAMG9PyJ84UfBYAFVzlHmezwJR70EQ/KNZTvXUTxv+cVyvVoOJkDrBprz
        wTbVxcPQxcIJEAyd3K5Up1h1BScywXs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1680026379;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SeBC3vuiySZ/ySrTfWiMeHWxcfe+rFxO88TZdHR0ecA=;
        b=pO8XPzYvkCptzl1eQHx9AHj7j1UkPZthJB5POghsiQERpRWiGCY9HW69/N0uuc32ntyJMv
        vtFb7MXf46flGoDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 035B21390B;
        Tue, 28 Mar 2023 17:59:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sx8LAAsrI2RkaAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Tue, 28 Mar 2023 17:59:38 +0000
Date:   Tue, 28 Mar 2023 19:53:24 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Boris Burkov <boris@bur.io>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Naohiro Aota <Naohiro.Aota@wdc.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 05/11] btrfs: simplify btrfs_extract_ordered_extent
Message-ID: <20230328175324.GM10580@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20230328051957.1161316-1-hch@lst.de>
 <20230328051957.1161316-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328051957.1161316-6-hch@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 28, 2023 at 02:19:51PM +0900, Christoph Hellwig wrote:

Subject: Re: [PATCH 05/11] btrfs: simplify btrfs_extract_ordered_extent

Please don't write subjects like 'simplify function'. There are many
ways how a function can be simplified or cleaned up and with so many
patches being merged it's obscuring what is actually being changed.  I'm
editing where I think the subject does not match and I won't bother
anybody if it's rare but within this series 3 out of 6 have such
subject. The changelog usually has that so the subject should state what
or how things are simplified.
