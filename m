Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 962B2C47083
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jun 2021 11:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 802966136E
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jun 2021 11:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbhFDLPC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jun 2021 07:15:02 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:57082 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhFDLPC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jun 2021 07:15:02 -0400
Received: from relay2.suse.de (unknown [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 5EC0121A1E;
        Fri,  4 Jun 2021 11:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1622805195;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gXfvCAu3sYY859VntASafbAJmFqwsPr5vRZW+7ZR6uM=;
        b=b9tb/7tedLrrHlMjMNSNywq/gK+tAE+rvzW0UmnPOzDap17iEpbwnyLllBilgycD0G4VBh
        bL0oOLqy0xYfDDVTUYwgc697RIlDZFqd/IwcicbSHySMc5VtLj+ezS6znXcXQB66/EZTQu
        WeQp3YJ2ZOvPC9GmL4ceWjKCBvUzNm0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1622805195;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gXfvCAu3sYY859VntASafbAJmFqwsPr5vRZW+7ZR6uM=;
        b=8077n0Qw5U31kKJZBbbgKi49f2xIZ8MP0lXZqEhZ+1WqBzDJossunt1C8y+HS4yCYFNUWv
        bVYNunv8BATtqEBw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 2D932A3B85;
        Fri,  4 Jun 2021 11:13:15 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C0B73DB225; Fri,  4 Jun 2021 13:10:33 +0200 (CEST)
Date:   Fri, 4 Jun 2021 13:10:33 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs fixes for 5.13-rc5
Message-ID: <20210604111033.GA31483@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1622728563.git.dsterba@suse.com>
 <20210604011707.l6mvqn5z2yvm4j3z@naota-xeon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604011707.l6mvqn5z2yvm4j3z@naota-xeon>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jun 04, 2021 at 10:17:07AM +0900, Naohiro Aota wrote:
> Could you also add commit "btrfs: zoned: fix zone number to
> sector/physical calculation" for pull? Without this commit, on a
> device larger than 4 TB, zoned btrfs will overwrite the primary
> superblock with the 2nd copy and causes a mount failure after the
> first mount/umount.

Yeah, a few more fixes plus that one are in queue for the next pull.
