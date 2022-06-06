Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D472C433EF
	for <linux-btrfs@archiver.kernel.org>; Mon,  6 Jun 2022 21:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiFFVB1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 17:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiFFVBJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jun 2022 17:01:09 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5066BC3D1A
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Jun 2022 13:49:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4081C1F948;
        Mon,  6 Jun 2022 20:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654548585;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9EZQlKOkpnivVXAI7k2iIczi4utJy4E+yndqbJQRs3Q=;
        b=hU3NL2uycmmrCfBYPkiFndzpya+2lETj3sY9rEY59wndWOFW5M2Zy5lNcQ1hC1QlKfKK6U
        Z+5lmgzjbvGnVW/e0dXkPoLsq0sgF0EZZkB1ytyLjCmP5cguIS9cb4XGFcts3Dtz/LOe9O
        C2GJNixUZnHRE2lbiypywqFbwHN+NTM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654548585;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9EZQlKOkpnivVXAI7k2iIczi4utJy4E+yndqbJQRs3Q=;
        b=494ksVq7/2I9IHMiLbqo83EeoWFKDBHGPh0cD98YBy7DEOdqdddqfLSdXqHTu4Ltn/dWa/
        EplDoCCijLcGJOCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1690513A5F;
        Mon,  6 Jun 2022 20:49:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ZNX8A2lonmI7VAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 06 Jun 2022 20:49:45 +0000
Date:   Mon, 6 Jun 2022 22:45:15 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs: a couple bug fixes around reflinks and
 fallocate
Message-ID: <20220606204515.GG20633@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <cover.1654508104.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1654508104.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jun 06, 2022 at 10:41:16AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> This patchset fixes a couple of bugs, the first one exclusive for reflink
> operations while the second one applies to reflink, fallocate and hole
> punching operations. Finally the third patch just removes some BUG_ON()s
> that are really not needed.
> All the patches are independent of each other, they could have been sent
> out as individual patches.
> 
> Filipe Manana (3):
>   btrfs: fix race between reflinking and ordered extent completion
>   btrfs: add missing inode updates on each iteration when replacing
>     extents
>   btrfs: do not BUG_ON() on failure to migrate space when replacing
>     extents

Added to misc-next, thanks.
