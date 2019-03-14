Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63AFFC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 22:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD8F92184C
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 22:37:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=urbackup.org header.i=@urbackup.org header.b="CqYTWWns";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="LkxYKRHa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbfCNWh5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 18:37:57 -0400
Received: from a4-2.smtp-out.eu-west-1.amazonses.com ([54.240.4.2]:60002 "EHLO
        a4-2.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728410AbfCNWhz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 18:37:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=vbsgq4olmwpaxkmtpgfbbmccllr2wq3g; d=urbackup.org; t=1552603073;
        h=Subject:References:To:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=y6EDsbRBpwJhN7PN2KLU/6Wdmu+tJThu76J8+3+ve+I=;
        b=CqYTWWnsLL7p1dEGP/KfPYKWDw8tHZ89wiu0lIrUCYQgtN9SQGqgnA/eGbaFlgXx
        2cQx8TC1doxwaX/kmzvgR4eVqW3Y0PxAOa69EQzFTamNEgYk44Ky6e8DrKQKkP+ui+M
        rEGoUER1LxhxqNCqVBLK6L2lGzqeOF67xW2gqtgI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=ihchhvubuqgjsxyuhssfvqohv7z3u4hn; d=amazonses.com; t=1552603073;
        h=Subject:References:To:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=y6EDsbRBpwJhN7PN2KLU/6Wdmu+tJThu76J8+3+ve+I=;
        b=LkxYKRHar0DtiGyJsmozjTxTC7b5rbmodLiXk4cfPMnTu+mDCmFgzyXqTYLbiQpU
        7D4B7jtVlx/QWhjqetsmJCUEaIQz0jBpV7HgE5/Qy3O3zeOc2EyWA8U52DvY25V6cQe
        pFqC3s7JDM0WA1NUmkzyIh4YJP3xmfBiCcdjMv0E=
Subject: Re: psa, wiki needs updating now that Btrfs supports swapfiles in 5.0
References: <CAJCQCtQYezBhv0FvCineu9eTGs9gisyispwDD4wEe-CURVoTCg@mail.gmail.com>
To:     linux-btrfs@vger.kernel.org
From:   Martin Raiber <martin@urbackup.org>
Message-ID: <010201697e5acc16-2345a495-0bdc-45d4-8363-d4397d9a7841-000000@eu-west-1.amazonses.com>
Date:   Thu, 14 Mar 2019 22:37:53 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQYezBhv0FvCineu9eTGs9gisyispwDD4wEe-CURVoTCg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-SES-Outgoing: 2019.03.14-54.240.4.2
Feedback-ID: 1.eu-west-1.zKMZH6MF2g3oUhhjaE2f3oQ8IBjABPbvixQzV8APwT0=:AmazonSES
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 14.03.2019 23:20 Chris Murphy wrote:
> If you install btrfs-progs 4.20+ you'll see the documentation for
> supporting swapfiles on Btrfs, supported in kernel 5.0+. `man 5 btrfs`
>
> Anyone with access to the wiki should update the FAQ
> https://btrfs.wiki.kernel.org/index.php/FAQ#Does_btrfs_support_swap_files.3F

Yeah, and remove that tip about swap file via loop device. That will
only cause memory allocation lock-ups and is not advisable.

