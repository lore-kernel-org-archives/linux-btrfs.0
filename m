Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51EABC43334
	for <linux-btrfs@archiver.kernel.org>; Wed,  1 Jun 2022 18:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiFASjy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 14:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiFASjx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jun 2022 14:39:53 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C285D02B6
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Jun 2022 11:39:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 993281F93D;
        Wed,  1 Jun 2022 18:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654108790;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Es3zyGodpgjMNRxefUDb+CJUb8RJSaK1PgwPpOuEPac=;
        b=XUZ5IdDYkHXltgwxBmoH10/yNwnzmon2zb42GvXDocMdDm0/+c2z0sOsoyIaidfxwqAiTi
        PQv4UQsBuut5Bn+OamEc+M+abNuzE6v4aOiE0TJV3qdPgd4XgzWB3SYlUJV5p74HnMKYdy
        VPOgqoSGWhomYASVSYzCeIfHmQawhj0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654108790;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Es3zyGodpgjMNRxefUDb+CJUb8RJSaK1PgwPpOuEPac=;
        b=w6uK0k34kOjL+3DuQmuThWyILf6tevhQLp9EDvANvK/eX2FFjdk3l2Nvi42JYb6lUEbRVB
        UiqqKsEsR04iMxCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 77A5113A8F;
        Wed,  1 Jun 2022 18:39:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LzN2G3ayl2KJAgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 01 Jun 2022 18:39:50 +0000
Date:   Wed, 1 Jun 2022 20:35:24 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/12] btrfs: some improvements and cleanups around
 delayed items
Message-ID: <20220601183524.GP20633@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <cover.1654009356.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1654009356.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, May 31, 2022 at 04:06:31PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> This series does some cleanups and performance improvements related to
> delayed items. These are also preparation work for some other changes
> coming in the near future.

Added to misc-next, thanks.
