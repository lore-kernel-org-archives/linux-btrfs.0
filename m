Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:60105 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab2KCEJH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Nov 2012 00:09:07 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so1588169eaa.19
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2012 21:09:06 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 3 Nov 2012 14:39:06 +1030
Message-ID: <CACCfv7pVYHCb_rO-ZefogCrvvvO0C3PN2BOArk4O2sRScWWTxg@mail.gmail.com>
Subject: What's the minimum size I can shrink my FS to?
From: Jordan Windsor <jordanw2@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I'm trying to shrink my Btrfs filesystem to the smallest size it can
go, here's the information:

failed to read /dev/sr0
Label: 'Storage'  uuid: 717d4a43-38b3-495f-841b-d223068584de
Total devices 1 FS bytes used 491.86GB
devid    1 size 612.04GB used 605.98GB path /dev/sda6

Btrfs Btrfs v0.19

Data: total=580.90GB, used=490.88GB
System, DUP: total=32.00MB, used=76.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=12.51GB, used=1001.61MB

Here's the command I use to resize:

[root@archpc ~]# btrfs file res 500g /home/jordan/Storage/
Resize '/home/jordan/Storage/' of '500g'
ERROR: unable to resize '/home/jordan/Storage/' - No space left on device

I was wondering if that size doesn't work then what's the minimum I
can shrink to?

Thanks.
