Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:33986 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbbFOQHU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 12:07:20 -0400
Received: by qcwx2 with SMTP id x2so4190442qcw.1
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2015 09:07:19 -0700 (PDT)
Message-ID: <1434384437.6916.11.camel@kepstin.ca>
Subject: Re: multiple "devices" with multiple partitions on one SSD
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Tom Yan <tom.ty89@gmail.com>, Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Date: Mon, 15 Jun 2015 12:07:17 -0400
In-Reply-To: <CAGnHSE=ik7Vta4i3ia9AvH=Epb=G3oifCAvTJVck81zi=0VWjQ@mail.gmail.com>
References: <CAGnHSEkEshdECi7TQ73DZRDg=t7kxwB7FCkPOTXruaiwHfzUUQ@mail.gmail.com>
	 <pan$e5a8$4c012c37$4117558f$ba504801@cox.net>
	 <CAGnHSE=ik7Vta4i3ia9AvH=Epb=G3oifCAvTJVck81zi=0VWjQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2015-06-12 at 18:11 +0800, Tom Yan wrote:
> Thank you for you reply. I thought of the same thing as you've told,
> but because I don't really know how SSD/SATA works internally, so I
> was also thinking if "raid0" on the same drive might works as
> something like "Hyper-Threading" in CPU.

Modern SSD controllers are already effectively doing "RAID0" striping
over multiple individual flash chips inside the drive in order to
achieve maximum sequential write speeds. With high end drives, a single
sequential write can already saturate the available bandwidth on the
SATA wire.

If anything, splitting up writes to bounce back and forth between two
different regions of the same drive would add overhead, and might
disrupt the write optimizations in the drive controller. It would
probably end up slower - although the difference might not be noticable

If you're just looking for speed, stick to single mode and let the
drive go fast.

Calvin.

-- 
Calvin Walton <calvin.walton@kepstin.ca>
