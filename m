Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0486FC4332F
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Nov 2022 20:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiKUUoA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 15:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKUUn7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Nov 2022 15:43:59 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC8BD71
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Nov 2022 12:43:58 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 72F1221F0F;
        Mon, 21 Nov 2022 20:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1669063437;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=42pXPdOJNKAJpo+Rx1J4PPt8r99efinqZDd3OWwp/lw=;
        b=mIuWicWiCntSIGFX66gzLE3HoCJiguD7mkKk+ohiyouYUnl5IMDU2wXnwLTIQ2tc963doo
        zS3BCxoDeVzQC/i5StM8KpUa+fH0qsK3iPu5wjizF14t2uDjftdnQ4ywP7ia3fKFSna33k
        tg06lhJW06QO+lBbnoW/MhRl+bP6mrc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1669063437;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=42pXPdOJNKAJpo+Rx1J4PPt8r99efinqZDd3OWwp/lw=;
        b=QISsakgGoLrxZz7i+U8AMa4h+sZQUJJtkOj1FGpZttgbL5J95KhjWJiB0uYbyQ32aVN19I
        zIdAmmhJWoS7WJBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5409A1377F;
        Mon, 21 Nov 2022 20:43:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xUEsEw3je2MJXgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 21 Nov 2022 20:43:57 +0000
Date:   Mon, 21 Nov 2022 21:43:27 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Peter Cardoe <peter@cardoe.co.uk>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: root item with a more recent gen
Message-ID: <20221121204327.GD5824@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <119134c3dcaec15277b5850fc4ccb630.squirrel@mail.cardoe.co.uk>
 <16C8B1A2-2500-44C2-ABB4-DE65D37ED838@cardoe.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16C8B1A2-2500-44C2-ABB4-DE65D37ED838@cardoe.co.uk>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 16, 2022 at 10:54:54PM +0000, Peter Cardoe wrote:
> Should I be asking these questions on this mailing list or somewhere else, please?

You can ask in the mailing list, experienced users read it here and can
answer, developers usualy answer when they recognize the problem or if
it's a bug in area of their interest. For 'btrfs check' bugs or reports
you can also open an issue on github.com/kdave/btrfs-progs, but there's
not always a fix, random corruptions caused by faulty hardware could be
only detected.
