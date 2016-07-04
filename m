Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35953 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbcGDTB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jul 2016 15:01:58 -0400
Received: by mail-oi0-f45.google.com with SMTP id f189so203916031oig.3
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 12:01:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <95f58623-95a4-b5d2-fa3a-bfb957840a31@gmail.com>
References: <cc4fd464-271c-6b32-263c-ae91c19b8712@gmail.com>
 <CAJCQCtQoCtbt5NrggHPp+WrwUKbJ0nah4s6nJ0mPnKsGQ5i63Q@mail.gmail.com> <95f58623-95a4-b5d2-fa3a-bfb957840a31@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 4 Jul 2016 13:01:57 -0600
Message-ID: <CAJCQCtSczHoBYyKB1DTyqGngdvC+BHtnXeZiG=1QHWkAWFO6EA@mail.gmail.com>
Subject: Re: Unable to mount degraded RAID5
To: =?UTF-8?B?VG9tw6HFoSBIcmRpbmE=?= <thomas.rkh@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 4, 2016 at 12:54 PM, Tomáš Hrdina <thomas.rkh@gmail.com> wrote:
> Degraded gives same result:
>
> sudo mount -t btrfs -o ro,degraded /dev/sda /shares
> mount: wrong fs type, bad option, bad superblock on /dev/sda,
>        missing codepage or helper program, or other error
>
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
>

That's bad. What are the kernel messages for the mount attempt?

Do the following and report back all the results.

# btrfs dev scan
# btrfs fi show
# blkid
# btrfs check /dev/sda


Also, make sure you reply to the btrfs list also and not just to me
personally. And also don't top post or it'll annoy some people on the
list.


-- 
Chris Murphy
