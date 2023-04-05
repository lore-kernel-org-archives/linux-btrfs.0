Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A02C76188
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Apr 2023 14:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238436AbjDEONr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 10:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238420AbjDEONp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Apr 2023 10:13:45 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBE96584;
        Wed,  5 Apr 2023 07:13:14 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id ECF5F22983;
        Wed,  5 Apr 2023 14:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1680703989;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SvbV+PinMSKHNoB9VosPV0w7RxMonlsP9KQkPmAEhWY=;
        b=FoF56ZHXxyAgLxih3BG9EW0VaGZS4v2kb2ns5YLoT001n1cdERg5THsuXebKu1kkkVDbe8
        q3YeZf9VR6Xui0dnIbdeYLtL5NT7NihfpXrIBGczcLU6wQN82Mu3qRTeLMUEUtFmRKM/GW
        vA8vDrperyyx+WZs34kJqnw9lgwG6vc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1680703989;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SvbV+PinMSKHNoB9VosPV0w7RxMonlsP9KQkPmAEhWY=;
        b=UfRQW/KAYm5b6RYY1d0SD9E+IyTSZejumdvpV1K1jPEQ7cZdAdM+IrAX2m3n1Owq+CMlix
        nv0NWwnuXVXykSBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B96C013A31;
        Wed,  5 Apr 2023 14:13:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id B2R5LPWBLWQrAwAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 05 Apr 2023 14:13:09 +0000
Date:   Wed, 5 Apr 2023 16:13:07 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] btrfs: Fix spelling mistake "geneartion" ->
 "generation"
Message-ID: <20230405141306.GJ19619@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20230405100040.12176-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405100040.12176-1-colin.i.king@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 05, 2023 at 11:00:40AM +0100, Colin Ian King wrote:
> There are a handful of spelling mistakes of generation. Fix them.

Thanks for spotting it, seems that 'geneartion' is Qu's favourite typo,
I'll fix it in the topic branch.
