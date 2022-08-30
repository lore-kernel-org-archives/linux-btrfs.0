Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22120ECAAD4
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Aug 2022 22:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbiH3WAm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 18:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbiH3WAN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2022 18:00:13 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33227A0249
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Aug 2022 14:55:38 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 61C6822020;
        Tue, 30 Aug 2022 21:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1661896461;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dPNfTFYzdc1CLpTThKwlqRdHX2xVWBZBAcSN9vYbCSI=;
        b=LkKIbYJtlIns9vZMggjtxWOZsx3HWkKQ6m+okV2ZDoYzwC7sAupkwFfeTt/5CinfCvkp3j
        8Kf/7pG+l4OEtZ95ZLFb20HqwNXnHe/DGvuo9HMT/WIfV45u68V/THwxFnRJ5I/Q73giQq
        Pb9m//KENpIch0lsVjTsh2FvN3ahUr0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1661896461;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dPNfTFYzdc1CLpTThKwlqRdHX2xVWBZBAcSN9vYbCSI=;
        b=MaZbAFOufO77uzhDd4GKEVM9kC1O2KVYL/0JtVQFOKvcMNKyNQB5WPhiff5OoXzYqIN89K
        5S5z97Wx2dYmAeDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3BB5113B0C;
        Tue, 30 Aug 2022 21:54:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Opg2DQ2HDmMwYAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Tue, 30 Aug 2022 21:54:21 +0000
Date:   Tue, 30 Aug 2022 23:49:02 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix eb leakage caused by missing
 btrfs_release_path() call.
Message-ID: <20220830214902.GE13489@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <043f1db2c7548723eaff302ebba4183afb910830.1661835430.git.wqu@suse.com>
 <20220830171730.GB13489@twin.jikos.cz>
 <72b31d43-07fc-6126-b326-5110315ae342@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72b31d43-07fc-6126-b326-5110315ae342@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Aug 31, 2022 at 05:49:13AM +0800, Qu Wenruo wrote:
> > I do that because that's the preferred style, but not all people respond
> > to mailing list comments so we're left with unfixed bug with patch or a
> > unclean version committed if there's no followup. Or something in
> > between that could introduce bugs.
> 
> Another thing related to this on-stack path usage is, do we need the
> same change in kernel space?

No, in kernel the stack space is a limited resource.

> And do we prefer on-stack path initialized to all 0, or use
> btrfs_init_path()?

It's initialized by btrfs_init_path everywhere else so for consistency
this should be used, though the memset 0 is also possible, there are
only int types or pointers in the structure.
