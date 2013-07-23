Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:64108 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab3GWKDG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 06:03:06 -0400
Received: by mail-la0-f44.google.com with SMTP id er20so6084197lab.3
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 03:03:03 -0700 (PDT)
Received: from mail-lb0-x229.google.com (mail-lb0-x229.google.com [2a00:1450:4010:c04::229])
        by mx.google.com with ESMTPSA id x5sm12463354lbx.8.2013.07.23.03.03.02
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 23 Jul 2013 03:03:02 -0700 (PDT)
Received: by mail-lb0-f169.google.com with SMTP id d10so6145608lbj.0
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 03:03:01 -0700 (PDT)
MIME-Version: 1.0
From: Dan van der Ster <dan@vanderster.com>
Date: Tue, 23 Jul 2013 12:02:20 +0200
Message-ID: <CABZ+qqmmr0o0kVuc6jaHYSYQ1T8DtN5xZRL0vF8U-y2pRxv8uA@mail.gmail.com>
Subject: raid10 with mixed sized drives
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I know that raid10 requires at least 4 drives, and I understand how it
works with an even number of equally-sized drives > 4 in number (
btrfs will stripe over the N/2 mirrors).

But I'm curious if it works well with mixed-sized drives when you have
>4 drives. In my case I have:

Data, RAID10: total=5.12TB, used=5.12TB
System, RAID10: total=64.00MB, used=912.00KB
System: total=4.00MB, used=0.00
Metadata, RAID10: total=7.75GB, used=6.01GB

No balance found on '/media/btrfs'

Label: none  uuid: 743135d0-d1f5-4695-9f32-e682537749cf
        Total devices 8 FS bytes used 5.13TB
        devid    2 size 2.73TB used 1.43TB path /dev/sdi
        devid    6 size 1.36TB used 1.11TB path /dev/sdg
        devid    1 size 2.73TB used 1.43TB path /dev/sdh
        devid    5 size 1.36TB used 1.11TB path /dev/sdf
        devid    4 size 1.82TB used 1.32TB path /dev/sde
        devid    3 size 1.82TB used 1.32TB path /dev/sdd
        devid    7 size 1.82TB used 1.11TB path /dev/sdc
        devid    8 size 2.73TB used 1.43TB path /dev/sda

Btrfs v0.20-rc1-253-g7854c8b

You see, I have only 3 of the largest 2.73TB drives. So I'm wondering
what will happen as I fill this array. In particular, when the 1.82TB
drives become full and there are only 3 drives left to write to, will
btrfs report ENOSPC at that point? Or is the situation with my array
more complicated that that...

In general, does using raid10 without having your 4 largest drives
being equally-sized necessarily lead to some unusable capacity?

Thanks in advance,
Dan

P.S. in the wiki FAQ the answer is almost there: "A btrfs raid-10
volume with 6 1TB drives will yield 3TB usable space with 2 copies of
all data, but only 4". But only 4 what?!!!??!
