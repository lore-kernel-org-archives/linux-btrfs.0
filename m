Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40054 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751776AbeGCEXH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 00:23:07 -0400
Received: by mail-lj1-f196.google.com with SMTP id a6-v6so421336ljj.7
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jul 2018 21:23:07 -0700 (PDT)
Subject: Re: how to best segment a big block device in resizeable btrfs
 filesystems?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Marc MERLIN <marc@merlins.org>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <02ba7ad4-b618-85f0-a99f-c43b25d367de@cn.fujitsu.com>
 <20180629061001.kkmgvdgqfhz23kll@merlins.org>
 <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com>
 <20180629064354.kbaepro5ccmm6lkn@merlins.org>
 <20180701232202.vehg7amgyvz3hpxc@merlins.org>
 <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com>
 <20180702032259.GD5567@merlins.org>
 <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com>
 <20180702140527.wfbq5jenm67fvvjg@merlins.org>
 <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com>
 <20180702151853.mwlrinipbihq46zu@merlins.org>
 <ee8ff481-0aac-54ec-b496-f28feab2227b@gmx.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <25a02f1c-b6fa-5fae-2417-db57b191a915@gmail.com>
Date: Tue, 3 Jul 2018 07:23:04 +0300
MIME-Version: 1.0
In-Reply-To: <ee8ff481-0aac-54ec-b496-f28feab2227b@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

03.07.2018 04:37, Qu Wenruo пишет:
> 
> BTW, IMHO the bcache is not really helping for backup system, which is
> more write oriented.
> 

There is new writecache target which may help in this case.
