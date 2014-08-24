Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f67.google.com ([209.85.216.67]:56078 "EHLO
	mail-qa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaHXJzd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Aug 2014 05:55:33 -0400
Received: by mail-qa0-f67.google.com with SMTP id v10so3939458qac.10
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 02:55:32 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 24 Aug 2014 17:55:32 +0800
Message-ID: <CAGQ70evg4N0dU1-hycjQYbUDUwfnH_akTEcNTtAf=2rjtDU7NA@mail.gmail.com>
Subject: 6+ MiB/s constant usage on a btrfs volume with kernel 3.16
From: Oon-Ee Ng <ngoonee.talk@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm using 64-bit Arch Linux. Since update to kernel versions 3.16 and
3.16.1 I'm getting a constant 6+ MiB/s write on my root. Root does not
seem to fill up though. Has run for 2 hours straight, and obviously
slows everything else down to a crawl.

Downgrading to 3.15.8 (last working version for me) solves the
symptoms. I'm unsure how to check for root causes, and my distro's
mailing list suggested starting here.

btrfs info as shown below, and this dropbox link[1] is a png
printscreen of my iotop and perf top. Please advise.

Btrfs v3.14.2
% btrfs fi show
Label: 'DATA'  uuid: 762a0d46-d88b-4d2a-a4ff-ba9de5ebe993
        Total devices 1 FS bytes used 380.17GiB
        devid    1 size 439.83GiB used 439.83GiB path /dev/sda9

Label: 'HOME'  uuid: 00f91282-ab65-429d-b0f6-2439924755a7
        Total devices 1 FS bytes used 73.03GiB
        devid    1 size 97.66GiB used 97.66GiB path /dev/sda7

Label: 'ROOT'  uuid: 4c860350-eced-4224-a4ec-657576fc54e8
        Total devices 1 FS bytes used 25.49GiB
        devid    1 size 34.18GiB used 34.18GiB path /dev/sda6

Btrfs v3.14.2
% btrfs fi df /
Data, single: total=31.90GiB, used=24.66GiB
System, DUP: total=8.00MiB, used=12.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=1.12GiB, used=853.64MiB
Metadata, single: total=8.00MiB, used=0.00
unknown, single: total=288.00MiB, used=0.00

[1] - https://db.tt/TSh5piq6
