Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:34119 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932952AbcH2NVB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 09:21:01 -0400
Received: by mail-qk0-f172.google.com with SMTP id t7so136985016qkh.1
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Aug 2016 06:20:33 -0700 (PDT)
Message-ID: <1472476824.3108.1.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Date: Mon, 29 Aug 2016 10:20:24 -0300
In-Reply-To: <57C426AB.3020607@cn.fujitsu.com>
References: <1471023419.16857.9.camel@gmail.com>
         <57C426AB.3020607@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Em Seg, 2016-08-29 às 20:12 +0800, Wang Xiaoguang escreveu:
> When strange ENOSPC errors occur, I think "btrfs fi usage"
> or "btrfs di df" do not help too much. Their output do not
> reflect btrfs kernel current status :)
> 
> Would you please provide attribute files' values in 
> /sys/fs/btrfs/$UUID/allocation/data
> and /sys/fs/btrfs/$UUID/allocation/metadata when ENOSPC error occurs.
> 

Sure! As soon as I see the error again, I will send this results. Now,
I see that if I move my jail directory to a ext4 partition, then I do
not see the problem anymore, but I need more test to validade this
assumption.

Best regards,
Ronan Arraes
