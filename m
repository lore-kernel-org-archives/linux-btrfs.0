Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 078F8C12002
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Jul 2021 16:25:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E136661242
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Jul 2021 16:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbhGUPpJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Jul 2021 11:45:09 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:44792 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbhGUPol (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jul 2021 11:44:41 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B3E7F1FEB7;
        Wed, 21 Jul 2021 16:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1626884716;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lrRaQsmevmM61FaN4ROq/OQyOeuB2KssIUY5Mr5XHJk=;
        b=ChDLEUXE/MFvQOo1JMabhGyh0gcguGI/9GjBUNgMi/tK6fxQ78LIMvvS6X67vDXHQtdZXX
        dd+8zzSIjnFHfdHZy/v5x3hOBz6xNAiPVQ9FRCBgGy2V4Zl4d6cVi58RM/Tf5Y2TW0GooO
        Vdv172RkDg4juOOQIvOnp9L+YkLLnlg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1626884716;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lrRaQsmevmM61FaN4ROq/OQyOeuB2KssIUY5Mr5XHJk=;
        b=krJFhTwxlrWhgP7uTcjHEZccle2eDVpiJUA8oHmrcrIQqW4WPKal6LSFoJNwBnoEUS1Jn0
        XXu7//4/DjgjHEDg==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id AC90BA3B93;
        Wed, 21 Jul 2021 16:25:16 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 890ADDA704; Wed, 21 Jul 2021 18:22:35 +0200 (CEST)
Date:   Wed, 21 Jul 2021 18:22:35 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Marcos Paulo de Souza <mpdesouza@suse.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH] btrfs: Use NULL in btrfs_search_slot as trans if we only
 want to search
Message-ID: <20210721162235.GK19710@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.com
References: <20210720180247.16802-1-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720180247.16802-1-mpdesouza@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jul 20, 2021 at 03:02:47PM -0300, Marcos Paulo de Souza wrote:
> Using a transaction in btrfs_search_slot is only useful when if are
> searching to add or modify the tree. When the function is only used for
> searching, insert length and mod arguments are 0, there is no need to
> use a transaction.
> 
> No functional changes, changing for consistency.
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>

Added to misc-next, thanks.
