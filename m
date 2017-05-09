Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-04.prod.phx3.secureserver.net ([184.168.200.145]:51718
        "EHLO p3nlsmtpcp01-04.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752426AbdEIORN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 May 2017 10:17:13 -0400
Received: from mail-ua0-f182.google.com ([209.85.217.182]:33750)
        by p3plcpnl0639.prod.phx3.secureserver.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.88)
        (envelope-from <lakshmipathi.g@giis.co.in>)
        id 1d85vt-0000RQ-CH
        for linux-btrfs@vger.kernel.org; Tue, 09 May 2017 07:16:09 -0700
Received: by mail-ua0-f182.google.com with SMTP id e28so1015850uah.0
        for <linux-btrfs@vger.kernel.org>; Tue, 09 May 2017 07:16:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170503163819.GA10030@giis.co.in>
References: <20170427100534.GA10404@giis.co.in> <20170502150601.GK23260@twin.jikos.cz>
 <20170502153556.GM23260@twin.jikos.cz> <20170503163819.GA10030@giis.co.in>
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
Date: Tue, 9 May 2017 19:46:08 +0530
Message-ID: <CAKuJGC8SndPLuVDVtJZLEzYg-Vfh0U1Y-wF4pr093yTnjJfkXg@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: btrfs-convert: Add larger device support
To: dsterba@suse.cz, quwenruo@cn.fujitsu.com, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

created a test script but it fail to detect mk2fs. Test script 009
also produces:

# ./convert-tests/009-common-inode-flags/test.sh
    [TEST/conv]     common inode flags test, btrfs defaults
failed: mke2fs -t ext4 -b 4096 -F
/home/laks/centos/laks/BTRFS/btrfs-progs/tests/test.img

Seems like run_check fails to detect mke2fs command. Something wrong
with my setup or issue with run_check?

-- 
----
Cheers,
Lakshmipathi.G
