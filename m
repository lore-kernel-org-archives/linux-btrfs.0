Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 279CEC433F5
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Feb 2022 18:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbiBXSqx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 13:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiBXSqw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Feb 2022 13:46:52 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2029F26F4E6;
        Thu, 24 Feb 2022 10:46:22 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B76511F44D;
        Thu, 24 Feb 2022 18:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1645728380;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jo3de60gyBESI2ouGzZS5RL2JSlQhCdM8gXY4xMzBOs=;
        b=kNOLvc70HXVRxRopsApEBXGIU902arqlZjYvOjdCRowTTOYPHnZPVZFEfAOGfOJB4xDSDW
        lyx9/a+TKlvABFHjqUor07olhBZjA1EKJV/nwmt/x0QDhLoel7yDwMHCFJ3BuhK8PvTSyq
        dSwSf2SYSJ1nYVboUE/Hv2QPwX8Wy/E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1645728380;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jo3de60gyBESI2ouGzZS5RL2JSlQhCdM8gXY4xMzBOs=;
        b=kTwanqTqSpurWusl15sqL7bJylD40Opo/bxXyzstRIUCuYXxghEqsOXyp0STv9HUOyPknC
        bxVpWkGusyJPgVAw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id AD994A3B83;
        Thu, 24 Feb 2022 18:46:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BBEA2DA818; Thu, 24 Feb 2022 19:42:31 +0100 (CET)
Date:   Thu, 24 Feb 2022 19:42:31 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     dsterba@suse.cz, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4] btrfs: add fs state details to error messages.
Message-ID: <20220224184231.GZ12643@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
References: <a059920460fe13f773fd9a2e870ceb9a8e3a105a.1645644489.git.sweettea-kernel@dorminy.me>
 <20220224132210.GS12643@twin.jikos.cz>
 <284ccc08-8de7-9188-19d8-20f4eda56cb4@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <284ccc08-8de7-9188-19d8-20f4eda56cb4@dorminy.me>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 24, 2022 at 11:10:59AM -0500, Sweet Tea Dorminy wrote:
> Awesome, thank you. I realized this morning that it might be technically 
> slightly racy actually and would propose something like the following
> 
> static void btrfs_state_to_string(const struct btrfs_fs_info *info, char *buf)
> {
> 	unsigned int bit;
> +	unsigned long fs_state = READ_ONCE(info->fs_state);
> 	unsigned int states_printed = 0;
> 	char *curr = buf;
> 
> 	memcpy(curr, STATE_STRING_PREFACE, sizeof(STATE_STRING_PREFACE));
> 	curr += sizeof(STATE_STRING_PREFACE) - 1;
> 
> -	for_each_set_bit(bit, &info->fs_state, sizeof(info->fs_state)) {
> +	for_each_set_bit(bit, fs_state, sizeof(fs_state)) {
> 
> 
> All the other interactions with info->fs_state are test/set/clear_bit,
> which treat the argument as volatile and are therefore safe to do from
> multiple threads. Without the READ_ONCE (reading it as a volatile),
> the compiler or cpu could turn the reads of info->fs_state in
> for_each_set_bit() into writes of random stuff into info->fs_state,
> potentially clearing the state bits or filling them with garbage.

I'm not sure I'm missing something, but I find the above hard to
believe. Concurrent access to a variable from multiple threads may not
produce consistent results, but random writes should not happen when
we're just reading. The worst thing that could happen is a missing
status bit reported, which is not a problem.

> Even if this is right, it'd be rare, but it would be exceeding weird
> for a message to be logged listing an error and then future messages
> be logged without any such state, or with a random collection of
> garbage states.

How would that happen? The volatile keyword is only a compiler hint not
to do optimizations on the variable, what actually happens on the CPU
level depends if the instruction is locked or not, so different threads
may read different bits.
You seem to imply that once a variable is not used with volatile
semantics, even just for read, the result could lead to random writes
because it's otherwise undefined.
