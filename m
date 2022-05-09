Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 690E6C433EF
	for <linux-btrfs@archiver.kernel.org>; Mon,  9 May 2022 19:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240494AbiEITTH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 9 May 2022 15:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240486AbiEITTH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 May 2022 15:19:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9ED76E8C8
        for <linux-btrfs@vger.kernel.org>; Mon,  9 May 2022 12:15:12 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9A3F91F38C;
        Mon,  9 May 2022 19:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652123711;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KBbCjzoeMZCQE8ny0WBKd4/uwN/sAn63/sGXPByFnQg=;
        b=lIfK4B41qVKh7khfap+n/28hV58EZVzHwgIHCwVdR2Z/1frJsY1UOxwXqOkxBjdLLS2ycA
        0eZWp9lPmoK3kLesUAZhONYAdyZdNHkbc+kjqjiWRlcsi2hUOOpGllAQecylQ3QIUeysy6
        8ph/B0yxUtmOx1AMtsXVAryY8oxi6so=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652123711;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KBbCjzoeMZCQE8ny0WBKd4/uwN/sAn63/sGXPByFnQg=;
        b=zW+U2X+ni4NhhGsE6bwD3u/GeRSz43HU9kUme1HpXJpRPaccZc7Gmy8CC+LqwRkCzMqCSB
        Ch56F2U3mKP8NkBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7FDFB132C0;
        Mon,  9 May 2022 19:15:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id iDFgHj9oeWLFeAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 09 May 2022 19:15:11 +0000
Date:   Mon, 9 May 2022 21:10:57 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: zoned: fix comparison of alloc_offset vs
 meta_write_pointer
Message-ID: <20220509191057.GE18596@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org
References: <72f5f60036d5f9a3b096365f5c72cc1ad8db588b.1651705923.git.naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72f5f60036d5f9a3b096365f5c72cc1ad8db588b.1651705923.git.naohiro.aota@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, May 04, 2022 at 04:12:48PM -0700, Naohiro Aota wrote:
> The block_group->alloc_offset is an offset from the start of the block
> group. OTOH, the ->meta_write_pointer is an address in the logical
> space. So, we should compare the alloc_offset shifted with the
> block_group->start.
> 
> Fixes: afba2bc036b0 ("btrfs: zoned: implement active zone tracking")
> CC: stable@vger.kernel.org # 5.16+
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>

Added to misc-next, thanks.
