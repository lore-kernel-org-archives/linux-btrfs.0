Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98F6FC47083
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jun 2021 18:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8059C61DAF
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jun 2021 18:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhFBSCP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 14:02:15 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:42802 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbhFBSCM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jun 2021 14:02:12 -0400
Received: from relay2.suse.de (unknown [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id F3AF91FD2D;
        Wed,  2 Jun 2021 18:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1622656829;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XDRcJvRhv1oDhS/NCMxXNGoiZ++4GsHsbrb+x+oKnlU=;
        b=3KMbqFdYYnl+5xsgMuNXK/vkUkmppD644qRlL9eqwq/we4//u2mbJ8VdUS3U9jOsHzvBRD
        waFOGR9TiOP3m3j5Kb5iieLun7xp4Lo04wGsScye7AVnAuz2hjXWOJrYms2WvdRy/JyOZM
        BIZQSh42uwWQEA4KISbBUa+LyfyfTvI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1622656829;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XDRcJvRhv1oDhS/NCMxXNGoiZ++4GsHsbrb+x+oKnlU=;
        b=QsrYywtDnOSkHoV72EF3JSANUK6r+WO8Ts+n/q0pEMfNSa3vtLj4fWsUQ28NsCopV7tqRM
        KsmzdfLxJXYYDtBA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id ED546A3B8E;
        Wed,  2 Jun 2021 18:00:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F3F6EDA72C; Wed,  2 Jun 2021 19:57:47 +0200 (CEST)
Date:   Wed, 2 Jun 2021 19:57:46 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 00/30] btrfs: add data write support for subpage
Message-ID: <20210602175746.GT31483@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210531085106.259490-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531085106.259490-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, May 31, 2021 at 04:50:36PM +0800, Qu Wenruo wrote:
> This huge patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/subpage
> 
> v4:
> - Disable subpage defrag completely
>   As full page defrag can race with fsstress in btrfs/062, causing
>   strange ordered extent bugs.
>   The full subpage defrag will be submitted as an indepdent patchset.

I went through the whole series and now it's going through fstests (4k
pages, x86) before I move it to misc-next. The write support is
limiting some features but as it's still experimental I don't see a
reason not to enable it. The defrag series has been posted, so that's
the next step, compression won't be difficult to fix I hope and the
inline support is not critical and will be addressed eventually.

I will probably reorder the patches in misc-next so the whole series is
in one batch in case we need to bisect it. As this is first
implementation, there are some known things to clean up or refactor. I'd
rather postpone that for next cycle so there are no conflicts when
merging fixes.

Thank you for taking the subpage support to a working state, even with
the few limitations.
