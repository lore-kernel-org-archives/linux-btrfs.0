Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC730C433EF
	for <linux-btrfs@archiver.kernel.org>; Fri, 17 Jun 2022 15:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383044AbiFQPKj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 11:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382971AbiFQPKi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Jun 2022 11:10:38 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D780393EB
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jun 2022 08:10:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5CA2321B1A;
        Fri, 17 Jun 2022 15:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655478636;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MTHa9bFPJpt7dMpf52+WP6AacwvL6jx4PMHrQ8RZ8z8=;
        b=agOIPsGA/h6jOaEwnxf/N9ufsh9vgyKAhRpSUlIuWtYbEa81KXm2b/3Pcfeq42cnnuF0BI
        IA0G3GNru/dy6JfEnnVmAc5Fhb4n0azd3cfLJiAwocSP2Nc6OMd4C3v3+T1xKUT5+IWDRu
        3wXXuRzkUHdITbUqzbJWfQZ3UW6Cmvs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655478636;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MTHa9bFPJpt7dMpf52+WP6AacwvL6jx4PMHrQ8RZ8z8=;
        b=7JZzlPD4OG+Js19IPMcyCoEgjFJHLU66qUJeyAn04uw3mvuYxBXMKFxDxlZf0erZx64sKc
        w5ZjrF0o38RbvdAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 426FB1348E;
        Fri, 17 Jun 2022 15:10:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id PDY7D2yZrGJ3QQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Fri, 17 Jun 2022 15:10:36 +0000
Date:   Fri, 17 Jun 2022 17:06:01 +0200
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] Remove indirect iterators for inode references
Message-ID: <20220617150601.GN20633@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1654723641.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1654723641.git.dsterba@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jun 08, 2022 at 11:35:57PM +0200, David Sterba wrote:
> There's support for a generic iterator over inode references that is for
> example used to resolve inode number to all paths but there's only one
> such iterator implementation so it's not necessary, unless somebody has
> an idea for more such iterators. There is a similar pattern used for
> extent iterator utilizing the indirection, but I think we can remove it
> for the inode refs.
> 
> David Sterba (4):
>   btrfs: call inode_to_path directly and drop indirection
>   btrfs: simplify parameters of backref iterators
>   btrfs: sink iterator parameter to btrfs_ioctl_logical_to_ino
>   btrfs: remove unused typedefs get_extent_t and btrfs_work_func_t

Added to misc-next.
