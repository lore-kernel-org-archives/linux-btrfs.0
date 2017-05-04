Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:47737 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753766AbdEDNh6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 May 2017 09:37:58 -0400
Received: from dhcp-18-189-27-136.dyn.mit.edu ([18.189.27.136])
        by techsquare.com with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
        (Exim 4.71)
        (envelope-from <matt@techsquare.com>)
        id 1d6GbS-0007wR-39
        for linux-btrfs@vger.kernel.org; Thu, 04 May 2017 09:15:41 -0400
To: linux-btrfs@vger.kernel.org
From: Matt McKinnon <matt@techsquare.com>
Message-ID: <a5052685-e126-d11d-7e9c-fc010c958319@techsquare.com>
Date: Thu, 4 May 2017 09:15:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Struggling with file system slowness
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

Trying to peg down why I have one server that has btrfs-transacti pegged 
at 100% CPU for most of the time.

I thought this might have to do with fragmentation as mentioned in the 
Gotchas page in the wiki (btrfs-endio-wri doesn't seem to be involved as 
mentioned in the wiki), but after running a full defrag of the file 
system, and also enabling the 'autodefrag' mount option, the problem 
still persists.

What's the best way to figure out what btrfs is chugging away at here?

Kernel: 4.10.13-custom
btrfs-progs: v4.10.2


-Matt
