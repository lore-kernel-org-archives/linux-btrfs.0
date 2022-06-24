Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFD1C433EF
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 Jun 2022 13:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbiFXNrb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 24 Jun 2022 09:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbiFXNr2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Jun 2022 09:47:28 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CFB2659
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2022 06:47:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 33CBA1F8F3;
        Fri, 24 Jun 2022 13:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1656078445;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ihPEMAzo4hFF1kCHKpy9UyUyONlf6JzV7CaLiUrLMIU=;
        b=W1wOVusIMuwASaeFy0QqdcA+Cn9LQoVXGpEkORNEFqZOVjocbgwp+xGHjraEMpd/gPwcfA
        DgYNRC+Y1+g+CU6l4y4QPuupckK+Q1WEso2U56DifKvl2YZANOJe3NJ0UgUOZCZ5i25B/z
        4oBcu39+u3jVvQ++3rBav4uz+Pdo1RI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1656078445;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ihPEMAzo4hFF1kCHKpy9UyUyONlf6JzV7CaLiUrLMIU=;
        b=d656UJKOqL20CyFQeSqqJHc6or1jQLeaU+k71VjPPxNgHtoy7g+7wS2TvmYg4g+D93qhXf
        FCNiqEiq1oJW/LCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1078013480;
        Fri, 24 Jun 2022 13:47:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LoPXAm3AtWIBDgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Fri, 24 Jun 2022 13:47:25 +0000
Date:   Fri, 24 Jun 2022 15:42:46 +0200
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] Profile mask and calculation cleanups
Message-ID: <20220624134246.GU20633@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1655996117.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1655996117.git.dsterba@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jun 23, 2022 at 04:56:58PM +0200, David Sterba wrote:
> There are still some instances of hardcoded values repeating what we
> have in the raid attr table or using a similar expresion to calculate
> things that can be simplified.
> 
> David Sterba (2):
>   btrfs: use mask for all RAID1* profiles in btrfs_calc_avail_data_space
>   btrfs: merge calculations for simple striped profiles in
>     btrfs_rmap_block

Added to misc-next.
