Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.tu-berlin.de ([130.149.7.33]:21254 "EHLO mail.tu-berlin.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752144AbdDJKko (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 06:40:44 -0400
Message-ID: <1491820835.23359.3.camel@campus.tu-berlin.de>
Subject: Re: BTRFS not mountable, recover won't work
From: Malte Eggers <m.eggers@campus.tu-berlin.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Date: Mon, 10 Apr 2017 12:40:35 +0200
In-Reply-To: <c2d8533b-8502-292c-5a81-6831697f10e0@cn.fujitsu.com>
References: <1491758260.15056.2.camel@campus.tu-berlin.de>
         <60ea5a28-cdd3-84d6-1dc6-0cbcbc28755c@cn.fujitsu.com>
         <1491813428.1899.3.camel@campus.tu-berlin.de>
         <c2d8533b-8502-292c-5a81-6831697f10e0@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2017-04-10 at 16:53 +0800, Qu Wenruo wrote:
> 
> Then try chunk recovery
> ------
>   btrfs rescue chunk-recover /dev/dm-0
> ------
> 
> It can be very slow since it may scan the full device.
> 
> Thanks,
> Qu
> 
> > > Thanks,
> > > Qu
> > 
> > Thank you
> > 
Thank you for your help this far
After some two hours, it finally finished, but not with the result that
I was hoping for:
~# btrfs rescue chunk-recover /dev/dm-0
Scanning: DONE in dev0                        
No valid btrfs found
open with broken chunk error
Chunk tree recovery failed
