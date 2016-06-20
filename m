Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:36963 "EHLO
	mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbcFTX6B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 19:58:01 -0400
Received: by mail-it0-f51.google.com with SMTP id f6so2290318ith.0
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jun 2016 16:56:22 -0700 (PDT)
Received: from [192.168.2.2] (mctnnbsa45w-142162095072.dhcp-dynamic.FibreOP.nb.bellaliant.net. [142.162.95.72])
        by smtp.gmail.com with ESMTPSA id d192sm7592ith.10.2016.06.20.16.30.35
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Mon, 20 Jun 2016 16:30:35 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: Marc Grondin <marcfgrondin@gmail.com>
Subject: Confusing output from fi us/df
Message-ID: <29fb52eb-9aed-5d12-1631-0a8d776fb69c@gmail.com>
Date: Mon, 20 Jun 2016 20:30:33 -0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,


I have a btrfs filesystem ontop of a 4x1tb mdraid raid5 array and I've
been getting confusing output on metadata usage. Seems that even tho
both data and metadata are in single profile metadata is reporting
double the space(as if it was in dupe profile)



root@thebeach /h/marcg> uname -a
Linux thebeach 4.6.2-gentoo-GMAN #1 SMP Sat Jun 11 22:32:27 ADT 2016
x86_64 Intel(R) Core(TM) i5-2320 CPU @ 3.00GHz GenuineIntel GNU/Linux
root@thebeach /h/marcg> btrfs --version
btrfs-progs v4.5.3
root@thebeach /h/marcg> btrfs fi us /media/Storage2
Overall:
Device size: 2.73TiB
Device allocated: 1.71TiB
Device unallocated: 1.02TiB
Device missing: 0.00B
Used: 1.38TiB
Free (estimated): 1.34TiB (min: 1.34TiB)
Data ratio: 1.00
Metadata ratio: 1.00
Global reserve: 512.00MiB (used: 0.00B)


Data,single: Size:1.71TiB, Used:1.38TiB
/dev/mapper/storage2 1.71TiB


Metadata,single: Size:3.00GiB, Used:1.53GiB
/dev/mapper/storage2 3.00GiB


System,single: Size:32.00MiB, Used:208.00KiB
/dev/mapper/storage2 32.00MiB


Unallocated:
/dev/mapper/storage2 1.02TiB
root@thebeach /h/marcg> btrfs fi df /media/Storage2
Data, single: total=1.71TiB, used=1.38TiB
System, single: total=32.00MiB, used=208.00KiB
Metadata, single: total=3.00GiB, used=1.53GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
root@thebeach /h/marcg>


I'm not sure if this is known and if it's btrfs-progs related or if it
is actually allocating that space.


Thank you for reading.


Marc

