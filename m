Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5E1C3DA66
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Aug 2023 17:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237406AbjHWRYw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Aug 2023 13:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbjHWRYv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2023 13:24:51 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF91E67
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2023 10:24:50 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D658C209A7;
        Wed, 23 Aug 2023 17:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1692811488;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wkK+AcmygB8MA0yAppd0FNvo5p/oo/c14TgKRi35Uw4=;
        b=m370vg0EQz+9AKofYRfq2Y1b5tdvK0XV0yij5siuuOB9yVzSWcHCAerx+RaGJL6IrAaHA0
        qSG2ZRPLaTFBDM5ZIAe/do0lPwv/wkDusriG3e/7nqzlZEDct0oDc8te7qi05zQikUrrdW
        qj2kIXh02OrPbbkIXHHRDYu6OYKXSZU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1692811488;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wkK+AcmygB8MA0yAppd0FNvo5p/oo/c14TgKRi35Uw4=;
        b=5D/2Hq0pAHpNuJqf1pB0jueThWYEXJl8NVOe2WxTd3xCycp/xx1UQ4V8xQ6gFFYJ3OxicZ
        dy3a1Gf7rMHnvEBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BA4321351F;
        Wed, 23 Aug 2023 17:24:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id npjBLOBA5mRUXQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 23 Aug 2023 17:24:48 +0000
Date:   Wed, 23 Aug 2023 19:18:16 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/3] btrfs-progs: a couple fixes
Message-ID: <20230823171816.GH2420@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1692800798.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1692800798.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Aug 23, 2023 at 10:27:47AM -0400, Josef Bacik wrote:
> Hello,
> 
> These are a set of fixes that I needed for the ctree sync to work properly, and
> one fix that was just broken in general.  They apply cleanly to devel and should
> be straightforward enough.  Thanks,
> 
> Josef
> 
> Josef Bacik (3):
>   btrfs-progs: take a ref in the root locking code
>   btrfs-progs: clear root dirty when we update the root
>   btrfs-progs: fix improper error handling in btrfs filesystem usage

Added to devel, thanks.
