Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:51444 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab3LOUUV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Dec 2013 15:20:21 -0500
Received: by mail-lb0-f170.google.com with SMTP id c11so543834lbj.29
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Dec 2013 12:20:20 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 15 Dec 2013 20:20:19 +0000
Message-ID: <CAAeznTpG6A7ygKg1AUx_pAMs_SNwG4a4C5gHPeT+HcKRsD+TWA@mail.gmail.com>
Subject: btrfs balance on single device
From: Leonidas Spyropoulos <artafinde@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey all,

Just did a btrfs balance on a single device. Before the balance
operation here is the df result:

inglor@tiamat ~$ btrfs fi df /home
Data: total=19.19GB, used=9.34GB
System, DUP: total=32.00MB, used=4.00KB
Metadata, DUP: total=896.00MB, used=227.98MB

Then I issues a balance operation relocating the chunks across a single device:
inglor@tiamat ~$ sudo btrfs fi balance /home
[sudo] password for inglor:
Done, had to relocate 28 out of 28 chunks

After I did another df:
inglor@tiamat ~$ btrfs fi df /home
Data: total=10.00GB, used=9.34GB
System, DUP: total=32.00MB, used=4.00KB
Metadata, DUP: total=384.00MB, used=226.80MB

Anyone can explain me the Data row of the above output ? It used to be
19.19GB and now it's 10.00GB. It's like the partition shrunk!? The
balance operation finished without issues.

Here's some other information:

inglor@tiamat ~$ sudo btrfs filesystem show
Label: 'home'  uuid: 458c70e2-7037-4c4d-bba2-3d5288f04510
    Total devices 1 FS bytes used 9.56GB
    devid    1 size 21.00GB used 10.81GB path /dev/sda3

Label: none  uuid: 699d671b-7064-441d-95ec-c616049fe287
    Total devices 1 FS bytes used 13.94GB
    devid    1 size 20.00GB used 20.00GB path /dev/sda2

Btrfs v0.20-rc1-358-g194aa4a-dirty
inglor@tiamat ~$ df
Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/sda2       20971520  15362816   3960288  80% /
/dev/sda3       22020096  10256168  11375416  48% /home

Thanks,
Leonidas


-- 
Caution: breathing may be hazardous to your health.

#include <stdio.h>
int main(){printf("%s","\x4c\x65\x6f\x6e\x69\x64\x61\x73");}
