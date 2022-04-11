Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA337C433FE
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Apr 2022 14:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346910AbiDKOHC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 10:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346914AbiDKOHA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Apr 2022 10:07:00 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA983299B;
        Mon, 11 Apr 2022 07:04:44 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 3A513210F4;
        Mon, 11 Apr 2022 14:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1649685883;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mabhyMUHoOtwjOm0+3v+wDSJt7vVsJDccsK4CpT9dlY=;
        b=GPgjX9c0ohP3PVlSqdv9BoZDTTPnECG5aQBk4El5f2Dj7k6ZfJQwnXbbE4TF+BckM6ZU15
        90c41ZEHxjr3YMvpb/hOqAi4cs0FSxau6yl75maJUABAIbuee8+1tZOLTzfTSnF3/4vA5N
        mkNpGdDnCrGmbAJlIC0Fe3AlC8Pmiaw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1649685883;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mabhyMUHoOtwjOm0+3v+wDSJt7vVsJDccsK4CpT9dlY=;
        b=hen0VLae0O/WS/EOG1IkKyGEGxgQhP4nmnXMxfKyJskvGQli5tvYjLfMERAm5f4rTWh8LT
        CkQClfix2bdbl2BA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id EE6A9A3B87;
        Mon, 11 Apr 2022 14:04:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9CDE2DA7DA; Mon, 11 Apr 2022 16:00:38 +0200 (CEST)
Date:   Mon, 11 Apr 2022 16:00:38 +0200
From:   David Sterba <dsterba@suse.cz>
To:     cgel.zte@gmail.com
Cc:     dsterba@suse.com, clm@fb.com, josef@toxicpanda.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] btrfs: remove unnecessary conditional
Message-ID: <20220411140038.GI15609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, cgel.zte@gmail.com, dsterba@suse.com,
        clm@fb.com, josef@toxicpanda.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <20220411032252.2517399-1-lv.ruyi@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411032252.2517399-1-lv.ruyi@zte.com.cn>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 11, 2022 at 03:22:52AM +0000, cgel.zte@gmail.com wrote:
> From: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> iput() has already handled null and non-null parameter, so it is no
> need to use if().
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>

Thanks, I've applied this version.
