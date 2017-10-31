Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:53982 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932344AbdJaQ3L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 12:29:11 -0400
Received: by mail-wm0-f43.google.com with SMTP id r196so24499195wmf.2
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 09:29:11 -0700 (PDT)
Received: from debox (bzq-109-64-142-30.red.bezeqint.net. [109.64.142.30])
        by smtp.gmail.com with ESMTPSA id g49sm1646865edg.71.2017.10.31.09.29.08
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Oct 2017 09:29:09 -0700 (PDT)
Message-ID: <1509467347.1662.40.camel@gmail.com>
Subject: Several questions regarding btrfs
From: ST <smntov@gmail.com>
To: linux-btrfs@vger.kernel.org
Date: Tue, 31 Oct 2017 18:29:07 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I've recently learned about btrfs and consider to utilize for my needs.
I have several questions in this regard:

I manage a dedicated server remotely and have some sort of script that
installs an OS from several images. There I can define partitions and
their FSs.

1. By default the script provides a small separate partition for /boot
with ext3. Does it have any advantages or can I simply have /boot
within / all on btrfs? (Note: the OS is Debian9)

2. as for the / I get ca. following written to /etc/fstab:
UUID=blah_blah /dev/sda3 / btrfs ...
So top-level volume is populated after initial installation with the
main filesystem dir-structure (/bin /usr /home, etc..). As per btrfs
wiki I would like top-level volume to have only subvolumes (at least,
the one mounted as /) and snapshots. I can make a snapshot of the
top-level volume with / structure, but how can get rid of all the
directories within top-lvl volume and keep only the subvolume
containing / (and later snapshots), unmount it and then mount the
snapshot that I took? rm -rf / - is not a good idea...

3. in my current ext4-based setup I have two servers while one syncs
files of certain dir to the other using lsyncd (which launches rsync on
inotify events). As far as I have understood it is more efficient to use
btrfs send/receive (over ssh) than rsync (over ssh) to sync two boxes.
Do you think it would be possible to make lsyncd to use btrfs for
syncing instead of rsync? I.e. can btrfs work with inotify events? Did
somebody try it already?
Otherwise I can sync using btrfs send/receive from within cron every
10-15 minutes, but it seems less elegant.

4. In a case when compression is used - what quota is based on - (a)
amount of GBs the data actually consumes on the hard drive while in
compressed state or (b) amount of GBs the data naturally is in
uncompressed form. I need to set quotas as in (b). Is it possible? If
not - should I file a feature request?

Thank you in advance!


