Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:36383 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750851AbcHTEA7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Aug 2016 00:00:59 -0400
Received: by mail-ua0-f169.google.com with SMTP id 97so110699753uav.3
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Aug 2016 21:00:59 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?QmVhcmNhdCDFnsOhbmRvcg==?= <bearcatsandor@gmail.com>
Date: Fri, 19 Aug 2016 22:00:17 -0600
Message-ID: <CAMPo9spd+GF18K7sDZDsfvqLQJYwt_YuYM_05KOnVFmw_Vsrhw@mail.gmail.com>
Subject: Mixing partitioned and non-partitioned discs in a RAID?
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a btrfs non-raid file system that i'd like to convert to
raid10. This single device has my efi boot partion on it, so it's
partitioned into sda1 and sda2. I have 3 other discs (sdc-sde) that
i'd like to make partition-less systems and then add them to the first
disc (sda) using the steps in the conversion section of the wiki
(https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Conversion).

My concern in that i'll be mixing a partitioned and partition-less
system.  Will that work or will i hose myself?

Thank you

Bearcat
