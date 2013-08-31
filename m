Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:34005 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3HaKIb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Aug 2013 06:08:31 -0400
Received: by mail-vc0-f179.google.com with SMTP id ht10so1968729vcb.10
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Aug 2013 03:08:30 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 31 Aug 2013 12:08:30 +0200
Message-ID: <CABF9=8jix2GoAm-nA41jMYMRqv+dxGq98SkaaYDvVwcqiHiTCQ@mail.gmail.com>
Subject: ENOSPC issue -- plenty of free space in metadata/data chunks
From: George Amvrosiadis <gamvrosi@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm using LK3.10, replaying filesystem traces on a btrfs filesystem,
and I my experiments always result in write()'s returning ENOSPC
(No space left on device). I'm baffled because I've been reading
about this issue on here, but in those other cases there were
indications that the Metadata chunks were used up. As you can
see in the attached df output, I don't have that issue. The following
fs is mounted using enospc_debug, but I haven't seen anything printed.

Can someone please let me know if there's a newer LK version
that has addressed possibly related ENOSPC issues, or whether
this is a known bug?

Many thanks,
George

gamvrosi@c154:~$ sudo btrfs fi df /media/btrfs-test
Data: total=87.01GB, used=85.48GB
System, DUP: total=8.00MB, used=16.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.00GB, used=383.77MB
Metadata: total=8.00MB, used=0.00

gamvrosi@c154:~$ sudo btrfs fi sh
Label: none  uuid: 9c632287-214b-4203-94e9-5411ad0d1fe0
        Total devices 1 FS bytes used 85.86GB
        devid    1 size 213.52GB used 89.04GB path /dev/sda3

Btrfs v0.20-rc1-253-g7854c8b-dirty


-- 
George Amvrosiadis, B.Sc., Ph.D. Candidate
Graduate Students' Union Representative
Computer Science, University of Toronto
