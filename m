Return-Path: <SRS0=A/rP=OI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1BF6C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 16:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AE7720868
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 16:52:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=ime.usp.br header.i=@ime.usp.br header.b="E4dYg0Zk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AE7720868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ime.usp.br
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729790AbeK3D6w (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 22:58:52 -0500
Received: from iris.ime.usp.br ([143.107.45.5]:47802 "EHLO iris.ime.usp.br"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728562AbeK3D6w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 22:58:52 -0500
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Nov 2018 22:58:51 EST
Received: from mail-it1-f179.google.com (mail-it1-f179.google.com [209.85.166.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jeanfobe@iris.ime.usp.br)
        by iris.ime.usp.br (Postfix) with ESMTPSA id B4EC22900A09
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2018 14:43:55 -0200 (-02)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=ime.usp.br; s=mail;
        t=1543509836; bh=USESj1GtT++iAmH/XbRCNuuo2DrufL9mVIUKZKyHWkU=;
        h=From:Date:Subject:To:From;
        b=E4dYg0Zki/e/lsaeV+/Igh2e/wmYXSSagMe7QRRip/kaipm21tL8xjTVk3SlXMlCg
         olhjBna8jth9u0g8Ov67UTtxZpZn44zfPYMDNBM8xAMfeShnX5koz2mGd6b0lzOKtl
         SJ9Ekhndlo1c03zHxHhQ+gCXhgXJxSK8efp38XnM=
Received: by mail-it1-f179.google.com with SMTP id g85so4574106ita.3
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2018 08:43:55 -0800 (PST)
X-Gm-Message-State: AA+aEWa6G/c9vSvCzG3B6CokGFJHzUmZd9tJC2EaNl7EkbvVaqqL0+NX
        EJms55T6qz8ndua3Blzc6VcJYV24rYwGIfybIr8=
X-Google-Smtp-Source: AFSGD/WJ0a1I5zG++7QTmIoHqcPPfmu2Rw2uuBP6ipOxsVjXfoi2TO8qN47F56wdomScZzX1nW+GHX8FKwcPD4Q+IRo=
X-Received: by 2002:a24:508a:: with SMTP id m132-v6mr2057171itb.19.1543509834167;
 Thu, 29 Nov 2018 08:43:54 -0800 (PST)
MIME-Version: 1.0
From:   Jean Fobe <jeanfobe@ime.usp.br>
Date:   Thu, 29 Nov 2018 14:43:25 -0200
X-Gmail-Original-Message-ID: <CAMHc_wN+-qHc1+q6fuRCzzJ9fsE2-vwa5N3031ANpZ8+tXb7WQ@mail.gmail.com>
Message-ID: <CAMHc_wN+-qHc1+q6fuRCzzJ9fsE2-vwa5N3031ANpZ8+tXb7WQ@mail.gmail.com>
Subject: btrfs development - question about crypto api integration
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Level: 
X-Rspamd-Bar: ------
X-Rspamd-Status: No, score=-6.20
X-Spamd-Bar: ------
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=jeanfobe@iris.ime.usp.br smtp.mailfrom=jeanfobe@ime.usp.br
X-Rspamd-Server: nemesis
X-Rspamd-Queue-Id: B4EC22900A09
X-Spamd-Result: default: False [-6.20 / 15.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
         TO_DN_NONE(0.00)[];
         RCPT_COUNT_ONE(0.00)[1];
         FROM_IME(-6.00)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_TLS_LAST(0.00)[];
         ASN(0.00)[asn:15169, ipnet:209.85.128.0/17, country:US];
         RCVD_COUNT_TWO(0.00)[2];
         BAYES_HAM(-0.10)[65.19%]
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi all,
    I've been studying LZ4 and other compression algorithms on the
kernel, and seen other projects such as zram and ubifs using the
crypto api. Is there a technical reason for not using the crypto api
for compression (and possibly for encryption) in btrfs?
    I did not find any design/technical implementation choices in
btrfs development in the developer's FAQ on the wiki. If I completely
missed it, could someone point me in the right direction?
    Lastly, if there is no technical reason for this, would it be
something interesting to have implemented?

Best regards
