Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:45276 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934187AbeAHPzz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jan 2018 10:55:55 -0500
Received: by mail-io0-f173.google.com with SMTP id e20so14557500iof.12
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Jan 2018 07:55:54 -0800 (PST)
Received: from [191.9.212.201] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id c17sm7288584iob.66.2018.01.08.07.55.52
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jan 2018 07:55:52 -0800 (PST)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Recommendations for balancing as part of regular maintenance?
Message-ID: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
Date: Mon, 8 Jan 2018 10:55:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So, for a while now I've been recommending small filtered balances to 
people as part of regular maintenance for BTRFS filesystems under the 
logic that it does help in some cases and can't really hurt (and if done 
right, is really inexpensive in terms of resources).  This ended up 
integrated partially in the info text next to the BTRFS charts on 
netdata's dashboard, and someone has now pointed out (correctly I might 
add) that this is at odds with the BTRFS FAQ entry on balances.

For reference, here's the bit about it in netdata:

You can keep your volume healthy by running the `btrfs balance` command 
on it regularly (check `man btrfs-balance` for more info).


And here's the FAQ entry:

Q: Do I need to run a balance regularly?

A: In general usage, no. A full unfiltered balance typically takes a 
long time, and will rewrite huge amounts of data unnecessarily. You may 
wish to run a balance on metadata only (see Balance_Filters) if you find 
you have very large amounts of metadata space allocated but unused, but 
this should be a last resort.


I've commented in the issue in netdata's issue tracker that I feel that 
the FAQ entry could be better worded (strictly speaking, you don't 
_need_ to run balances regularly, but it's usually a good idea). 
Looking at both though, I think they could probably both be improved, 
but I would like to get some input here on what people actually think 
the best current practices are regarding this (and ideally why they feel 
that way) before I go and change anything.

So, on that note, how does anybody else out there feel about this?  Is 
balancing regularly with filters restricting things to small numbers of 
mostly empty chunks a good thing for regular maintenance or not?
