Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CDFAC433EF
	for <linux-btrfs@archiver.kernel.org>; Fri, 27 May 2022 14:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345952AbiE0ON5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 27 May 2022 10:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236884AbiE0ON4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 May 2022 10:13:56 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC8B5537E
        for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2022 07:13:55 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2F06D21A49;
        Fri, 27 May 2022 14:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1653660834;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LMZo2SZrp4JayecRXYADJOn6mTJtuxOI17GTcz3ftO0=;
        b=K3yU5FFk0Tn1DN2GpCyBtnKSZnNc62WSh9MO+WrAg7VPj9k35ckVX37bw1ICOQw0HbE/vn
        vlHbCwqe4lII0MDsubpPXXi/wT/ynQ+97nJT6HOjdST9Mo/69YIlpn3qvBLK7QLPfj9Jq0
        EyLHXMw+Z4M7ZTEDCYEkNKGJaag5jUg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1653660834;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LMZo2SZrp4JayecRXYADJOn6mTJtuxOI17GTcz3ftO0=;
        b=CbSJUUmw9nRF3AVwKM4LfvsHNXDHPQcYJMOUZ1QlFchzYQ6BPRl+Vx6pnAHz3HcjKUB6sW
        WaJ9av7OWeHUoxAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 13E84139C4;
        Fri, 27 May 2022 14:13:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nY20A6LckGKPWwAAMHmgww
        (envelope-from <dsterba@suse.cz>); Fri, 27 May 2022 14:13:54 +0000
Date:   Fri, 27 May 2022 16:09:30 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: use integrated bitmaps for
 btrfs_raid_bio::dbitmap and finish_pbitmap
Message-ID: <20220527140930.GD20633@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1653636443.git.wqu@suse.com>
 <354833cdd0b94908fc5a6064d2dee63f8ba0c175.1653636443.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <354833cdd0b94908fc5a6064d2dee63f8ba0c175.1653636443.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, May 27, 2022 at 03:28:17PM +0800, Qu Wenruo wrote:
> Previsouly we use "unsigned long *" for those two bitmaps.
> 
> But since we only support fixed stripe length (64KiB, already checked in
> tree-checker), "unsigned long *" is really a waste of memory, while we
> can just use "unsigned long".
> 
> This saves us 8 bytes in total for btrfs_raid_bio.

Nice, also the indirection of pointers and kmalloc, for 8 bytes it's an
overkill. If we ever implement bigger stripe size then it would have to
be reverted but the asserts make sure we'll notice.
