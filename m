Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F022AC433FE
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Oct 2022 13:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiJNNa0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 14 Oct 2022 09:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiJNNaY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2022 09:30:24 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DCBE197D
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Oct 2022 06:30:19 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 97EF91F383;
        Fri, 14 Oct 2022 13:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1665754218;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jfSaVnDAtVzfD58GHXuX1KyH51H6hDk+CHi/n3IzwIA=;
        b=W5P/9AiE0nRX1KzVTjFRrzSeFx9ZOVgoSa96Eh7RBlnF5yJQ1KDE1LhJpQc+/AdSivam+H
        GDc6WiBml9sswpur4H167qiWXZM+wGft60apB83DIFQk/BQusrQfhdVgEBp8WqMv2TLSbW
        m/d9/NerpDZZyMQrIA93ZaVhC+eY8vA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1665754218;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jfSaVnDAtVzfD58GHXuX1KyH51H6hDk+CHi/n3IzwIA=;
        b=qRWv9tyQn2YSBSEr2NeGfBchKr7pjsbcdeqSPVGz5D3NuXK5GuumTrhdC+oTNjTRkqQwLZ
        b2qTwwGsafd1lYDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7A7B013451;
        Fri, 14 Oct 2022 13:30:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id XkP1HGpkSWPALQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Fri, 14 Oct 2022 13:30:18 +0000
Date:   Fri, 14 Oct 2022 15:30:11 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: remove gfp_t flag from
 btrfs_tree_mod_log_insert_key()
Message-ID: <20221014133011.GH13389@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1665656353.git.fdmanana@suse.com>
 <903be4beb2a83dcfaa278329c59f055f5a15c42e.1665656353.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <903be4beb2a83dcfaa278329c59f055f5a15c42e.1665656353.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 13, 2022 at 11:36:26AM +0100, fdmanana@kernel.org wrote:
>index 8a3a14686d3e..6606534fc36a 100644
> --- a/fs/btrfs/tree-mod-log.c
> +++ b/fs/btrfs/tree-mod-log.c
> @@ -220,7 +220,7 @@ static struct tree_mod_elem *alloc_tree_mod_elem(struct extent_buffer *eb,
>  }
>  
>  int btrfs_tree_mod_log_insert_key(struct extent_buffer *eb, int slot,
> -				  enum btrfs_mod_log_op op, gfp_t flags)
> +				  enum btrfs_mod_log_op op)
>  {
>  	struct tree_mod_elem *tm;
>  	int ret;
> @@ -228,7 +228,7 @@ int btrfs_tree_mod_log_insert_key(struct extent_buffer *eb, int slot,
>  	if (!tree_mod_need_log(eb->fs_info, eb))
>  		return 0;
>  
> -	tm = alloc_tree_mod_elem(eb, slot, op, flags);
> +	tm = alloc_tree_mod_elem(eb, slot, op, GFP_NOFS);

And after that alloc_tree_mod_elem is also called only with GFP_NOFS.

>  	if (!tm)
>  		return -ENOMEM;
>  
