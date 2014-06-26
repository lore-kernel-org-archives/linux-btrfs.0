Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:55035 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaFZS0i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jun 2014 14:26:38 -0400
Received: by mail-vc0-f182.google.com with SMTP id il7so3991480vcb.13
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jun 2014 11:26:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$1341b$d2234f6c$81aec330$bd4f59f8@cox.net>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
	<2316027.LZEnVG8laK@xev>
	<CAPLrYETdzeT_Yia-nnbZBMvGxU3x7tCFiJSv3rNJezMsjce3Zw@mail.gmail.com>
	<6CA8020B-EB92-4A44-8AA5-3F69709F81F2@colorremedies.com>
	<CAK5rZE6gfmQsZz3W_8t=pkKEk_rzqUn5hQVv0sbt8p7qbdhSdQ@mail.gmail.com>
	<53A6DDAD.8070804@chinilu.com>
	<99AD3EFE-AF9A-44A1-912E-07B1E934239B@colorremedies.com>
	<pan$600a2$3927cc39$ae007590$e90b8415@cox.net>
	<yq1bntjizkr.fsf@sermon.lab.mkp.net>
	<CAK5rZE4Eo+e_wbyzqPauYO=9HC9CEEF8Dftnw0D6zr1+7Z+GBw@mail.gmail.com>
	<pan$1341b$d2234f6c$81aec330$bd4f59f8@cox.net>
Date: Thu, 26 Jun 2014 20:26:37 +0200
Message-ID: <CAK5rZE7btzQo-nB+frM8L+y3=uk7+vavTVxW1yGe+Ni4o6C6EA@mail.gmail.com>
Subject: Re: btrfs on whole disk (no partitions)
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/25/14, Duncan <1i5t5.duncan@cox.net> wrote:
> Imran Geriskovan posted on Wed, 25 Jun 2014 15:01:49 +0200 as excerpted:
>> Note that gdisk gives default 8 sector alignment value for AF disks.
>> That is 'sector' meant by gdisk is 'Logical Sector'!
>> Sufficiently determined user may create misaligned partitions by playing
>> with alignment value and partition start/end values.

> AFAIK, for gdisk it's actually 2048 sector (1 MiB) alignment by default,
> on new devices or if you clear and redo the entire partition table.

Alignment does not mean starting your partition on 2048.
It means aligning partitions with physical block boundries.

By default cgdisk chooses 2048 sector as the start of first partition.
However you can use 32 - 2047 as well. (i.e. for Bios_Boot partition)

"Alignment value of 8" contraints your choices of partition locations
such as Sector 32, 40, 48,... so forth.. (in increments of 4K which
corresponds one physical block).

Regards, Imran
