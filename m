Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3A7C433F5
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 May 2022 18:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237367AbiEBSrV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 2 May 2022 14:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiEBSrS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2022 14:47:18 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DCB5FA6
        for <linux-btrfs@vger.kernel.org>; Mon,  2 May 2022 11:43:48 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 566341F749;
        Mon,  2 May 2022 18:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1651517027;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v9UYKxovVZF4MlGOG3zrWuKx4AotKOGK553BnebkBeQ=;
        b=IMd2R2KVn4iZWVYW5bWQLko45ZFhQIdL35q0l0XNBU05fpqSOMuODzeY4OyV4ZNALlzHWu
        YLOYhvoycoeyUWVUHRqDHvOcd1j1PLpMQFZP2AzUIWPYtkJA9H2Q1Zu+KbP+bIVTTba4R6
        fPYeVVnaBklawMiJAb7UjF2hWJ7j40g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1651517027;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v9UYKxovVZF4MlGOG3zrWuKx4AotKOGK553BnebkBeQ=;
        b=ZZuG5DdpAGbVWrCA4s76ELJvPa1HxZEyr0XTigzXQnpA8niAspzGP4M3EKFxXRjMEfwpSz
        VFFbuEkDjAzFgjAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 33A3213491;
        Mon,  2 May 2022 18:43:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /T63C2MmcGIaHwAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 02 May 2022 18:43:47 +0000
Date:   Mon, 2 May 2022 20:39:36 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Gabriel Niebler <gniebler@suse.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.com
Subject: Re: [PATCH] btrfs: Turn fs_roots_radix in btrfs_fs_info into an
 XArray
Message-ID: <20220502183936.GN18596@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Gabriel Niebler <gniebler@suse.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.com
References: <20220426214525.14192-1-gniebler@suse.com>
 <a2b7e2c4-440c-318c-ea1f-273be04591f0@suse.com>
 <e4ced932-1f39-86fb-c0a4-018c47cf10fa@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e4ced932-1f39-86fb-c0a4-018c47cf10fa@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, May 02, 2022 at 10:59:01AM +0200, Gabriel Niebler wrote:
> Am 28.04.22 um 13:59 schrieb Nikolay Borisov:
> > On 27.04.22 г. 0:45 ч., Gabriel Niebler wrote:
> >> … rename it to simply fs_roots and adjust all usages of this object to 
> > While the while/xa_for_each_marked and not straight xa_for_each_marked?
> 
> Like before, this just mimicks the old logic, because I wasn't sure 
> whether the double loop is only due to the bunched nature of gang lookup 
> or whether it has some additional safeguarding function.
> 
> I'm fine with simplifying it to xa_for_each_marked if you say it's safe.
> 
> Waiting for further feedback whether to resubmit or not.

I don't have any more comments and it's rc5 so not much time left before
code freeze, so please resend, thanks.
