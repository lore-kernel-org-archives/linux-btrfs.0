Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:44634 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031328AbdIZWp0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 18:45:26 -0400
Received: by mail-vk0-f49.google.com with SMTP id d12so6193981vkf.1
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Sep 2017 15:45:26 -0700 (PDT)
MIME-Version: 1.0
From: Ian Kumlien <ian.kumlien@gmail.com>
Date: Wed, 27 Sep 2017 00:45:04 +0200
Message-ID: <CAA85sZuBVU+Z5L2gwUst1-MdkK8VGM=tHv1cqKho5JGZt5DEjg@mail.gmail.com>
Subject: 4.13.3 still has the out of space kernel oops
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I just had my laptop hit the out of space kernel oops which it kinda
hard to recover from

Everything states "out of disk" even with 20 gigs free (both according
to df and btrfs fi df)

So I'm suspecting that i need to run btrfs check on it to recover the
lost space (i have mounted it with clear_cache and nothing)

The problem is, finally getting a shell with rd.shell rd.break=cmdline
- systemd is still a pain and since it's "udev" it's not allowing me
to do cryptsetup luksopen due to "dependencies"

Basically, btrfs check should be able to run on a ro mounted
fileystem, this is too hard to get working without having to bring a
live usb stick atm

=/
