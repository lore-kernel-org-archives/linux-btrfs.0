Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 014F9C77B61
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Apr 2023 16:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjDMQVJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Apr 2023 12:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjDMQVI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Apr 2023 12:21:08 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85AC19A3
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Apr 2023 09:21:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 301DB2184F;
        Thu, 13 Apr 2023 16:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1681402864;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AgaAoj1SjbWvphxh9oFZ7qtyh4kgfrr2pN3Syq7g+Dk=;
        b=O6HxWq7rUQUB50ue7sTcwpBCODjq9fN2pzjD33P6wTh6QQdpWi5VoWbvwSBQ5/hi8AC8Ng
        yBA/TGJ5He4fI4WDDg7BHcGBgsUIIUf8pKmV1puCqJkPldjZ2ufVsysc0LODR/vUMWAyP6
        7LyYI7UvtNXbtNvTeO8Px38DquphJjE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1681402864;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AgaAoj1SjbWvphxh9oFZ7qtyh4kgfrr2pN3Syq7g+Dk=;
        b=IWZxmIyKEmFW52nTKLjJzMoqcRXQSeL8lUm8gchqqjBNXkXuGJHnoqcaVrbJnsn/RclTOm
        lbcdwlhx+nrps/Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 118D013421;
        Thu, 13 Apr 2023 16:21:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id l3WEA/ArOGR3dQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Thu, 13 Apr 2023 16:21:04 +0000
Date:   Thu, 13 Apr 2023 18:20:57 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs-progs: move block-group-tree out of
 experimental features
Message-ID: <20230413162057.GG19619@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1681180159.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1681180159.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 11, 2023 at 10:31:04AM +0800, Qu Wenruo wrote:
> People are complaining block-group-tree features are not accessible for
> non-experimental builds.
> 
> So let's make it a stable feature.
> 
> Since we're here, it's also a good time to deprecate
> -R|--runtime-features option.

As a major release is near it's a good time to do such changes. Merging
-R back to -O is OK. I looked again how robust the conversion to bgt is
wrt to a crash in the middle. If the process is restarted it should be
fine, though I'm not sure what happens when the fs would be mounted and
written to with the ongoing conversion.

We don't have any test coverage of the feature, at least what is
possible from user space. Mount and other things need kernel 6.1 which
is not in CI.
