Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:33940 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbbHQUgo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Aug 2015 16:36:44 -0400
Received: by iodb91 with SMTP id b91so165179889iod.1
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2015 13:36:43 -0700 (PDT)
Message-ID: <1439843801.24704.11.camel@kepstin.ca>
Subject: Re: The performance is not as expected when used several disks on
 raid0.
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Eduardo Bach <hellbach@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Date: Mon, 17 Aug 2015 16:36:41 -0400
In-Reply-To: <CANCCtjk2+DevkJqZB2opVpx9EWRWSM7R1nTigs0z=3jWbH-VMg@mail.gmail.com>
References: <CANCCtj=EDCU4dMRk3m7cJFPXk8D2Pse8yfqc4iaDGjPOQ5EORA@mail.gmail.com>
	 <1439569823.25646.11.camel@kepstin.ca>
	 <1439570139.25646.13.camel@kepstin.ca>
	 <CANCCtjk2+DevkJqZB2opVpx9EWRWSM7R1nTigs0z=3jWbH-VMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2015-08-17 at 16:44 -0300, Eduardo Bach wrote:
> Based on previous testing with a smaller number of disk I'm
> suspecting
> that the 32 disks are not all being used. With 12 discs I got more
> speed with btrfs thanmdadm+xfs. With, btrfs, 12 disks and large files
> we got the entire theoretical speed, 12 x 200MB/s per disk. My hope
> was to get some light from you guys to debug the problem so the btrfs
> use the 32 discs (assuming this is the problem). Perhaps the debug
> this problem may be of interest to devs?

>From the sounds of this, you must be hitting some bottleneck in the
btrfs code. One thing I'm actually curious about: How is the CPU usage
during these tests?

Btrfs can more work on the CPU than mdadm+xfs - in particular, data che
cksums are enabled by default. If you have compression enabled, that
would obviously be a major hit as well. Make sure you don't have
compression enabled (it's off by default, or you can use the mount
option "compress=no"). You could try with the "nodatasum" option to see
if checksums make a difference.

It could be possible that you're saturating the CPU, and that's why
you're not seeing any additional gains over 3.5GB/s. Taking a look at
top output while the test is running might be informative.

On the other hand, if the CPU isn't saturated and the disk io isn't
saturated, then it's probably a scaling issue in btrfs, possibly
something like lock contention.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

