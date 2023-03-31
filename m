Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A41C761A6
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 Mar 2023 17:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbjCaRb5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 31 Mar 2023 13:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbjCaRby (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2023 13:31:54 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72AA3AB9;
        Fri, 31 Mar 2023 10:31:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5CCFF21AC0;
        Fri, 31 Mar 2023 17:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1680283911;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8HVcYQ1lSsLr0GGFaE6/gSgA/f1Cg/CbSrd2aXGyFRA=;
        b=Ow3RWOlzRUBW8wpoNPTzbrksZDXeObeFutiyKa61eSyCNTORcP19dQ5lrR2RihL5DMkd74
        dAMq0btppv6NADshsmtDxHlMX+OvtghonwIMIRKf392Vc5WT9a9bc2BBCLerwazmIBCW8j
        hwPqGF2X6m+F85ySt16qtmkhVhJK0jM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1680283911;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8HVcYQ1lSsLr0GGFaE6/gSgA/f1Cg/CbSrd2aXGyFRA=;
        b=82hiKoK+DdfxxJKLniClLSsiWpAoAys8G8yDDzVcJ2WorrPaC1AIl3h3Xl0YsV0ez53bEn
        2RTkg7CB4mvF8yBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 175C0133B6;
        Fri, 31 Mar 2023 17:31:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id scuNBAcZJ2RRQwAAMHmgww
        (envelope-from <dsterba@suse.cz>); Fri, 31 Mar 2023 17:31:51 +0000
Date:   Fri, 31 Mar 2023 19:25:35 +0200
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.cz>
Cc:     Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@toxicpanda.com>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        cgroups@vger.kernel.org, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: move bio cgroup punting into btrfs
Message-ID: <20230331172535.GX10580@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20230327004954.728797-1-hch@lst.de>
 <20230327231837.GK10580@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327231837.GK10580@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 28, 2023 at 01:18:37AM +0200, David Sterba wrote:
> On Mon, Mar 27, 2023 at 09:49:46AM +0900, Christoph Hellwig wrote:
> > Hi all,
> > 
> > the current code to offload bio submission into a cgroup-specific helper
> > thread when sent from the btrfs internal helper threads is a bit ugly.
> > 
> > This series moves it into btrfs with minimal interference in the core
> > code.
> 
> I can't speak for the cgroup side, but as btrfs is the only user of the
> REQ_CGROUP_PUNT flag pushing it down to the IO submission path makes
> sense. Code looks ok, it's a direct conversion.
> 
> When the mm/block changes get an Ack I can put it to btrfs for-next.

Patchset added to for-next.
