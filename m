Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:36136 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbcGDWmS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jul 2016 18:42:18 -0400
Received: by mail-oi0-f48.google.com with SMTP id f189so208708599oig.3
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 15:42:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6253136e-51bd-29cc-e8d2-d2cf9a6a0aef@gmail.com>
References: <cc4fd464-271c-6b32-263c-ae91c19b8712@gmail.com>
 <CAJCQCtQoCtbt5NrggHPp+WrwUKbJ0nah4s6nJ0mPnKsGQ5i63Q@mail.gmail.com>
 <95f58623-95a4-b5d2-fa3a-bfb957840a31@gmail.com> <CAJCQCtSczHoBYyKB1DTyqGngdvC+BHtnXeZiG=1QHWkAWFO6EA@mail.gmail.com>
 <dc944146-50ce-b2fd-189c-a2c9f5a957c3@gmail.com> <CAJCQCtTPXY7=9vi9Ai2VrCEHzsEj_J0gurAVH5JGLJYmKmUpPw@mail.gmail.com>
 <6253136e-51bd-29cc-e8d2-d2cf9a6a0aef@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 4 Jul 2016 16:42:16 -0600
Message-ID: <CAJCQCtTPaxWBkmX=ADY7oh5bFjvODmuUNiGXtcBCfxw-c646LA@mail.gmail.com>
Subject: Re: Unable to mount degraded RAID5
To: =?UTF-8?B?VG9tw6HFoSBIcmRpbmE=?= <thomas.rkh@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 4, 2016 at 3:10 PM, Tomáš Hrdina <thomas.rkh@gmail.com> wrote:

> http://sebsauvage.net/paste/?39c73a3440b2e903#WZnUJXNFPNz/fFuOK3QquVeOWQUopcCl0JabtuYMWew=


Both backup 0 and 1 have bad information for backup_fs_root.

backup_fs_root: 0 gen: 0 level: 0

Presumably it automatically tries backup 2 or 3 even though they have
older generations but I'm not sure.


> sudo btrfs-find-root /dev/sda
> warning, device 3 is missing
> Couldn't read chunk tree
> ERROR: open ctree failed

I'm gonna guess the system chunk is bad or damaged somehow and
therefore there's no way to get to the chunk tree. What do you get
for:

# btrfs-debug-tree -d /dev/sda



-- 
Chris Murphy
