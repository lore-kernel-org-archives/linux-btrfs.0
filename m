Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F973C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 14:36:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4846E20675
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 14:36:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393668AbfAPOg1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Jan 2019 09:36:27 -0500
Received: from mout.gmx.net ([212.227.15.19]:41607 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387533AbfAPOg1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Jan 2019 09:36:27 -0500
Received: from t460-skr.localnet ([194.94.224.254]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0LiDKt-1h58t02MUd-00nUlh for
 <linux-btrfs@vger.kernel.org>; Wed, 16 Jan 2019 15:36:25 +0100
From:   Stefan K <shadow_7@gmx.net>
To:     Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: question about creating a raid10
Date:   Wed, 16 Jan 2019 15:36:25 +0100
Message-ID: <3318002.5e9V1lv8s4@t460-skr>
User-Agent: KMail/5.2.3 (Linux/4.9.0-8-amd64; KDE/5.28.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:auBAbw/uvA+N+5+szDxzhQyfNJmPM4DoVpHdlR107QklmYYXGiN
 3mtMI28zsIjRDXjf5qtJ5/3qDtechIPLqb7yrXkRZoZK7O0Bbscch95cZXEQnoVtkaNrhEG
 mNXC5ZV8dyXCXabHvggqeUmMa2cOsUsCpbnbyXBD6jBZpNy+2C2VlTXGV/9AEnfaFfvVzie
 DXcS7xf80jiQD4n8iMwPA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Xblq91n+iHk=:cnR4KMFHdjo+yTdW/i70ST
 il1S/9ex7w0cJCOCen2u//ZtIJpUPNjS3sfmjk9c0vQ+3LkoEwMww0oLlc7iLafL9Tw5x6h0j
 Evj6q/ZUcmwoVlIjLagipqEWupNwIbCqlj432IMEaWcbKzr2ALNkwkH01CmKL1oTFhI31SojX
 W/OGVXAP7JH506rmDclLaG4VM2LGlimczjQ9AeGLj1kelsDHEo9rn7Uw3UU51lDoMbq1cbNf1
 mcPx0dCJS4T2s6v5NhzNdH3x8lNBs9go1zAFW386kgUPSxIMrakFz1unOTWqro2fi4WGqoMuC
 qhulsinW+nr5R67EAmUuSFGh+6e3Xo/39KlF7jQ9mtykGDdYBVluiS6njd24hNKnyoFqo6mxP
 Lxik+yp620tKw55kpNqkajG0M3NJYmQyZi7giff/I8WY8A1RRvN6GfNhUy92M+365J96ggCVZ
 1UQd8bSxt5+BFu6yAAsHpM0lb+yWtlY4Cnb/NYRiCAbN8922NZ6DP34O0XMJYE+39tTuwRnaO
 euLBwDksaMVMjj2L9XZb9SU99LMV2l1Qq/QkEBUM95goeSNIp3qn+1jt4GJESaK/ipxs00qPS
 AkXV4jWBNxkZXPBX87c16KyUAf9bVOlWv2uUd1aa+QrGhAx8QVDsw1ochOPbRGsa6fEjQ2rgb
 HtPxU6EMguMbOGTaNonwh3xwbSFiQbsvrnkeTn3UdcXeRp7z0cRCDRA5QS8jwenykXhjiWjW1
 MpZGwE8aYLYaGn3FLUBT4y6VXoq0hnpBAOBxqG+i+uTA4Vk3DAxkmPxQti8grEtM0qkDKMPoO
 MOCNQsnsSyWZB/kCCrrIcVQEOX7eqcaPRMQ+uotkmnzOP5KenO8d+19qpbd0EU3XQM7nCCgI6
 ZnnNZJ5iUDjlObRcMool3uU/NRLa4AiUeHtDytYavLaY29lOMAcbc8DBLVguJfiZQsaepttY2
 QMjY61INvlQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

if I create a raid10 it looks like that:
mkfs.btrfs -m raid10 -d raid10 /dev/sdb /dev/sdc /dev/sdd /dev/sde

but if I've different jbods and I want that every mirror of a raid10 is on a different jbod how can I archive that? in zfs it looks like that:
zpool create -o ashift=12 nc_storage mirror j1d03-hdd j2d03-hdd mirror j1d04-hdd j2d04-hdd

zpool status
[sudo] password for skrueger:                                                                                                                                                                                                                                                                                                
  pool: nc_storage                                                                                                                                                                                                                                                                                                           
 state: ONLINE                                                                                                                                                                                                                                                                                                               
  scan: scrub repaired 0B in 1h23m with 0 errors on Tue Jan 15 05:38:54 2019                                                                                                                                                                                                                                                 
config:                                                                                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                                             
        NAME           STATE     READ WRITE CKSUM                                                                                                                                                                                                                                                                            
        nc_storage     ONLINE       0     0     0                                                                                                                                                                                                                                                                            
          mirror-0     ONLINE       0     0     0                                                                                                                                                                                                                                                                            
            j1d03-hdd  ONLINE       0     0     0                                                                                                                                                                                                                                                                            
            j2d03-hdd  ONLINE       0     0     0                                                                                                                                                                                                                                                                            
          mirror-1     ONLINE       0     0     0                                                                                                                                                                                                                                                                            
            j1d04-hdd  ONLINE       0     0     0                                                                                                                                                                                                                                                                            
            j2d04-hdd  ONLINE       0     0     0 


how can I be sure that is btrfs the same?

best regards 
Stefan
