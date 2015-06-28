Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:35888 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbbF1Su6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Jun 2015 14:50:58 -0400
Received: by ykdr198 with SMTP id r198so98161000ykd.3
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jun 2015 11:50:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+xOVSMjO0e5TPfksr=TmnT9zc5=hJemYPtn_tg+xxsWbFMV=A@mail.gmail.com>
References: <CA+xOVSOD1YY-=Cm+vmzTUV9cHe9idtDkRr0RmpRP5a0Z6eC4YQ@mail.gmail.com>
 <CA+xOVSNu547eo6TY_mwLypTGWuE5AmyMqC6GwR06Sir1282vqA@mail.gmail.com>
 <CAJCQCtSv15DVDju7vhm=Luc5hqWvce__F7iovh87uxq37bNg0Q@mail.gmail.com> <CA+xOVSMjO0e5TPfksr=TmnT9zc5=hJemYPtn_tg+xxsWbFMV=A@mail.gmail.com>
From: Noah Massey <noah.massey@gmail.com>
Date: Sun, 28 Jun 2015 14:50:18 -0400
Message-ID: <CADfjVrhmUhWAs0+6_s-hDcoLyrXdvkY1fZgoKv2VRDt2F8MWhQ@mail.gmail.com>
Subject: Re: btrfs replace seems to corrupt the file system
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 28, 2015 at 2:02 PM, Mordechay Kaganer <mkaganer@gmail.com> wrote:
> To recover the old device, that's what i'm trying to do. Asked on IRC
> also, no reply. As stated above, the device passes btrfs check without
> errors but cannot mount because it complains about "ongoing replace"
> and the replace device is missing.

Standard disclaimer, not a dev, just a user.
The following worked for me to recover the old device after
reproducing your situation:
(where loop0 is my "old" device)

# mount -t btrfs -o degraded /dev/loop0 /mnt
# btrfs replace cancel /mnt
# btrfs umount /mnt
# mount -t btrfs /dev/loop0 /mnt

mount now succeeds without error.

$ uname -r
4.1.0
$ btrfs version
btrfs-progs v4.1
