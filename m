Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99265C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Mar 2021 12:08:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5916864FC4
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Mar 2021 12:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbhCJMID (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 07:08:03 -0500
Received: from mout.gmx.net ([212.227.17.21]:47147 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232417AbhCJMHs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Mar 2021 07:07:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1615378067;
        bh=jh6d2SXtyk4KzHA1TYCeK41NkAdAietwrgRkz3myw5Q=;
        h=X-UI-Sender-Class:From:To:Subject:Date;
        b=YtjtdKVKTaTtNjx+yBIcZa3TGAbjf6LdlksVCdjTcprr+Lu7HAFxpj1//FqXJHGgh
         rjkWaOr35DVaN2KP8JYyshDEpNAQjpnsZpgfi549rrS2ofTIi+8MKCGhqklbLBToxD
         YvKj47PO2BxbjTzkHgVlJqXSTRXysj/b1xl1VwOc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [77.11.30.192] ([77.11.30.192]) by web-mail.gmx.net
 (3c-app-gmx-bs66.server.lan [172.19.170.210]) (via HTTP); Wed, 10 Mar 2021
 13:07:47 +0100
MIME-Version: 1.0
Message-ID: <trinity-e300b8c5-315a-4823-8664-4f663481461c-1615378067176@3c-app-gmx-bs66>
From:   telsch <telsch@gmx.de>
To:     linux-btrfs@vger.kernel.org
Subject: no memory is freed after snapshots are deleted
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 10 Mar 2021 13:07:47 +0100
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K1:HyzIyTq05lAKgVVu+71UkqjJct8T45wXYPvf2Gcbzv6hQQjGDrOGDHhqnVGsSWc3wdGtt
 bNMwmjhSUECzYIDwDGaF+PWj5ubL4Fw5UQZdJ/y11H1tQxW7Krco8CsuFQ+UN6glfGiYQV8srk/+
 PrcGQASKGVMAsBZdCqI5XMT9SQYInP4XS3X8YERj/ojre0x7Hp+74BFm2/fmWTfqVOVD0M9uNnZs
 FOtk+8ZeOJMWKDYEOk7+kbKNTYSKrKl1C89zEEpU7+NtWXWxX2h0VINW3nnsytxKfkZglUTr6X/f
 TU=
X-UI-Out-Filterresults: notjunk:1;V03:K0:tCWAA+1FFh8=:A6s93KkKw88vs+f2TMS7xI
 bGbLyKhKt8KUUn9pMpSvmfOzs+EguKhfwPndeWw8ceJ0Y/TsOkb2kCMnssaCYJ4gamei1IKnq
 b9TtRUISsz42ImfEaRDdK+a/mxUZWx2GSiNidWxJIf0rAgHq+FW4Gnin1Eqjsln9VJhidsbK7
 Md8h7Jzb2fd4V8WLViWSOAU2Gy4xMnY61gSMhtvkgRzPjTS9t9KR+tl6m1IeLRX6T+KRwpDeb
 J82NFjGAQ5o2rlD7GMRlXmkYfCEIjiUyhc0KX+DqWSatjvma5KdTEysidiKHlxQcXT/zw/QDO
 wuLammkxyBgt1kedpSjwtLr//4AVrJX+8UND4XKpC2FzL+4QojP7BpSqywIvF6icT/9CVkgkS
 ztl4azYob+TJtvIiZ/y+CiEYmfongDHXuozNowTjZY36tZzoypZ333im8nJ5NuKANVmXe8yO/
 Wi82ucavdsEsdkwdg6rf0fHsnbJVq/PtWjByujzWaqsWmM3aC9AWJIEc41b8+9SPXggzeFRFv
 ZLYwoeXno4t3BcGu5nRoeyBkUmLdhRFdgfDHsPC0d9beQI0ovK2+LStM1vQMSuggIzAoqaEaw
 E11PIhn2scbHY=
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Dear devs,

after my root partiton was full, i deleted the last monthly snapshots. however, no memory was freed.
so far rebalancing helped:

	btrfs balance start -v -musage=0 /
	btrfs balance start -v -dusage=0 /

i have deleted all snapshots, but no memory is being freed this time.

du -hcsx /
16G     /
16G     total

btrfs-progs v5.10.1
Linux arch-server 5.10.21-1-lts #1 SMP Sun, 07 Mar 2021 11:56:15 +0000 x86_64 GNU/Linux

btrfs fi show /
Label: none  uuid: 3d242677-6a15-4ce7-853a-5c82f0427769
        Total devices 1 FS bytes used 37.24GiB
        devid    1 size 39.95GiB used 39.95GiB path /dev/mapper/root

btrfs fi df /
Data, single: total=36.45GiB, used=35.86GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=1.72GiB, used=1.38GiB
GlobalReserve, single: total=215.94MiB, used=0.00B


any ideas how to solve this without recreating filesystem?

thx!
