Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_20,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 835CAC12002
	for <linux-btrfs@archiver.kernel.org>; Sat, 17 Jul 2021 01:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E3A4611AD
	for <linux-btrfs@archiver.kernel.org>; Sat, 17 Jul 2021 01:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhGQB5x (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Jul 2021 21:57:53 -0400
Received: from mx2.simplelogin.co ([94.237.125.28]:41610 "EHLO
        mx2.simplelogin.co" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbhGQB5x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Jul 2021 21:57:53 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jul 2021 21:57:53 EDT
X-SimpleLogin-Client-IP: 94.237.111.15
Received: from [172.17.0.7] (mx1.simplelogin.co [94.237.111.15])
        by mx2.simplelogin.co (Postfix) with ESMTP id 2B4A15D999
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Jul 2021 01:45:23 +0000 (UTC)
Subject: Read time tree block corruption detected
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   pepperpoint@mb.ardentcoding.com
To:     linux-btrfs@vger.kernel.org
Message-ID: <162648632340.7.1932907459648384384.10178178@mb.ardentcoding.com>
Date:   Sat, 17 Jul 2021 01:45:23 -0000
X-SimpleLogin-Type: Reply
X-SimpleLogin-EmailLog-ID: 10178178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;  d=mb.ardentcoding.com;
 i=@mb.ardentcoding.com; q=dns/txt; s=dkim;  t=1626486323; h=from : to;
  bh=Rsn8fwYm7V890xLAN/+jCQkZPLMi3dLAcVe9PBrfxzU=;
  b=LRQ79vZ5JW4RyQdtns76AJ2/9K0lrJxwa3fWVQzm4g/SuDpPim7MQk4kHZ2uZTMyuVyVC
  X9qlf/zsYFV/oS0cuUsE0dXJufmHzXxVALlhDUHlJmJH0dS7ZEb9Lhyj35PpFpnJgb9upIw
  aQwOStCr81oJwrQAY8S+16YMtCBYCVU= 
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

I see this message on dmesg:

[ 2452.256756] BTRFS critical (device dm-0): corrupt leaf: root=3D363 block=
=3D174113599488 slot=3D9 ino=3D7415, invalid nlink: has 2 expect no more th=
an 1 for dir
[ 2452.256776] BTRFS error (device dm-0): block=3D174113599488 read time tr=
ee block corruption detected

When I run btrfs scrub and btrfs check, no error was detected.
I am running Linux 5.12.15-arch1-1 and btrfs-progs v5.12.1

How should I fix this error?

