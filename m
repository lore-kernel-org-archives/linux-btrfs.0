Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB44AC001DC
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Jul 2023 18:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbjGMS4f (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 14:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbjGMS4e (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2023 14:56:34 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F3C106
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jul 2023 11:56:34 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B62151FD5F;
        Thu, 13 Jul 2023 18:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1689274592;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=giAGFD8GcJKZ5AL9JKYvGzlsYVQlUIJiA5PLPT4uEu8=;
        b=vyZdWLMqxKYSFOerXsIXoB6lDEPfzuAZdxku/zzmXdvIJ2BQc/w5ECqFS9TKDB8q5MVnQu
        8lbofLUKfzl4GlVSfiL2FOdSVtqV66Ld8MEz9q+MqyipeSyc64V2K1q/UANukhFiCrqGsr
        usXAwwCsdvRighRwCe2i33RKEPbH/u0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1689274592;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=giAGFD8GcJKZ5AL9JKYvGzlsYVQlUIJiA5PLPT4uEu8=;
        b=S2jiDSX+fWuLMgzwGm8beADv6iQ3/dxxVG1aFmDROQ7VBLhdeBLPNCc0YDONvwlTAyQ6fo
        iWK7jPaH2vRCQTBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9EEF8133D6;
        Thu, 13 Jul 2023 18:56:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jkz0JeBIsGTKBgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Thu, 13 Jul 2023 18:56:32 +0000
Date:   Thu, 13 Jul 2023 20:49:56 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 05/11] btrfs-progs: tune: check for missing device
Message-ID: <20230713184956.GD30916@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1688724045.git.anand.jain@oracle.com>
 <3b6a812b25429342811a22687245c9732a715a8f.1688724045.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b6a812b25429342811a22687245c9732a715a8f.1688724045.git.anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jul 07, 2023 at 11:52:35PM +0800, Anand Jain wrote:
> If btrfstune is executed on a filesystem that contains a missing device,
> the command will now fail.
> 
> It is ok fail when any of the options supported by btrfstune are used.

Why? btrfstune has options that only change the superblock, like
feature enable/disable -e, -r, -x and -S. A missing device could be
problem for others but it should be checked only when it's relevant.
