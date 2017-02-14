Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:37818 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754409AbdBNPaz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 10:30:55 -0500
Received: by mail-it0-f46.google.com with SMTP id x75so36710460itb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Feb 2017 07:30:49 -0800 (PST)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id l17sm454038ioi.60.2017.02.14.07.30.46
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Feb 2017 07:30:46 -0800 (PST)
To: linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Unexpected behavior involving file attributes and snapshots.
Message-ID: <ea92c7c6-4b98-d683-eb66-593836bcc82a@gmail.com>
Date: Tue, 14 Feb 2017 10:30:43 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was just experimenting with snapshots on 4.9.0, and came across some 
unexpected behavior.

The simple explanation is that if you snapshot a subvolume, any files in 
the subvolume that have the NOCOW attribute will not have that attribute 
in the snapshot.  Some further testing indicates that this is the only 
file attribute that isn't preserved (I checked all the chattr flags that 
BTRFS supports).

I'm kind of curious whether:
1. This is actually documented somewhere, as it's somewhat unexpected 
given that everything else is preserved when snapshotting.
2. This is intended behavior, or just happens to be a side effect of the 
implementation.
