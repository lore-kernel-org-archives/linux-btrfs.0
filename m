Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:34188 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753545AbdCBAhI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Mar 2017 19:37:08 -0500
Received: by mail-yw0-f179.google.com with SMTP id p77so46007820ywg.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Mar 2017 16:37:07 -0800 (PST)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 1 Mar 2017 17:30:37 -0700
Message-ID: <CAJCQCtQByC_pTnZhFFfHmxktN-Ga4W0TZ8wVRPxe_b18G+Kajw@mail.gmail.com>
Subject: raid1 degraded mount still produce single chunks, writeable mount not allowed
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[1717713.408675] BTRFS warning (device dm-8): missing devices (1)
exceeds the limit (0), writeable mount is not allowed
[1717713.446453] BTRFS error (device dm-8): open_ctree failed

[chris@f25s ~]$ uname -r
4.9.8-200.fc25.x86_64

I thought this was fixed. I'm still getting a one time degraded rw
mount, after that it's no longer allowed, which really doesn't make
any sense because those single chunks are on the drive I'm trying to
mount. I don't understand what problem this proscription is trying to
avoid. If it's OK to mount rw,degraded once, then it's OK to allow it
twice. If it's not OK twice, it's not OK once.


-- 
Chris Murphy
