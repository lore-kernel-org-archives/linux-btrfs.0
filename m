Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:53324 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754041AbdIRLjs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 07:39:48 -0400
Received: by mail-it0-f51.google.com with SMTP id 85so594592ith.2
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Sep 2017 04:39:48 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id f4sm2990870itf.27.2017.09.18.04.39.46
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Sep 2017 04:39:46 -0700 (PDT)
Subject: Re: A user cannot remove his readonly snapshots?!
To: linux-btrfs@vger.kernel.org
References: <20170915163736.GD32347@rus.uni-stuttgart.de>
 <ce51b681-b86a-242a-1ac1-106454c32ddb@libero.it>
 <20170916101901.GM32347@rus.uni-stuttgart.de>
 <e1b1e123-67f5-6911-494e-da9ebdbd65cc@rqc.ru>
 <20170916134748.00a7e1d8@jupiter.sol.kaishome.de>
 <20170916142816.GN32347@rus.uni-stuttgart.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <82f3f41b-eda6-20c4-611e-0a99f9ed217e@gmail.com>
Date: Mon, 18 Sep 2017 07:39:44 -0400
MIME-Version: 1.0
In-Reply-To: <20170916142816.GN32347@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-16 10:28, Ulli Horlacher wrote:
> On Sat 2017-09-16 (13:47), Kai Krakow wrote:
> 
>> Or you do "btrfs device stats .", it shows the associated device(s).
> 
> tux@xerus:/test/tux/zz: btrfs device stats .
> ERROR: getting dev info for devstats failed: Operation not permitted
> 
> Not possible for a normal user.
> 
`btrfs fi show` should be possible for a normal user, and that also 
lists devices.  Alternatively, you can check /sys/fs/btrfs and correlate 
UUID's (possibly easier programmatically than analyzing regular output).

