Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx01.imt-systems.com ([212.224.83.170]:58094 "EHLO
	mx01.imt-systems.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaGOPda (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jul 2014 11:33:30 -0400
Received: from ucsinet10.imt-systems.com (ucsinet10.imt-systems.com [212.224.83.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx01.imt-systems.com (Postfix) with ESMTPS id 3hCQYJ3mzdz6wRJ
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 17:26:12 +0200 (CEST)
Received: from mail-ig0-f179.google.com (mail-ig0-f179.google.com [209.85.213.179])
	(authenticated bits=0)
	by ucsinet10.imt-systems.com (8.14.4/8.14.4) with ESMTP id s6FFQ9eo024552
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 17:26:12 +0200
Received: by mail-ig0-f179.google.com with SMTP id h18so3039013igc.6
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 08:26:09 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 15 Jul 2014 17:26:09 +0200
Message-ID: <CAKSJeFKteZNUnJmN3dnYaHLnayQhZNNTKX5co_smMqwy1JgQNA@mail.gmail.com>
Subject: btrfs kernel workqueues performance regression
From: Morten Stevens <mstevens@fedoraproject.org>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I see that btrfs is using kernel workqueues since linux 3.15. After
some tests I noticed performance regressions with fs_mark.

mount options: rw,relatime,compress=lzo,space_cache

fs_mark on Kernel 3.14.9:

# fs_mark  -d  /mnt/btrfs/fsmark  -D  512  -t  16  -n  4096  -s  51200  -L5  -S0
FSUse%        Count         Size    Files/sec     App Overhead
     1        65536        51200      17731.4           723894
     1       131072        51200      16832.6           685444
     1       196608        51200      19604.5           652294
     1       262144        51200      18663.6           630067
     1       327680        51200      20112.2           692769

The results are really nice! compress=lzo performs very good.

fs_mark after upgrading to Kernel 3.15.4:

# fs_mark  -d  /mnt/btrfs/fsmark  -D  512  -t  16  -n  4096  -s  51200  -L5  -S0
FSUse%        Count         Size    Files/sec     App Overhead
     0        65536        51200      10718.1           749540
     0       131072        51200       8601.2           853050
     0       196608        51200      11623.2           558546
     0       262144        51200      11534.2           536342
     0       327680        51200      11167.4           578562

That's really a big performance regression :(

What do you think? It's easy to reproduce with fs_mark.

Thank you.

Best regards,

Morten
