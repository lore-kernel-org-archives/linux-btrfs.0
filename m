Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:43173 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752595AbdIXQnJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Sep 2017 12:43:09 -0400
Received: by mail-wr0-f177.google.com with SMTP id a43so4234096wrc.0
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Sep 2017 09:43:08 -0700 (PDT)
Subject: Re: AW: Btrfs performance with small blocksize on SSD
To: "Fuhrmann, Carsten" <carsten.fuhrmann@rwth-aachen.de>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <3321b3c199da4d378bbfa3dbac3c4059@rwth-aachen.de>
 <f05a6500-19d6-fc7c-7461-905417c855b7@gmx.com>
 <b9067303023a49158bae2cdc34393716@rwth-aachen.de>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <ffd3bf37-3029-9f6e-5d57-6d8cca74fdad@gmail.com>
Date: Sun, 24 Sep 2017 19:43:05 +0300
MIME-Version: 1.0
In-Reply-To: <b9067303023a49158bae2cdc34393716@rwth-aachen.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

24.09.2017 16:53, Fuhrmann, Carsten пишет:
> Hello,
> 
> 1)
> I used direct write (no page cache) but I didn't disable the Disk cache of the HDD/SSD itself. In all tests I wrote 1GB and looked for the runtime of that write process.

So "latency" on your diagram means total time to write 1GiB file? That
is highly unusual meaning for "latency" which normally means time to
perform single IO. If so, you should better rename Y-axis to something
like "total run time".
