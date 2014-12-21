Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:42726 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbaLUXlR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Dec 2014 18:41:17 -0500
Received: by mail-qa0-f54.google.com with SMTP id i13so596780qae.27
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Dec 2014 15:41:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <001a11c3dd5e0f76ea050ac2678e@google.com>
References: <CAEtWy5wo07Yey4d8icCeP51saV2wCaCFh+9dMD23oEJ=nhiSUA@mail.gmail.com>
	<001a11c3dd5e0f76ea050ac2678e@google.com>
Date: Sun, 21 Dec 2014 23:41:16 +0000
Message-ID: <CAEtWy5z0rayrK3waAN36uL81PJ1VDSew8AO_5J+2WxK_1qAyRw@mail.gmail.com>
Subject: Fwd: Delivery Status Notification (Failure)
From: Tom <tom.ashley@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

My laptop experienced a loss of power that seems to have caused some kind
of corruption on my /home btrfs partition.

Upon boot, the partition is mounted rw, but as soon as I start accessing
data my /home is remounted ro

uname -a
Linux jackal 3.17.6-1-ARCH #1 SMP PREEMPT Sun Dec 7 23:43:32 UTC 2014
x86_64 GNU/Linux

btrfs --version
Btrfs v3.17.3

btrfs fi show
Label: none  uuid: a5ff01bc-dd6c-4d33-95a4-5caca473f4bc
    Total devices 1 FS bytes used 144.86GiB
    devid    1 size 250.08GiB used 238.04GiB path /dev/sda4

Btrfs v3.17.3


btrfs fi df /home/
Data, single: total=234.01GiB, used=143.67GiB
System, DUP: total=8.00MiB, used=32.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=2.00GiB, used=1.19GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=408.00MiB, used=0.00B



Is there anything obvious in the dmesg that will help me recover this?

Thanks for any help,

Tom
