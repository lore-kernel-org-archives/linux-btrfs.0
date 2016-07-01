Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36368 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbcGAPNU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jul 2016 11:13:20 -0400
Received: by mail-wm0-f46.google.com with SMTP id f126so30509469wma.1
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jul 2016 08:12:52 -0700 (PDT)
MIME-Version: 1.0
From: Grey Christoforo <grey@christoforo.net>
Date: Fri, 1 Jul 2016 16:12:21 +0100
Message-ID: <CADbsYN2RZ9q7pFSawEkWbTXvomAONz60t7b1Hm6f7Mma=veKgQ@mail.gmail.com>
Subject: btrfs lockup
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

My machine locked up and I noticed this[1] in my dmesg. I figured I'd
report it here. I *think* this is related to the numerous btrfs
subvolumes that docker has created on my system. The lockup occurred
when gnome's baobab[2] was scanning my
/var/lib/docker/btrfs/subvolumes folder.

Cheers,
¬grey

[1]: https://gist.github.com/greyltc/5a9198f402e4e9b9895af0b2a3ead375
[2]: https://wiki.gnome.org/Apps/Baobab
