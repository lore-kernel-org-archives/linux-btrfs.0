Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5FA1C433FE
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Nov 2022 15:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234398AbiKKPOl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Nov 2022 10:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234956AbiKKPOO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Nov 2022 10:14:14 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B3F79D18
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Nov 2022 07:12:33 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B795F21D24;
        Fri, 11 Nov 2022 15:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1668179552;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8Yxb4SANa01O6WR1QXKBFYtpAy62mai1GHPwBHGfkTQ=;
        b=zl0OjUoak9XOlq2JaF5jmQmRp3KbV/HABRCoDSvh8sQNclKuemY20M9/fUXt2HFPAAQ2+R
        Hg4s7LDBIc0r8dGdDPdwoZrWL01dZEtwV8mLgCP9hIN9U6K3nxPeWrPtMSL8CH92QlCYn3
        /RVviY9wAIo1KyRfkrGhnFw8P1ggZns=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1668179552;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8Yxb4SANa01O6WR1QXKBFYtpAy62mai1GHPwBHGfkTQ=;
        b=IXNJ1v1FhE4LqDAxxMnszaREFrbhAaHtxKDGEvK2R8Cc0/NOspBf4rxb7V9D41ZB+RKrya
        dTyGFQE7CXUBWpCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9EA7D13357;
        Fri, 11 Nov 2022 15:12:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4Jz3JWBmbmP9KQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Fri, 11 Nov 2022 15:12:32 +0000
Date:   Fri, 11 Nov 2022 16:12:09 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] btrfs: drop path before copying to userspace
Message-ID: <20221111151208.GO5824@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1668056532.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1668056532.git.anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 10, 2022 at 11:36:27AM +0530, Anand Jain wrote:
> In the ioctl functions below, we are holing ref to the path when copying
> the temp buffer to the userland. Which can lead to a similar lock splat
> warning as in the commit
>  [PATCH] btrfs: drop path before copying root refs to userspace
> 
>  btrfs_ioctl_logical_to_ino
>  btrfs_ioctl_ino_to_path
>  btrfs_ioctl_get_subvol_rootref
>  btrfs_ioctl_get_subvol_info
> 
> Fix this by freeing the path before we copy it to userspace.
> 
> Individual patch 4/4 is also in the ML and is different from here: Check
> the value of ret to copy got dropped to keep it closer to the original
> logic. However, its version is unchanged to match the rest of the patch
> version.
> 
> Anand Jain (4):
>   btrfs: drop path before copying inodes to userspace
>   btrfs: drop path before copying fspath to userspace
>   btrfs: drop path before copying rootrefs to userspace
>   btrfs: drop path before copying subvol info to userspace

Patch 3 dropped as it was sent by Josef. The rest added to misc-next,
thanks.
