Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:50854 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751060AbdKFWhW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 17:37:22 -0500
Received: by mail-oi0-f43.google.com with SMTP id q4so8751137oic.7
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Nov 2017 14:37:22 -0800 (PST)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 6 Nov 2017 15:37:21 -0700
Message-ID: <CAJCQCtSY+nso=URaU+2-qN2EWrxA7m1djcWhUAJTmjxW0yGa8Q@mail.gmail.com>
Subject: Should cp default to reflink?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm doing copies from one subvolume to another, through a mounted top
level (id5) at /mnt/int.

This copies the whole file conventionally (no shared extents)
$ sudo cp /mnt/int/home/chris/Downloads/Fedora-Server-dvd-x86_64-27-1.6.iso
/mnt/int/root00/var/lib/libvirt/images/

This is a reflink copy
$ sudo cp --reflink
/mnt/int/home/chris/Downloads/Fedora-Server-dvd-x86_64-27-1.6.iso
/mnt/int/root00/var/lib/libvirt/images/

This is also a refink copy, with the original removed.
$ sudo mv /mnt/int/home/chris/Downloads/Fedora-Server-dvd-x86_64-27-1.6.iso
/mnt/int/root00/var/lib/libvirt/images/

Seems to me any request to duplicate should be optimized by default
with an auto reflink when possible, and require an explicit option to
inhibit.


-- 
Chris Murphy
