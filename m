Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:47736 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751797AbdIODz5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 23:55:57 -0400
Received: by mail-lf0-f41.google.com with SMTP id 80so1180261lfy.4
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Sep 2017 20:55:56 -0700 (PDT)
Subject: Re: BUG: BTRFS and O_DIRECT could lead to wrong checksum and wrong
 data
To: kreijack@inwind.it, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cf8a733f-2c9d-7ffe-e865-4c13d99dfb60@libero.it>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <3fc175a8-a61b-6060-5c78-abbbe2e61037@gmail.com>
Date: Fri, 15 Sep 2017 06:55:54 +0300
MIME-Version: 1.0
In-Reply-To: <cf8a733f-2c9d-7ffe-e865-4c13d99dfb60@libero.it>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

15.09.2017 01:00, Goffredo Baroncelli пишет:
> 
> 2) The second bug, is a more severe bug. If during a writing of a buffer with O_DIRECT, the buffer is updated at the same time by a second process, the checksum may be incorrect.
> 

Is it btrfs specific? If buffer is updated before it was actually
consumed by kernel, this likely means data corruption on any filesystem.
I.e. there should be clear indication from kernel that buffer can be
reused by application, in your example - when pwrite returns. So when
data corruption happens - during pwrite or after? If data is corrupted
during pwrite, it is arguably application fault - it should disallow
concurrent access.
