Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:36014 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756039AbcIZUPO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 16:15:14 -0400
Received: by mail-qk0-f180.google.com with SMTP id z190so180268977qkc.3
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Sep 2016 13:15:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+Fk0XLfXVaMVTKyovwedBAAAMhpoiuF2b1yuAPbxsOQrkR3=A@mail.gmail.com>
References: <CA+Fk0XLfXVaMVTKyovwedBAAAMhpoiuF2b1yuAPbxsOQrkR3=A@mail.gmail.com>
From: Ruben Salzgeber <ruben.salzgeber@gmail.com>
Date: Mon, 26 Sep 2016 22:15:11 +0200
Message-ID: <CA+Fk0XKZbf1wamCuT7AZPNVOTmapyr-e9ACnjJ0kqzav561ysA@mail.gmail.com>
Subject: Fwd: OS X Time Machine and BTRFS
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone

I'm reaching out to you because I experience unusually slow read and
write speeds on my Arch Linux server in combination with OS X time
machine. My setup is consists of an Core i3 6300, 16GB Ram, 128GB SSD
for the OS and a 8 drive RAID5 BTRFS volume as archive. The latest
version of Avahi, Netatalk and BTRFS-Progs are installed. On a wired
connection I reach 120MB/s for normal filetransfers from OS X to the
Server. When using Time Machine I measure peak network trafic around
1-2MB/s and long durations of almost no trafic. Could this be in any
relation to BTRFS? Is there a special configuration necessary for
folders containing the Time Machine sparsebundle file?

Hope hear from you, kind regards

Ruben
