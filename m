Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:34990 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750810AbdDBGau (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Apr 2017 02:30:50 -0400
Received: by mail-lf0-f51.google.com with SMTP id j90so59047547lfk.2
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Apr 2017 23:30:49 -0700 (PDT)
Received: from [192.168.1.6] (ppp109-252-90-38.pppoe.spdop.ru. [109.252.90.38])
        by smtp.gmail.com with ESMTPSA id m18sm1815605ljb.8.2017.04.01.23.30.47
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Apr 2017 23:30:47 -0700 (PDT)
Subject: Re: Is btrfs-convert able to deal with sparse files in a ext4
 filesystem?
To: linux-btrfs@vger.kernel.org
References: <CADN-S7MzE=6x25DK0XOPzfBGCEpTjdUSokBkuCPGhCvCURzLPg@mail.gmail.com>
 <20170401191357.GA25721@coach> <pan$df213$fa344dca$8529fcec$34b89ea9@cox.net>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <c5472e71-908c-3d42-ee40-73d003bfc598@gmail.com>
Date: Sun, 2 Apr 2017 09:30:46 +0300
MIME-Version: 1.0
In-Reply-To: <pan$df213$fa344dca$8529fcec$34b89ea9@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

02.04.2017 03:59, Duncan пишет:
> 
> 4) In fact, since an in-place convert is almost certainly going to take 
> more time than a blow-away and restore from backup,

This caught my eyes. Why? In-place convert just needs to recreate
metadata. If you have multi-terabyte worth of data copying them twice
hardly can be faster.
