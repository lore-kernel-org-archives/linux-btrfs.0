Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE8CC433EF
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Mar 2022 19:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiCNTXI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Mar 2022 15:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244009AbiCNTWt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Mar 2022 15:22:49 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FE61EC57
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Mar 2022 12:21:39 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 422021F37E;
        Mon, 14 Mar 2022 19:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1647285698;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ctWGwSzNOsVbHQEuHjBoeTfMxayFZvVA8RKPSQkSrtI=;
        b=lq3jCMGpCiGW4nZeczwZH/GRpWo/l89ZAMTDLApEZ8ks1dJwBEDROFtfH6w5Pu77MYsboG
        RSXM93p6U5h4APuYwgITfQphLHrwG6bbtb3fwTjv+7+/G+KMtvlfETR6D2/NUHvzR9OUvy
        jSv2akyMrYkWyBGiRjt3zeudGlJhQok=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1647285698;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ctWGwSzNOsVbHQEuHjBoeTfMxayFZvVA8RKPSQkSrtI=;
        b=pEZeeRBuwaVO/QOqo3aZlfcBhyzTc05Ora8oppHDACyR7/9Uw74X6K81wmOBZQFM64lgrH
        Q4XRTV2fwOWBkYAA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 36F49A3B83;
        Mon, 14 Mar 2022 19:21:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D55E2DA7E1; Mon, 14 Mar 2022 20:17:39 +0100 (CET)
Date:   Mon, 14 Mar 2022 20:17:39 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/3] btrfs: scrub: rename members related to
 scrub_block::pagev
Message-ID: <20220314191739.GN12643@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1646983771.git.wqu@suse.com>
 <b971391a31a3cee8f7c19d02dd2a48328c580d1b.1646983771.git.wqu@suse.com>
 <20220311174914.GE12643@twin.jikos.cz>
 <3c5ddeae-69dd-2dd9-c15b-a811396a8981@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c5ddeae-69dd-2dd9-c15b-a811396a8981@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Mar 12, 2022 at 07:17:42AM +0800, Qu Wenruo wrote:
> >> @@ -1078,16 +1078,16 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
> >>   	 * area are unreadable.
> >>   	 */
> >>   	success = 1;
> >> -	for (page_num = 0; page_num < sblock_bad->page_count;
> >> -	     page_num++) {
> >> -		struct scrub_page *spage_bad = sblock_bad->pagev[page_num];
> >> +	for (sector_num = 0; sector_num < sblock_bad->sector_count;
> >
> > This is a simple indexing, so while sector_num is accurate a plain 'i'
> > would work too. It would also make some lines shorter.
> 
> Here I intentionally avoid using single letter, because the existing
> code is doing a pretty bad practice by doing a double for loop.
> 
> Here we're doing two different loops, one is iterating all the sectors,
> the other one is iterating all the mirrors.
> 
> Thus we need to distinguish them, or it' can easily get screwed up using
> different loop indexes.

Yeah in this case it makes more sense to keep the descriptive name.
