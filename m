Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:33751 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbbFEWu0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jun 2015 18:50:26 -0400
Received: by pdjn11 with SMTP id n11so23968032pdj.0
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jun 2015 15:50:26 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 5 Jun 2015 15:50:26 -0700
Message-ID: <CAG+QAKViMuK4WRp9e89izd7nFcckp-aq0eEmG+peBK-5RKVsGQ@mail.gmail.com>
Subject: checksum error on vmem file
From: Rich Rauenzahn <rrauenza@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I get this error occasionally on the same file.  I suspect it is some
interaction between vmware server and btrfs.  Besides this error, I
have no ill effects.

Is this a known issue?  Is it something that ought to be investigated
to improve btrfs?

I might be able to help find the right folks at vmware...

Rich

Fri Jun  5 15:43:41 2015: Jun  5 15:43:41 tendo kernel: BTRFS:
checksum error at logical 2253263028224 on dev /dev/sde1, sector
2382346400, root 257, inode 610942, offset 908943360, length 4096,
links 1 (path: VMs/Ubuntu
64-bit/564dc367-07ae-10b5-bff0-8762c109606c.vmem)
