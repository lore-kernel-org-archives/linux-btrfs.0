Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57322 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab2GSWJN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jul 2012 18:09:13 -0400
Received: by lbbgm6 with SMTP id gm6so4192564lbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2012 15:09:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201207191619.39100.Martin@lichtvoll.de>
References: <CALa9hx1ojpNEYOr8-pLbcm3Y80+GNaeJBtnEugh-BZF4OkpAHw@mail.gmail.com>
	<201207191304.03829.Martin@lichtvoll.de>
	<CALa9hx0C8-PpDRFr9fZMtDW95=56XGYHQMnPt5nXOS=2r=tQUA@mail.gmail.com>
	<201207191619.39100.Martin@lichtvoll.de>
Date: Fri, 20 Jul 2012 08:09:11 +1000
Message-ID: <CALa9hx2kjgvNYD_8=z5Mt=q=kSRW_6uR5pr_uF-BQ6=CPknvCw@mail.gmail.com>
Subject: Re: Very slow samba file transfer speed... any ideas ?
From: Shavi N <shavi64@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, Bernhard Redl <bernhard@stinkt.kicks-ass.org>,
        list@fajar.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Yes I read and understood your email. my btrfs volume consists of 11
HDD's. I was very surprised with that result myself...

On Fri, Jul 20, 2012 at 12:19 AM, Martin Steigerwald
<Martin@lichtvoll.de> wrote:
> Am Donnerstag, 19. Juli 2012 schrieb Shavi N:
>> Hi,
>
> Hi Shavi,
>
>> Thanks.
>>
>> This is the output:
>> btrfs:
>> $ dd if=/dev/zero of=/mnt/shared/misc/temp_file bs=1M count=1400
>> 1400+0 records in
>> 1400+0 records out
>> 1468006400 bytes (1.5 GB) copied, 1.56841 s, 936 MB/s
>>
>> ext4:
>> $ dd if=/dev/zero of=/mnt/500/VirutalBox_VMs/thor/thor-data/temp_file
>> bs=1M count=1400
>> 1400+0 records in
>> 1400+0 records out
>> 1468006400 bytes (1.5 GB) copied, 4.98993 s, 294 MB/s
>
> Did you actually read and understand my mail?
>
> Do you really think that your local disks is/are yielding that
> transferrate? (Unless you are using BTRFS RAID 0/10 on lots of disks.)
>
> Thanks,
> --
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
