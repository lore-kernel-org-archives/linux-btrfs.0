Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:50462 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752808AbeD0MXC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 08:23:02 -0400
Received: by mail-it0-f52.google.com with SMTP id p3-v6so1656796itc.0
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 05:23:01 -0700 (PDT)
MIME-Version: 1.0
From: Menion <menion@gmail.com>
Date: Fri, 27 Apr 2018 14:22:40 +0200
Message-ID: <CAJVZm6dj49URCOQYQdmjQ_MH2_WF8i6wzR_Z5Y1-MypBnHBjrQ@mail.gmail.com>
Subject: Optimal maintenance for RAID5 array
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all
I am running a RAID5 array built on 5x8TB HD. The filesystem usage is
aproximatively 6TB now
I rung kernel 4.16.5 and btrfs progs 4.16 (planning to upgrade to
4.16.1) under Ubuntu xenial
I am not sure what is the best/safest way to maintain the array, in
particular which is the best scrub/whatever strategy to apply
The filesystem is 95% used as storage, meaning that few files are
moved around or deleted
Bye
