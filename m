Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E13CC636D3
	for <linux-btrfs@archiver.kernel.org>; Thu,  9 Feb 2023 20:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjBIUDD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 15:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBIUDC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Feb 2023 15:03:02 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA23234C32
        for <linux-btrfs@vger.kernel.org>; Thu,  9 Feb 2023 12:03:00 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 18D205D63F;
        Thu,  9 Feb 2023 20:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1675972979;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0LGG383PVYUHsnSis1Xh62kN7vj7PSR+xlYADAYAsps=;
        b=0hf0zN43E9tAj/7i7f1qyNOpt7H0koIj1sCZ7IeuV6/0giLUOnMI0fvVwCBZtgls9cAxFV
        /k0iIoqiofxglpZnJ9U0Hds22n2tqs6vyCcrtPft5V8kXnJALWbOqVY9OtxwnPt2SY4j6P
        kehxNVXifBLR1cfQn5FpM/dnvIocORU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1675972979;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0LGG383PVYUHsnSis1Xh62kN7vj7PSR+xlYADAYAsps=;
        b=K5GUDrWbNC5ewWRlY1BktFJMOLMN5oEJlJ03cqOMJnDWHC0NtiC4enfVwKccdv7H0ojJo8
        MijyCsXd6YwlCJCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F1BEA1339E;
        Thu,  9 Feb 2023 20:02:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id z1YtOnJR5WMqQgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Thu, 09 Feb 2023 20:02:58 +0000
Date:   Thu, 9 Feb 2023 20:57:09 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs: some minor tweaks to the extent buffer binary
 search
Message-ID: <20230209195709.GP28288@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1675877903.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1675877903.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 08, 2023 at 05:46:47PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Add a couple minor tweaks to the binary search function. These were
> originally part of a larger patchset I'm working on, but since these
> are trivial and independent from the test, I'm sending them out
> separately. More details on the change logs.
> 
> Filipe Manana (2):
>   btrfs: eliminate extra call when doing binary search on extent buffer
>   btrfs: do unsigned integer division in the extent buffer binary search loop

Added to misc-next, thanks.
