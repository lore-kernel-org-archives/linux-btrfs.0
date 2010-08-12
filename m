From: Vasiliy G Tolstov <v.tolstov@selfip.ru>
Subject: btrfs under xen domU
Date: Thu, 12 Aug 2010 12:00:05 +0400
Message-ID: <1281600005.5454.7.camel@vase.work>
Reply-To: v.tolstov@selfip.ru
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello. I want to use btrfs on root fs under xen domU.

Fs can grow in dom0 by dd if=/dev/zero of=image.img bs=1M count=0
seek=xxxx

I want to grow fs under domU after that automatically. Can i do mount -o
remount,rw,maxsize / on already mounted root fs with rw ?

Thank You for answer.


-- 
Vasiliy G Tolstov <v.tolstov@selfip.ru>
Selfip.Ru

