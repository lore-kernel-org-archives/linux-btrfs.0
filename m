Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:41338 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762961Ab3ECJTc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 May 2013 05:19:32 -0400
Received: by mail-ea0-f169.google.com with SMTP id n15so670916ead.28
        for <linux-btrfs@vger.kernel.org>; Fri, 03 May 2013 02:19:31 -0700 (PDT)
Received: from [192.168.162.70] (mailgw.zinwave.com. [81.145.40.204])
        by mx.google.com with ESMTPSA id bj12sm14620270eeb.8.2013.05.03.02.19.29
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 03 May 2013 02:19:30 -0700 (PDT)
Message-ID: <51838121.8060306@gmail.com>
Date: Fri, 03 May 2013 10:19:29 +0100
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: open_ctree failure on upgrading 3.7 to 3.8 kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Long story short:
I've got btrfs raid10 six disk array plus 2 other disks just having a 
"normal setup" btrfs filesystems.
Everything was running happily under linux 3.5 and 3.7.
3.5 was a stock ubuntu kernel, 3.7 was "slightly less stock" ubuntu kernel.
Now I've upgraded my box to 3.8 and none of btrfs file systems mounts 
any more. I got open_ctree errors every time I try to mount those. When 
I reboot system choosing old kernel from grub - everything runs smooth 
again. Was there any "on disk format" change or compatibility change?.




Some kernel.log output:

[ 13.517952] device fsid 9415cddb-e3b8-4977-804c-369553a7eda7 devid 4 
transid 111130 /dev/sdh1
[ 13.518535] btrfs: disk space caching is enabled
[ 13.518773] btrfs: failed to read the system array on sdh1
[ 13.523175] btrfs: open_ctree failed
