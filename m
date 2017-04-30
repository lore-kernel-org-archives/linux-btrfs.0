Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:35579 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756875AbdD3RKN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Apr 2017 13:10:13 -0400
Received: by mail-qk0-f170.google.com with SMTP id q1so8295527qkd.2
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Apr 2017 10:10:13 -0700 (PDT)
Received: from [192.168.0.23] ([98.4.97.1])
        by smtp.gmail.com with ESMTPSA id 139sm8195934qkl.13.2017.04.30.10.10.11
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 30 Apr 2017 10:10:11 -0700 (PDT)
Message-ID: <59061A73.2050207@gmail.com>
Date: Sun, 30 Apr 2017 13:10:11 -0400
From: "J. Hart" <jfhart085@gmail.com>
Reply-To: jfhart085@gmail.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: ERROR: rename o3528-7220-0 -> usr failed: Directory not empty
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am seeing the following error in one of a series of "btrfs send" 
operations.   The error is as follows:

At subvol /mnt/ArchPri/backup/primary/thinkcentre/root/backup.0.2
At snapshot backup.0.2017.04.21.03.11.40
ERROR: rename o3528-7220-0 -> usr failed: Directory not empty

It looks like it might be a btrfs bug, but I'm not sure.

A similar (?) bug was reported back on Feb 27, 2015 in the following 
message:
https://www.spinics.net/lists/linux-btrfs/msg42278.html

The resulting thread has since moved to :
https://www.spinics.net/lists/linux-btrfs/thrd34.html#42278

I am currently using a custom built 4.10.0 kernel from kernel.org. The 
linux system it's running on is one I built entirely from source (not 
Linux From Scratch) using a set of procedures I designed and so is not a 
common commercial one.

I will be happy to provide whatever further information or diagnostics I 
can.

J. Hart

