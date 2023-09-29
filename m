Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DEC2E71D3D
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Sep 2023 14:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbjI2OmJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Sep 2023 10:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbjI2OmF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2023 10:42:05 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4581A8
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Sep 2023 07:42:03 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1AA931F45E;
        Fri, 29 Sep 2023 14:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1695998522;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UeL5IHsBCH4d1qYUT0vyvhXtH8TnvXWmCLGRhWorH3s=;
        b=0Q/0T330FCMuBsVwLocwn6bmmswt9zFoSWT4Mfla8015H/jsEUu7lYIIwoBD8PHtGkHl6O
        SUOIcmF8YnAkSXca37wIx4e9G1o/b759TkRpNhSnipWFt64YZ8BeueUICpVDrOhPHuKuAi
        FEldqJ59cuwRj61H9QEBJY6ALvcNRnM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1695998522;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UeL5IHsBCH4d1qYUT0vyvhXtH8TnvXWmCLGRhWorH3s=;
        b=7YciCTfzhVWwgrVJ07ZIIpMIGZBNe2bWE5cpHVJhwt3Vnfj3IP7zRtptS1O8RKjIoZycpi
        9Lgg9GYJVmr6/3Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 02D571390A;
        Fri, 29 Sep 2023 14:42:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TFmDOzniFmUSIwAAMHmgww
        (envelope-from <dsterba@suse.cz>); Fri, 29 Sep 2023 14:42:01 +0000
Date:   Fri, 29 Sep 2023 16:35:22 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 8/8] btrfs: move btrfs_realloc_node() from ctree.c
 into defrag.c
Message-ID: <20230929143522.GF13697@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1695812791.git.fdmanana@suse.com>
 <72d4a7745616671bb920f33aaead10cca69138d1.1695812791.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72d4a7745616671bb920f33aaead10cca69138d1.1695812791.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 27, 2023 at 12:09:28PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> btrfs_realloc_node() is only used by the defrag code. Nowadays we have a
> defrag.c file, so move it, and its helper close_blocks(), into defrag.c.
> 
> During the move also do a few minor cosmetic changes:
> 
> 1) Change the return value of close_blocks() from int to bool;
> 
> 2) Use SZ_32K instead of 32768 at close_blocks();
> 
> 3) Make some variables const in btrfs_realloc_node(), 'blocksize' and
>    'end_slot';
> 
> 4) Get rid of 'parent_nritems' variable, in both places where it was
>    used it could be replaced by calling btrfs_header_nritems(parent);
> 
> 5) Change the type of a couple variables from int to bool;
> 
> 6) Rename variable 'err' to 'ret', as that's the most common name we
>    use to track the return value of a function;
> 
> 7) Move some variables from the top scope to the scope of the for loop
>    where they are used.

Changes like that are prefectly fine when moving code, thanks.
