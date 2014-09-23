Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:65092 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbaIWB5j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 21:57:39 -0400
Received: by mail-ie0-f175.google.com with SMTP id rl12so2347951iec.34
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 18:57:38 -0700 (PDT)
Received: from [192.168.0.50] (CPE0026f3330aca-CM0026f3330ac6.cpe.net.cable.rogers.com. [99.231.92.7])
        by mx.google.com with ESMTPSA id l9sm575994igf.9.2014.09.22.18.57.36
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Sep 2014 18:57:37 -0700 (PDT)
Message-ID: <5420D38F.9060903@gmail.com>
Date: Mon, 22 Sep 2014 21:57:35 -0400
From: nick <yocto6@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Sparse Warnings about locks in extent-tree.c
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Btfs Developers,
I am new so am unsure of how to fix this but we are hitting some sparse warnings about unlock/lock is having 
a wrong count when exiting certain functions in extent-tree.c. I will paste the warnings below for you guys.
Hope this is of help.
Cheers,
Nick  
fs/btrfs/extent-tree.c:6386:39: warning: context imbalance in 'btrfs_lock_cluster' - wrong count at exit
fs/btrfs/extent-tree.c:6663:44: warning: context imbalance in 'find_free_extent' - unexpected unlock
fs/btrfs/extent-tree.c:8810:9: warning: context imbalance in 'btrfs_put_block_group_cache' - wrong count at exit
