Return-Path: <SRS0=ZmOe=WQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 767A6C3A589
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Aug 2019 14:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 532E022DBF
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Aug 2019 14:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbfHTOcd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 10:32:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:51292 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729912AbfHTOcd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Aug 2019 10:32:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 34E93AE87;
        Tue, 20 Aug 2019 14:32:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7B5C8DA7DA; Tue, 20 Aug 2019 16:32:58 +0200 (CEST)
Date:   Tue, 20 Aug 2019 16:32:58 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Vladimir Panteleev <git@panteleev.md>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: balance: check for full-balance before
 background fork
Message-ID: <20190820143258.GS24086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Vladimir Panteleev <git@panteleev.md>,
        linux-btrfs@vger.kernel.org
References: <20190817231434.1034-1-git@vladimir.panteleev.md>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190817231434.1034-1-git@vladimir.panteleev.md>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Aug 17, 2019 at 11:14:34PM +0000, Vladimir Panteleev wrote:
> Move the full-balance warning to before the fork, so that the user can
> see and react to it.
> 
> Notes on test:
> 
> - Don't use grep -q, as it causes a SIGPIPE during the countdown, and
>   the balance thus doesn't start.
> 
> - The "balance cancel" is superfluous as the last command, but it
>   provides some idempotence and allows adding more tests below it.
> 
> Fixes: https://github.com/kdave/btrfs-progs/issues/168
> 
> Signed-off-by: Vladimir Panteleev <git@vladimir.panteleev.md>

Applied, thanks. The issues can be referenced as

Issue: #168

> --- a/tests/cli-tests/002-balance-full-no-filters/test.sh
> +++ b/tests/cli-tests/002-balance-full-no-filters/test.sh
> @@ -18,4 +18,9 @@ run_check $SUDO_HELPER "$TOP/btrfs" balance start "$TEST_MNT"
>  run_check $SUDO_HELPER "$TOP/btrfs" balance --full-balance "$TEST_MNT"
>  run_check $SUDO_HELPER "$TOP/btrfs" balance "$TEST_MNT"
>  
> +run_check_stdout $SUDO_HELPER "$TOP/btrfs" balance start --background "$TEST_MNT" |
> +	grep -F "Full balance without filters requested." ||

This needs -q, otherwise the text appears in the output of make. Fixed.
