Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33988 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbcGDW7n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jul 2016 18:59:43 -0400
Received: by mail-oi0-f46.google.com with SMTP id s66so208780402oif.1
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 15:59:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTPaxWBkmX=ADY7oh5bFjvODmuUNiGXtcBCfxw-c646LA@mail.gmail.com>
References: <cc4fd464-271c-6b32-263c-ae91c19b8712@gmail.com>
 <CAJCQCtQoCtbt5NrggHPp+WrwUKbJ0nah4s6nJ0mPnKsGQ5i63Q@mail.gmail.com>
 <95f58623-95a4-b5d2-fa3a-bfb957840a31@gmail.com> <CAJCQCtSczHoBYyKB1DTyqGngdvC+BHtnXeZiG=1QHWkAWFO6EA@mail.gmail.com>
 <dc944146-50ce-b2fd-189c-a2c9f5a957c3@gmail.com> <CAJCQCtTPXY7=9vi9Ai2VrCEHzsEj_J0gurAVH5JGLJYmKmUpPw@mail.gmail.com>
 <6253136e-51bd-29cc-e8d2-d2cf9a6a0aef@gmail.com> <CAJCQCtTPaxWBkmX=ADY7oh5bFjvODmuUNiGXtcBCfxw-c646LA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 4 Jul 2016 16:59:41 -0600
Message-ID: <CAJCQCtRBQMZrAdY5zzbbgzvJ7VuK7BePmMKw_QzZBBeJsBjhAw@mail.gmail.com>
Subject: Re: Unable to mount degraded RAID5
To: Chris Murphy <lists@colorremedies.com>
Cc: =?UTF-8?B?VG9tw6HFoSBIcmRpbmE=?= <thomas.rkh@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just tried btrfs rescue chunk-recover (btrfs-progs 4.6) on new
Btrfs, 3x raid5 with 1 dev missing. I get:

[root@f24s ~]# btrfs rescue chunk-recover /dev/VG/2
Scanning: DONE in dev0, DONE in dev1
open with broken chunk error
Chunk tree recovery failed

So I don't think rescue chunk-recover can work degraded. At least,
it's not working now, and if it isn't meant to work it probably should
fail before it does the scanning, which takes a long time. I filed a
bug:
https://bugzilla.kernel.org/show_bug.cgi?id=121471

But in my case things still continue to work with btrfs-find-tree and
degraded mount works OK, so off hand I don't think the rescue
chunk-recover made things worse.



-- 
Chris Murphy
