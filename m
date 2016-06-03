Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:33926 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbcFCOFV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 10:05:21 -0400
Received: by mail-oi0-f41.google.com with SMTP id e72so128287484oib.1
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 07:05:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com>
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
	<aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com>
Date: Fri, 3 Jun 2016 08:05:19 -0600
Message-ID: <CAJCQCtQ4i0PWisxi708EmrTuPHH7hNEkKfY28GjTG2s4Sk3DYQ@mail.gmail.com>
Subject: Re: Recommended why to use btrfs for production?
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Martin <rc6encrypted@gmail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 3, 2016 at 6:55 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

>
> That said, there are other options.  If you have enough disks, you can run
> BTRFS raid1 on top of LVM or MD RAID5 or RAID6, which provides you with the
> benefits of both.

There is a trade off. Either mdadm or lvm raid5, raid6, are more
mature and stable, but it's more maintenance. You have a btrfs scrub
as well as the md scrub. Btrfs on md/lvm raid56 will detect mismatches
but won't be able to fix them because from its perspective there's no
redundancy, except possibly metadata. So the repair has to happen on
the mdadm/lvm side

Make certain the kernel command timer value is greater than the driver
error recovery timeout. The former is found in sysfs, per block
device, the latter can be get and set with smartctl. Wrong
configuration is common (it's actually the default) when using
consumer drives, and inevitably leads to problems, even the loss of
the entire array. It really is a terrible default.


-- 
Chris Murphy
