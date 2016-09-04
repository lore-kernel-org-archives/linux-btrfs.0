Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35849 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754148AbcIDVlD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Sep 2016 17:41:03 -0400
Received: by mail-wm0-f41.google.com with SMTP id c133so97793586wmd.1
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Sep 2016 14:41:03 -0700 (PDT)
Subject: Re: btrfs send extremely slow (almost stuck)
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <03b9d0b0-7001-7dd9-75cd-69d58b94d553@googlemail.com>
 <6bebd709-8fdd-5e88-650d-f1c551946505@cn.fujitsu.com>
 <2926d118-6a2f-2066-529d-1dd8335200dc@googlemail.com>
 <a7ead62b-38f5-2ed6-c24b-1960a8fc6ba8@cn.fujitsu.com>
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Message-ID: <5e6e606d-e75c-b7f1-0a9f-4e36090659eb@googlemail.com>
Date: Sun, 4 Sep 2016 23:41:00 +0200
MIME-Version: 1.0
In-Reply-To: <a7ead62b-38f5-2ed6-c24b-1960a8fc6ba8@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 30.08.2016 um 02:48 schrieb Qu Wenruo:
> Yes.
> And more specifically, it doesn't even affect delta backup.
> 
> For shared extents caused by reflink/dedupe(out-of-band or even incoming in-band), it will be send as individual files.
> 
> For contents, they are all the same, just more space usage.

For those interested, I have now actually tested the btrfs send / btrfs receive backup for several subvolumes after applying this patch. 
The throughput is finally usable, almost hitting network / IO limits as expected - ideal so far! 
Also delta seemed fine for the subvolumes for which things worked. 

However, I now sadly get (for one of my subvolumes): 

send ioctl failed with -2: No such file or directory

at some point during the transfer, it sadly seems to be reproducible. 
I do not think it's related to this patch, but of course this makes "btrfs send" still unusable to me - 
I guess it's not ready for general use just yet. 
Is there any information I can easily extract / provide to allow the experts to fix this issue?
The kernel log shows nothing. 

Thanks a lot, 
	Oliver
