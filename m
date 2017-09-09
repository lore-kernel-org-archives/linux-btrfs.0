Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:33222 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750878AbdIITnU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Sep 2017 15:43:20 -0400
Received: by mail-lf0-f50.google.com with SMTP id c80so11326990lfh.0
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Sep 2017 12:43:19 -0700 (PDT)
Received: from [192.168.1.6] (ppp109-252-55-58.pppoe.spdop.ru. [109.252.55.58])
        by smtp.gmail.com with ESMTPSA id d8sm800658lfd.3.2017.09.09.12.43.17
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Sep 2017 12:43:17 -0700 (PDT)
Subject: Re: netapp-alike snapshots?
To: linux-btrfs@vger.kernel.org
References: <20170822132208.GD14804@rus.uni-stuttgart.de>
 <20170909132614.GA20299@rus.uni-stuttgart.de>
 <20170909133612.7iqwr6cbjxzvfny6@merlins.org>
 <20170909134426.GB20299@rus.uni-stuttgart.de>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <14c87878-a5a0-d7d3-4a76-c55812e751a3@gmail.com>
Date: Sat, 9 Sep 2017 22:43:16 +0300
MIME-Version: 1.0
In-Reply-To: <20170909134426.GB20299@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

09.09.2017 16:44, Ulli Horlacher пишет:
> 
> Your tool does not create .snapshot subdirectories in EVERY directory like

Neither does NetApp. Those "directories" are magic handles that do not
really exist.

> Netapp does.
> Example:
> 
> framstag@fex:~: cd ~/Mail/.snapshot/
> framstag@fex:~/Mail/.snapshot: l
> lR-X - 2017-09-09 09:55 2017-09-09_0000.daily -> /local/home/.snapshot/2017-09-09_0000.daily/framstag/Mail

Apart from obvious problem with recursive directory traversal (NetApp
.snapshot are not visible with normal directory list) those will also be
captured in snapshots and cannot be removed. NetApp snapshots themselves
do not expose .snapshot "directories".

> lR-X - 2017-09-09 14:00 2017-09-09_1400.hourly -> /local/home/.snapshot/2017-09-09_1400.hourly/framstag/Mail
> lR-X - 2017-09-09 15:00 2017-09-09_1500.hourly -> /local/home/.snapshot/2017-09-09_1500.hourly/framstag/Mail
> lR-X - 2017-09-09 15:18 2017-09-09_1518.single -> /local/home/.snapshot/2017-09-09_1518.single/framstag/Mail
> lR-X - 2017-09-09 15:20 2017-09-09_1520.single -> /local/home/.snapshot/2017-09-09_1520.single/framstag/Mail
> lR-X - 2017-09-09 15:22 2017-09-09_1522.single -> /local/home/.snapshot/2017-09-09_1522.single/framstag/Mail
> 
> My users (and I) need snapshots in this way.
> 
> 

