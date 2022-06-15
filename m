Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF1E7C433EF
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Jun 2022 12:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242459AbiFOMb2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 08:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237586AbiFOMb1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Jun 2022 08:31:27 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA67943AC8
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2022 05:31:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 782D71F461;
        Wed, 15 Jun 2022 12:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655296285;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qC0XwSodN3HQceqTA83Fsac90rcuK6AB6fu6f/7R1s0=;
        b=pdf8m7BO2I0C/DIk9Hl67pEhfZ5NGbUQ92C44ETv8K+Z7qS+q65AkUMiHvFMH6hs1gTAav
        KzV0OqMNDJQsw6xKA5QqC5K1Qla4EkKCkpIHIf0dWnjSroXSOaEdi/k917bkICuee4yt1W
        ty6JgcICp2kQde9bntWWxcxUdgp2ZNs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655296285;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qC0XwSodN3HQceqTA83Fsac90rcuK6AB6fu6f/7R1s0=;
        b=NQfIHIoyrR6PCQyT7Y5Fx732+r9WTRswdGW1cdO58Qb3mXTHHTx/SITD3+E8GpIvhIq6ya
        PhztrlcmEyPx+VAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 59FF313A35;
        Wed, 15 Jun 2022 12:31:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id y/j/FB3RqWJuDQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 15 Jun 2022 12:31:25 +0000
Date:   Wed, 15 Jun 2022 14:26:51 +0200
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: sysfs: advertise zoned support among features
Message-ID: <20220615122651.GV20633@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20220606163635.28869-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606163635.28869-1-dsterba@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jun 06, 2022 at 06:36:35PM +0200, David Sterba wrote:
> We've hidden the zoned support in sysfs under debug config for the first
> releases but now the stability is reasonable, though not all features
> have been implemented.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Added to misc-next.
