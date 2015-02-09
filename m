Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f41.google.com ([209.85.213.41]:55731 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308AbbBIR0u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 12:26:50 -0500
Received: by mail-yh0-f41.google.com with SMTP id f10so8138999yha.0
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Feb 2015 09:26:50 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 9 Feb 2015 18:26:49 +0100
Message-ID: <CABdHLQ7QPjUbzqNdzCfR0QxC-0coYs0dofuFvsROYXy-M9u4ig@mail.gmail.com>
Subject: btrfs performance, sudden drop to 0 IOPs
From: "P. Remek" <p.remek1@googlemail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am benchmarking Btrfs and when benchmarking random writes with fio
utility, I noticed following two things:

1) On first run when target file doesn't exist yet, perfromance is
about 8000 IOPs. On second, and every other run, performance goes up
to 70000 IOPs. Its massive difference. The target file is the one
created during the first run.

2) There are windows during the test where IOPs drop to 0 and stay 0
about 10 seconds and then it goes back again, and after couple of
seconds again to 0. This is reproducible 100% times.

Can somobody shred some light on what's happening?


Command: fio --randrepeat=1 --ioengine=libaio --direct=1
--gtod_reduce=1 --name=test9 --filename=test9 --bs=4k --iodepth=256
--size=10G --numjobs=1 --readwrite=randwrite

Environment:
CPU: dual socket: E5-2630 v2
   RAM: 32 GB ram
   OS: Ubuntu server 14.10
   Kernel: 3.19.0-031900rc2-generic
   btrfs tools: Btrfs v3.14.1
   2x LSI 9300 HBAs - SAS3 12/Gbs
   8x SSD Ultrastar SSD1600MM 400GB SAS3 12/Gbs

Regards,
Premek
