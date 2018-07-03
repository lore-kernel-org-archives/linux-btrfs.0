Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:33901 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751776AbeGCEZS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 00:25:18 -0400
Received: by mail-lf0-f53.google.com with SMTP id n96-v6so453754lfi.1
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jul 2018 21:25:16 -0700 (PDT)
Subject: Re: how to best segment a big block device in resizeable btrfs
 filesystems?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Marc MERLIN <marc@merlins.org>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com>
 <20180629064354.kbaepro5ccmm6lkn@merlins.org>
 <20180701232202.vehg7amgyvz3hpxc@merlins.org>
 <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com>
 <20180702032259.GD5567@merlins.org>
 <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com>
 <20180702140527.wfbq5jenm67fvvjg@merlins.org>
 <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com>
 <20180702151853.mwlrinipbihq46zu@merlins.org>
 <e8e78a5b-1db2-ddf0-f8ea-38f8ac9be654@gmail.com>
 <20180702173438.7c2vhflvtncfb5gz@merlins.org>
 <8de54b29-c718-0230-09b2-f849e3ad01df@gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <9e79a4b4-af3c-20bf-ff8e-748b9ab46bf6@gmail.com>
Date: Tue, 3 Jul 2018 07:25:14 +0300
MIME-Version: 1.0
In-Reply-To: <8de54b29-c718-0230-09b2-f849e3ad01df@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

02.07.2018 21:35, Austin S. Hemmelgarn пишет:
> them (trimming blocks on BTRFS gets rid of old root trees, so it's a bit
> dangerous to do it while writes are happening).

Could you please elaborate? Do you mean btrfs can trim data before new
writes are actually committed to disk?
