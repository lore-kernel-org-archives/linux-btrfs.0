Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02F1FC4338F
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Jul 2021 02:05:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC2ED60F9D
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Jul 2021 02:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbhG1CEG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 22:04:06 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:47338 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbhG1CEG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jul 2021 22:04:06 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DFF5E22258;
        Wed, 28 Jul 2021 02:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627437843; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L+dw/aofJSb3QloWYKquDzLpKe1QWOhZPRkmSE2rp/Q=;
        b=XsPO4kYGUgEuaSjx2rAtxIrl7sk8nkAHx+VbTc1rqeC8dJvmhG4MAejF0sLwhHDgX1QnLy
        cXnuD1fN4V+BA9MDo8JfAtHuco07aY23Mxj2JNuZ+9vJo9addKzv8gyKMD5WsdBvba6kfG
        uPBKWdX2azsPmRiLhCzgo6Yx1fNn7kg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627437843;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L+dw/aofJSb3QloWYKquDzLpKe1QWOhZPRkmSE2rp/Q=;
        b=99DnYInNR1mhr9y5dsX+mES7C8Dl4tk/XJ39Dt21Q05gfvHDbqeAjZAVbdqzBDQyU7ur/x
        eR8NgUE7l6dnK7Cw==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 7967C132AB;
        Wed, 28 Jul 2021 02:04:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id 2kSPERO7AGG0MwAAGKfGzw
        (envelope-from <rgoldwyn@suse.de>); Wed, 28 Jul 2021 02:04:03 +0000
Date:   Tue, 27 Jul 2021 21:04:01 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/7] btrfs: Allocate btrfs_ioctl_balance_args on stack
Message-ID: <20210728020401.tvn6uk6443niesy6@fiona>
References: <cover.1627418762.git.rgoldwyn@suse.com>
 <320216bed8e0c28e9235571db1962cbb1e18366a.1627418762.git.rgoldwyn@suse.com>
 <20210728000206.GA1241197@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728000206.GA1241197@magnolia>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 17:02 27/07, Darrick J. Wong wrote:
> On Tue, Jul 27, 2021 at 04:17:28PM -0500, Goldwyn Rodrigues wrote:
> > From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > 
> > Instead of using kmalloc() to allocate btrfs_ioctl_balance_args, allocate
> > btrfs_ioctl_balance_args on stack.
> > 
> > sizeof(btrfs_ioctl_balance_args) = 1024
> 
> That's a pretty big addition to the stack frame.  Aren't some of the
> kbuild robots configured to whinge about functions that eat more than
> 1100 bytes or so?

Apparently you are faster than the bot to detect this ;)
I got the warning mail from the kbuild bot and the limit is 1024, so it
would not fit in the frame. We can reject this patch.


-- 
Goldwyn
