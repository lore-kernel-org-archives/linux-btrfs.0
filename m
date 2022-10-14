Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5129C433FE
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Oct 2022 11:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiJNLHW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 14 Oct 2022 07:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiJNLHS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2022 07:07:18 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049BB1C3E5C;
        Fri, 14 Oct 2022 04:07:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8DF90219DD;
        Fri, 14 Oct 2022 11:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1665745635;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7FcU2S9uqEm0CF6BB/SeeVZUQ8dYpwJbuPliwF+3+u4=;
        b=SYcIgs4skApYS0e5EN6rInsFGICWVwqoNK+ghYA5Ty6cldmzTNNLJSQaTJ3ZkEso912ev/
        MDpGENX6+WjMe6Ck6N0I1PNPlB1GEnPKR5HGpPoN6ggiuTAX3lAyohkAgqWofwVDFudy6c
        KxfrSgRfyNa9h4Ijf/cPr0QREvetgVU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1665745635;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7FcU2S9uqEm0CF6BB/SeeVZUQ8dYpwJbuPliwF+3+u4=;
        b=kSyioArW0Ot6k3tzUeWahYwFpst7csAxWJt74L6cj8Rbf0E71wb5ojBbvoanUlPjw4MupU
        UaD4MqA/P6tFZ3CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5738713451;
        Fri, 14 Oct 2022 11:07:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SN8xFONCSWODWAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Fri, 14 Oct 2022 11:07:15 +0000
Date:   Fri, 14 Oct 2022 13:07:08 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Viktor Kuzmin <kvaster@gmail.com>
Subject: Re: Bug 216559 - btrfs crash root mount RAID0 caused by ac0677348f3c2
Message-ID: <20221014110708.GE13389@suse.cz>
Reply-To: dsterba@suse.cz
References: <8be1e839-2eb8-43d0-9ecb-6ff8c3aa3f2d@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8be1e839-2eb8-43d0-9ecb-6ff8c3aa3f2d@leemhuis.info>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 11, 2022 at 02:09:50PM +0200, Thorsten Leemhuis wrote:
> Hi, this is your Linux kernel regression tracker speaking.
> 
> David, I noticed a regression report in bugzilla.kernel.org apparently
> caused by a changed of yours. As many (most?) kernel developer don't
> keep an eye on the bug-tracker, I decided to forward the report by mail.
> Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=216559 :

Thanks, you don't need to forward the mails as I'm on CC of all bugzilla
updates where the btrfs virtual assignee is also present. But feel free
to ping regarding any regressions you're tracking and would like an
update.

Inspired by the LPC talk about bugzilla I went through all 650+ btrfs
bugs and closed what looked either fixed or not relevant anymore. The
rest are recent reports or bugs that may need to be moved elsewhere.
As kernel.org bugzilla is recommended for reports in our community
documentation I monitor new bugs but with variable reaction time.
