Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:33846 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbbLRJi3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Dec 2015 04:38:29 -0500
Received: by mail-lb0-f179.google.com with SMTP id cs9so59924095lbb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Dec 2015 01:38:28 -0800 (PST)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Fri, 18 Dec 2015 12:37:48 +0300
Message-ID: <CAGqmi75csQRJifFt=66ooQ9SHqxfeAJoRe+u7v21gNqaFibpgA@mail.gmail.com>
Subject: Space not return
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys, i catch strange problem:
btrfs with mysql, mysql rewrite data, but space consumption only increasing
i.e:

df -h
/dev/sdb1       112G   73G   39G  66% /var/lib/mysql

du -hs
43G /var/lib/mysql/

btrfs fi df /var/lib/mysql
Data, single: total=78.00GiB, used=72.39GiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=1.00GiB, used=109.61MiB
GlobalReserve, single: total=48.00MiB, used=0.00B

This is fresh fs (seven hours old)
Created by btrfs-progs 4.1.2
Linux 4.2.0-0.bpo.1-amd64 #1 SMP Debian 4.2.6-3~bpo8+2 (2015-12-14)
x86_64 GNU/Linux

Btrfsck not found any errors on this device

P.S. First i think what it because system have opened files
descriptors, but after reboot, space not return
If i write file by dd and after delete it, space will returned (with
direct io and without)

-- 
Have a nice day,
Timofey.
