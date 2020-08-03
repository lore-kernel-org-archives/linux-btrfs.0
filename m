Return-Path: <SRS0=qeAP=BN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 955E0C433E0
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Aug 2020 05:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4236A2065C
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Aug 2020 05:51:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=preining.info header.i=@preining.info header.b="JBIjxdQa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgHCFvc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Aug 2020 01:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbgHCFvb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Aug 2020 01:51:31 -0400
X-Greylist: delayed 1473 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 02 Aug 2020 22:51:31 PDT
Received: from hz.preining.info (hz.preining.info [IPv6:2a01:4f9:2a:1a08::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DC1C06174A
        for <linux-btrfs@vger.kernel.org>; Sun,  2 Aug 2020 22:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=preining.info; s=201909; h=Content-Type:MIME-Version:Message-ID:Subject:To:
        From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9jkwB0sRU1V+zqBim+6WqxajLQVt9WMhBuyUjrWZ09Q=; b=JBIjxdQaVo6Z0d0o+r8xv+wiLi
        gmVylLkgzp2jbJMEuEnLlQYZgorZyoUM4t+/kyM5p6AjHY8YvE4zdPsuM3tKstUVMOiadS9Zw3tPF
        n0agkHeFuiuLz1sKZ5rAyE7vwjr401nrNSVNnRPn4gd73mEg114OJwLdMYob2IwlRxmNX9/WhYDa/
        Ntya4rcOqSbB2gDVkrAPbbSRFN/W1o/jITm11tJ7/20vvs6r9DaPEo/h0dR7UHF4l987Au4t0nxaS
        5PO+H2x420i0/1cvwBccAcZmcSgKMUIQStOUlFVTx2ITsyADVoTw3s25k/Sm8JK3rP1y/UHS+Lae5
        bKt8CnYg==;
Received: from tvk213002.tvk.ne.jp ([180.94.213.2] helo=bulldog.preining.info)
        by hz.preining.info with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <norbert@preining.info>)
        id 1k2Szv-0002Cn-0N
        for linux-btrfs@vger.kernel.org; Mon, 03 Aug 2020 05:26:55 +0000
Received: by bulldog.preining.info (Postfix, from userid 1000)
        id 454F1B9A5937; Mon,  3 Aug 2020 14:26:51 +0900 (JST)
Date:   Mon, 3 Aug 2020 14:26:51 +0900
From:   Norbert Preining <norbert@preining.info>
To:     linux-btrfs@vger.kernel.org
Subject: replacing a disk in a btrfs multi disk array with raid10
Message-ID: <20200803052651.GA685777@bulldog.preining.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi all

(please Cc)

I am running Linux 5.7 or 5.8 on a btrfs array of 7 disks, with metadata
and data both on raid1, which contains the complete system.
(btrfs balance start -dconvert=raid1 -mconvert=raid1 /)

Although btrfs device stats / doesn't show any errors, SMART warns about
one disk (reallocated sector count property) and I was pondering
replacing the device.

What is the currently suggested method given that I cannot plug in
another disk into the computer, all slots are used up (thus a btrfs
replace will not work as far as I understand).

Do I need to:
- shutdown
- pysically replace disk
- reboot into rescue system
- mount in degraded mode
- add the new device
- resize the file system (new disk would be bigger)
- start a new rebalancing
	(for the rebalance, do I need to give the
	same -dconvert=raid1 -mconvert=raid1 arguments?)

Thanks for any guidance (and please Cc)

All the best

Norbert

--
PREINING Norbert                              https://www.preining.info
Accelia Inc. + IFMGA ProGuide + TU Wien + JAIST + TeX Live + Debian Dev
GPG: 0x860CDC13   fp: F7D8 A928 26E3 16A1 9FA0 ACF0 6CAC A448 860C DC13
