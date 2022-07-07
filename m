Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D81AC433EF
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Jul 2022 18:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236540AbiGGSvR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 14:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236303AbiGGSvQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2022 14:51:16 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C35524BC6
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Jul 2022 11:51:15 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1F8F81FDB8;
        Thu,  7 Jul 2022 18:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1657219874;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bpUGDZU6M9w4XNDgtbzPNtC6nlBAKeu18igcO1Dw4Jc=;
        b=wK5AjOtqpQ1fAS8vCcBoIbzck8wTn1RN/x9I7pZ+kp+DUmcejucY9qeQE5/VlpC9lb1CmO
        8LYWeLliILiz3I71TSYfPXNBMUjm5wCPCFE1Lag3j2de7uMlxbb85yhOusbTonEekr6CDz
        Hhdi127S0WxaKCYEjo64aRmXUWzsnP4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1657219874;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bpUGDZU6M9w4XNDgtbzPNtC6nlBAKeu18igcO1Dw4Jc=;
        b=XMvgFxF0BKH1N8ZYeAlE9qucn1z+aHo9WJ3rb1QjCq5Jr7yxxc1v9EvTsSJByZAYJuu+69
        TPHw4avfrb/oSgDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EDA3913A33;
        Thu,  7 Jul 2022 18:51:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6afkOCErx2LMGgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Thu, 07 Jul 2022 18:51:13 +0000
Date:   Thu, 7 Jul 2022 20:46:27 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Antonio =?iso-8859-1?Q?P=E9rez?= <aperez@skarcha.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: switch btrfs_block_rsv::full to bool
Message-ID: <20220707184627.GN15169@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Antonio =?iso-8859-1?Q?P=E9rez?= <aperez@skarcha.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1656079178.git.dsterba@suse.com>
 <845f7ad07062c689f23d2c6346dfc5f74fe9d92d.1656079178.git.dsterba@suse.com>
 <80428a51-4e0c-f109-d469-c6dc3da2ac7f@skarcha.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <80428a51-4e0c-f109-d469-c6dc3da2ac7f@skarcha.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jun 24, 2022 at 07:12:09PM +0200, Antonio Pérez wrote:
> Hi!
> 
> El 24/6/22 a las 16:01, David Sterba escribió:
> 
> > @@ -175,7 +175,7 @@ void btrfs_migrate_to_delayed_refs_rsv(struct btrfs_fs_info *fs_info,
> >   	if (num_bytes)
> >   		delayed_refs_rsv->reserved += num_bytes;
> >   	if (delayed_refs_rsv->reserved >= delayed_refs_rsv->size)
> > -		delayed_refs_rsv->full = 1;
> > +		delayed_refs_rsv->full = false;
> 
> Should it be 'true'?

Yes of course, thanks
