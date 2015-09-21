Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:33791 "EHLO
	mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbbIUOaV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Sep 2015 10:30:21 -0400
Received: by vkgd64 with SMTP id d64so65868044vkg.0
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2015 07:30:21 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 21 Sep 2015 14:30:21 +0000
Message-ID: <CAOTVeoEVxAMHJ8Rw-YfAUmuvNUs3pAcEGgA7bXgOC1fToW9HYQ@mail.gmail.com>
Subject: Btrfs partition gets remounted as read only
From: Incorporeal Waffle <0isavalidnumber@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I tried converting my root partition (originally ext4) to btrfs.

When I booted, I discovered that my root partition is getting
remounted as read only.
I tried to remount it with sudo mount -o remount,rw /
Didn't help. Caused some stuff to appear in dmesg though.
What do?

uname -a; btrfs --version; btrfs fi show; btrfs fi df / ; dmesg
https://mindcraft.si.eu.org/ZeroBin/?7d5c9ba64101c19f#xdhsouft1o7z+j+0dC3c2J5yM8bRuHrPxre/Klf+FWk=
The last part of the dmesg is when I tried to remount it as rw
