Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B176C001E0
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Jul 2023 16:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbjG0Q60 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 12:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbjG0Q6Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2023 12:58:24 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1560F30C0
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jul 2023 09:58:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 92BCB1F383;
        Thu, 27 Jul 2023 16:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1690477099;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ao7hclJiNt7CtqjpG8KqXtno5bKRq3fLHcEVi5RNRzI=;
        b=BtPL0ob3+uevbCqVk7exe+DGL2wq7MBn3nWij6aMJdq4EOTitRzkOr7CbwTNW4d2DEglpa
        0O4tjosALfHIrDCrBR8dOJD5i/OhOxz2b6Du7a1FPRjPxxJ94pYaRaJv7ofYrcH5C0FHy6
        nsmcyOSXg1OT1+Roa3U1eP1cRzoaSMw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1690477099;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ao7hclJiNt7CtqjpG8KqXtno5bKRq3fLHcEVi5RNRzI=;
        b=f9jEBtdhrlInXEtEyPXQ5SU5fqc4fHZHG5yvFzSsjwGkyQ0Gk+McVo/p0IuboYwBCKUy0S
        iFsJzRNISvLWHzCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6E351138E5;
        Thu, 27 Jul 2023 16:58:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1jMZGSuiwmQcWwAAMHmgww
        (envelope-from <dsterba@suse.cz>); Thu, 27 Jul 2023 16:58:19 +0000
Date:   Thu, 27 Jul 2023 18:51:57 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: tests: not_run for global_prereq fail
Message-ID: <20230727165157.GG17922@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <149265ca8a94688008c1cda96c95cf83ac55950c.1690024017.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149265ca8a94688008c1cda96c95cf83ac55950c.1690024017.git.anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jul 25, 2023 at 05:43:54PM +0800, Anand Jain wrote:
> Prerequisite checks using global_prereq() aren't global, so why
> fail and stop further test cases? Instead, just don't run them.

I'd rather let the whole testsuite run, a missing global prerequisity
means the environment is not set up properly, so this fail as intended.
If you look what kind of utilities are checked in that way it's eg. dd,
mke2fs, chattr, losetup. All are supposed to be available on a common
system so it's not expected to fail.

If there's some less common utility and a test which could be optional
then this should be a special case, which would require a new helper.
