Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16207C433F5
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Mar 2022 21:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbiCAVtv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 16:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiCAVtv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2022 16:49:51 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B01F29C80
        for <linux-btrfs@vger.kernel.org>; Tue,  1 Mar 2022 13:49:09 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 13F541F37E;
        Tue,  1 Mar 2022 21:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1646171348;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6brHGR9ikIFR3v2YtYIVm8zFSl/Q+jpQ/XPFHZd+xxU=;
        b=K7YhU30UQJvMqtVXrxzYFZslVWmwYDJLJru4fAJm2qIJJJpHNLcA2kykdI6Fyiz4ZczJKn
        ISxdmeJoksXfSnWamtNqEQ0fukSJTdDL6DtMAEPb0owxoR3W3Vjh1+gTHqkwkOZpHy0iZE
        uwY9TzbKOzp9yFeoRGEXH6Ui0BRPBDo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1646171348;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6brHGR9ikIFR3v2YtYIVm8zFSl/Q+jpQ/XPFHZd+xxU=;
        b=oQv74QXHEpdZCpPcT7JfgGb05zTUrlJE1Kgz94D5/OQSdMg37VJnKDtYo2Smfwv4sr0TJ+
        RtjjL0Q1fuJzb9AA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 0D5A7A3B81;
        Tue,  1 Mar 2022 21:49:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7B588DA80E; Tue,  1 Mar 2022 22:45:16 +0100 (CET)
Date:   Tue, 1 Mar 2022 22:45:16 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs: add parent-child ownership check
Message-ID: <20220301214516.GS12643@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1645515599.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1645515599.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 22, 2022 at 03:41:18PM +0800, Qu Wenruo wrote:
> Tree-checker doesn't really check owner except for empty leaf.
> 
> This allows parent-child ownership mismatch to sneak in.
> 
> Enhance the checks again tree block owner by:
> 
> - Add owner check when reading child tree blocks
> 
> - Make sure the tree root owner matches the root key
> 
> Unfortunately the check still has some cases missing, mostly for
> 
> - Log/reloc trees
>   Need full root key to check, which is not really possible for
>   some backref call sites.
> 
> 
> The first 2 patches are just cleanup to unify the error handling
> patterns, there are some "creative" way checking the errors, which is
> not really reader friendly.
> 
> The last patch is doing the real work.
> 
> Qu Wenruo (3):
>   btrfs: unify the error handling pattern for read_tree_block()
>   btrfs: unify the error handling of btrfs_read_buffer()
>   btrfs: check extent buffer owner against the owner rootid

Added to misc-next, thanks.
