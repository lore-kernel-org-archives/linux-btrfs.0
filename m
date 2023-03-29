Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A039C74A5B
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Mar 2023 17:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjC2RoP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 29 Mar 2023 13:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC2RoO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2023 13:44:14 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F92D525E
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Mar 2023 10:44:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 441A21FE25;
        Wed, 29 Mar 2023 17:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1680111849;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GFXQBOEPVDp2/JHFNcJ9r/5PGOJeCWVJg18VPhpSW+U=;
        b=oIkriUljKjqLocUZnoyyLStulI4y3yZlOXoqh7u/8UMsXZXjN4eSsQNz7b8OUV9NVjOLNF
        3Pzk/Jai7Mpr81kZk9KBFZkNPj0LMA6emms7WS7G0bbT56dgsAcux0NTv/h1Nn9qWF3OWy
        rckAKg4W3RRA+7BKtOTRgLbz1yhLM6A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1680111849;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GFXQBOEPVDp2/JHFNcJ9r/5PGOJeCWVJg18VPhpSW+U=;
        b=R9EVDbnFyM19JG6tUKu121B1CCze2bTcJu7lPfVjPrJC/L0FqNGe4NmFy3Iuib+5zsC4o0
        PJTkbW1DOkFHq4Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 13AC6139D3;
        Wed, 29 Mar 2023 17:44:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id D0z1A+l4JGRzHAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 29 Mar 2023 17:44:09 +0000
Date:   Wed, 29 Mar 2023 19:37:54 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: restore the thread_pool= behavior in remount for
 the end I/O workqueues
Message-ID: <20230329173754.GR10580@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20230328035613.1077697-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328035613.1077697-1-hch@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 28, 2023 at 12:56:13PM +0900, Christoph Hellwig wrote:
> Commit d7b9416fe5c5 ("btrfs: remove btrfs_end_io_wq") converted the read
> and I/O handling from btrfs_workqueues to Linux workqueues, and as part
> of that lost the code to apply the thread_pool= based max_active limit
> on remount.  Restore it.
> 
> Fixes: d7b9416fe5c5 ("btrfs: remove btrfs_end_io_wq")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Added to misc-next, thanks.
