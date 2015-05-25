Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:36446 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbbEYBCT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 May 2015 21:02:19 -0400
Received: by wgbgq6 with SMTP id gq6so60872124wgb.3
        for <linux-btrfs@vger.kernel.org>; Sun, 24 May 2015 18:02:18 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 25 May 2015 11:02:17 +1000
Message-ID: <CA+WRLO_=RV_Ga7d-ff=p13TxycquQ1Ra2d2WYeGroQn9tm934w@mail.gmail.com>
Subject: Did convert do anything?
From: Gareth Pye <gareth@cerberos.id.au>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just attempted to change the meta data of my 6 drive array to RAID6 with:

# btrfs balance start -mconvert=raid6 /data
Done, had to relocate 12 out of 4548 chunks

Which looks pretty good. But:

# btrfs  fi df /data
Data, RAID1: total=4.43TiB, used=4.41TiB
System, RAID1: total=32.00MiB, used=772.00KiB
Metadata, RAID1: total=11.00GiB, used=9.13GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

And some context:

# btrfs --version
btrfs-progs v4.0

# uname -a
Linux emile 4.0.1-040001-generic #201504290935 SMP Wed Apr 29 09:36:55
UTC 2015 x86_64 x86_64 x86_64 GNU/Linux


What am I missing here?



-- 
Gareth Pye
Level 2 MTG Judge, Melbourne, Australia
"Dear God, I would like to file a bug report"
