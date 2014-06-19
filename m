Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f182.google.com ([209.85.128.182]:42354 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757612AbaFSI6V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 04:58:21 -0400
Received: by mail-ve0-f182.google.com with SMTP id oy12so2019377veb.13
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 01:58:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2316027.LZEnVG8laK@xev>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
	<2316027.LZEnVG8laK@xev>
Date: Thu, 19 Jun 2014 10:58:20 +0200
Message-ID: <CAK5rZE4GVJ7qh4w=ecTZhZMANT0A6cU-6+jAbifNtoWFeYtf4Q@mail.gmail.com>
Subject: Re: btrfs on whole disk (no partitions)
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/19/14, Russell Coker <russell@coker.com.au> wrote:
> On Wed, 18 Jun 2014 21:29:39 Daniel Cegiełka wrote:
>> Everything works fine. Is such a solution is recommended? In my
>> opinion, the creation of the partitions seems to be completely
>> unnecessary if you can use btrfs.

> If you don't need to have a boot loader or swap space on the disk
> then there's no reason to have a partition table.  Note that it's often good
> to have some swap space even if everything can fit in RAM because
> Linux sometimes pages things out to make more space for cache.

Grub installs itself and boots from Partitionless Btrfs disk.
It is handy for straight forward installations.

However, you need boot partition (ie. initramfs and kernel to boot
from encrypted root) its another story.

Swap is an issue. But you may try zram (compressed ram swap).
I've got some crashes on 3.14. Thus, waiting for it to stabilize.

Imran
