Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40226 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaKCLe7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Nov 2014 06:34:59 -0500
Received: by mail-wg0-f42.google.com with SMTP id k14so12224668wgh.1
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Nov 2014 03:34:58 -0800 (PST)
Received: from [192.168.7.7] (a207.net131.okay.pl. [85.28.131.207])
        by mx.google.com with ESMTPSA id q3sm8999370wjr.44.2014.11.03.03.34.57
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Nov 2014 03:34:57 -0800 (PST)
Message-ID: <54576861.2030809@gmail.com>
Date: Mon, 03 Nov 2014 12:34:57 +0100
From: KC <qwrules@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs check won't repair inode errors
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I noticed my data partition had some inode inconsistencies, so I run 
btrfs check --repair.
However, it did nothing and errors are still there:


[root@sandiskFit juha]# btrfs check --repair /dev/mapper/HDD--total-data
enabling repair mode
Fixed 0 roots.
Checking filesystem on /dev/mapper/HDD--total-data
UUID: 3dfb375d-6a7c-47a5-a134-179585941d51
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
root 5 inode 2207209 errors 400, nbytes wrong
root 5 inode 2256086 errors 400, nbytes wrong
root 5 inode 2278303 errors 400, nbytes wrong
root 5 inode 2282131 errors 400, nbytes wrong
root 5 inode 2288244 errors 400, nbytes wrong
root 5 inode 2307687 errors 400, nbytes wrong
found 123129939084 bytes used err is 1
total csum bytes: 443189672
total tree bytes: 1094713344
total fs tree bytes: 501399552
total extent tree bytes: 81510400
btree space waste bytes: 164316106
file data blocks allocated: 617742684160
  referenced 521218134016
Btrfs v3.17

[root@sandiskFit juha]# btrfs check /dev/mapper/HDD--total-data
Checking filesystem on /dev/mapper/HDD--total-data
UUID: 3dfb375d-6a7c-47a5-a134-179585941d51
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
root 5 inode 2207209 errors 400, nbytes wrong
root 5 inode 2256086 errors 400, nbytes wrong
root 5 inode 2278303 errors 400, nbytes wrong
root 5 inode 2282131 errors 400, nbytes wrong
root 5 inode 2288244 errors 400, nbytes wrong
root 5 inode 2307687 errors 400, nbytes wrong
found 206299866321 bytes used err is 1
total csum bytes: 443189672
total tree bytes: 1094713344
total fs tree bytes: 501399552
total extent tree bytes: 81510400
btree space waste bytes: 164316106
file data blocks allocated: 617742684160
  referenced 521218134016
Btrfs v3.17


I am using Btrfs tools v3.17 and kernel 3.17
