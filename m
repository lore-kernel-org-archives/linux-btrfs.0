Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:51897 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab3JWJ7L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Oct 2013 05:59:11 -0400
Received: by mail-vc0-f178.google.com with SMTP id lh4so339825vcb.37
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Oct 2013 02:59:10 -0700 (PDT)
MIME-Version: 1.0
From: Roman Kapusta <roman.kapusta@gmail.com>
Date: Wed, 23 Oct 2013 11:58:50 +0200
Message-ID: <CABVOS0-+MJ7t8=_sRWcmHeWs5T3+yghtDVBwAE3LXz=j_knWFg@mail.gmail.com>
Subject: Soft lockup btrfs-transacti:680
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When I try to umount btrfs filesystem I get always this error with
kernel 3.11.4 and 3.11.3, but I can mount and umount without error on
kernel 3.11.2.

Exact  error messages are:

BUG: soft lockup - CPU#0 stuck for 23s! [btrfs-transacti:680]
BUG: soft lockup  - CPU#1 stuck for 23s! [umount:1575]

I'm on Fedora 19

I have run scrub and there are no errors:
# btrfs scrub status /home
scrub status for xxxx
    scrub started at Tue Oct 22 17:06:16 2013 and finished after 3600 seconds
    total bytes scrubbed: 117.51GB with 0 errors

# btrfs fi df /home
Data: total=124.97GB, used=91.54GB
System, DUP: total=8.00MB, used=20.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=2.50GB, used=372.85MB
Metadata: total=8.00MB, used=0.00

# btrfs fi show
Label: none  uuid: xxxx
    Total devices 1 FS bytes used 91.90GB
    devid    1 size 130.00GB used 130.00GB path /dev/dm-4
Btrfs v0.20-rc1

# df -h /home
Filesystem               Size  Used Avail Use% Mounted on
/dev/mapper/fedora-home  130G   93G   34G  74% /home

fedora kernel packages:
kernel-3.11.2-201.fc19.x86_64.rpm
kernel-3.11.3-201.fc19.x86_64.rpm
kernel-3.11.4-201.fc19.x86_64.rpm
