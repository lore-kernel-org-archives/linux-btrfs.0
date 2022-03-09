Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB24EC433FE
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Mar 2022 18:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236166AbiCISkc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 13:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233306AbiCISkb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2022 13:40:31 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F77156C4F
        for <linux-btrfs@vger.kernel.org>; Wed,  9 Mar 2022 10:39:31 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7D6CC21121;
        Wed,  9 Mar 2022 18:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1646851170;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=36O3NS/5RiNZ19yL2r40tAZZ5WqWPOMXCs95Kmfy7sQ=;
        b=pmwhHIdQHpRocmzlu7nbCdH4rfk5NdvzjvnxNpW+U4YC1VviDMyVNKeK2KKc/OCX9v6Ilu
        Eoaz//EmE1GliBanSTLeAe/nGlrvxHKIRfmOfS+CEPu0xtqrEhwqGfXpwjl5WScypu2Cgg
        Z/ZKKfcnunZTUL7OukOB/UTaWOelNQE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1646851170;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=36O3NS/5RiNZ19yL2r40tAZZ5WqWPOMXCs95Kmfy7sQ=;
        b=k5Thght+eIeDMPEJVv0uqNomGm4v6yYOFSYFm6ZeLhqdsGy/LKv9oEze3sJQ7UaPtL5Rw0
        eOZUInJTc7wu8MDw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 7A0A9A3B81;
        Wed,  9 Mar 2022 18:39:30 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C3A4DDA7DE; Wed,  9 Mar 2022 19:35:34 +0100 (CET)
Date:   Wed, 9 Mar 2022 19:35:34 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v5 18/19] btrfs-progs: mkfs: create the global root's
Message-ID: <20220309183534.GZ12643@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1646690972.git.josef@toxicpanda.com>
 <7cadc40e9f8510b8df5679e15881f2c0de70363a.1646690972.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cadc40e9f8510b8df5679e15881f2c0de70363a.1646690972.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 07, 2022 at 05:11:03PM -0500, Josef Bacik wrote:
> Now that we have all of the supporting code, add the ability to create
> all of the global roots for an extent tree v2 fs.  This will default to
> nr_cpu's, but also allow the user to specify how many global roots they
> would like.

Why is number of online cpus a good default? Or how a user should know
what's a good number? It resembles the allocation groups on xfs that
are set at mkfs time and once the filesystem is grown the size remains
but the number explodes and becomes problematic if the the old/new sizes
are disproportionate. We have more flexibility in btrfs with the resize
so we could afford to set the intial number based rather on the device
size and then a rebalance after resize can adjust that again. Maybe
there's something in kernel taking care of that, I don't know.
