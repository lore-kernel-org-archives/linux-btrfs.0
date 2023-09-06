Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1458DEE14A0
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Sep 2023 16:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236228AbjIFQZi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Sep 2023 12:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243024AbjIFQZh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Sep 2023 12:25:37 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C5C19A6
        for <linux-btrfs@vger.kernel.org>; Wed,  6 Sep 2023 09:25:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9ABA62242C;
        Wed,  6 Sep 2023 16:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1694017530;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=65lfc3ReVSlI8i388b1bdYjFyYODC3H9S+H27YGhCjU=;
        b=EasH26nSTjvCfrO+Lsg63EtCoiZOhqguJv/KqZce1ye3dy1UyLdzheMHKYbK5ICfP8zWmb
        THnv+aldTCPaIl5kafMjz59mOvnsSyofQr5OcKhUfAJ45kSAgB8PMCVGlGhVBR0bZ+ctnJ
        UL9ByRvAKNZ2AN5uuz2uFm9PK5aavKU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1694017530;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=65lfc3ReVSlI8i388b1bdYjFyYODC3H9S+H27YGhCjU=;
        b=IlSJ56tUFNl9l3N9Kaw6u+09FjP8sGLxit9BUeOD+Lfwss7MQo92h6twQL6yvCJ01tGOd9
        XI3fTeKNUXwZS3BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7F6AC1333E;
        Wed,  6 Sep 2023 16:25:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id y5hkHvqn+GTyfgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 06 Sep 2023 16:25:30 +0000
Date:   Wed, 6 Sep 2023 18:18:50 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/2] Fix some -Wmaybe-uninitialized errors
Message-ID: <20230906161850.GP14420@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1693930391.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1693930391.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Sep 05, 2023 at 12:15:22PM -0400, Josef Bacik wrote:
> Hello,
> 
> Jens reported to me two warnings he was seeing with
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y set in his .config.  We don't see these errors
> without this option, and they're not correct warnings.  However we've had issues
> where -Wmaybe-uninitialized would have caught a real bug, so this warning is
> generally valuable.  Fix these warnings so we have a clean build.  Thanks,
> 
> Josef
> 
> Josef Bacik (2):
>   btrfs: make sure to initialize start and len in find_free_dev_extent
>   btrfs: initialize start_slot in btrfs_log_prealloc_extents

Added to misc-next, thanks.
