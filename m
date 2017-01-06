Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:33113 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755106AbdAFLfq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jan 2017 06:35:46 -0500
Received: by mail-qk0-f172.google.com with SMTP id s140so48933643qke.0
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Jan 2017 03:35:46 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?B?RnJlZHJpayDDlmhyc3Ryw7Zt?= <oehrstroem@gmail.com>
Date: Fri, 6 Jan 2017 12:35:15 +0100
Message-ID: <CALZT+jC-+Q-kEMVQEDoX5SqQwpqMoXMoW9MVBpmkBObjHjr74Q@mail.gmail.com>
Subject: Question about nano second timestamps on files in btrfs
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It seems like the nano seconds that are stored in for example mtime
are snapshots of a nano second counter, taken at certain intervals,
much more seldom than one would expect.

For example, a bash script with:

echo HELLO > a.txt
do some bashy loops and echos
echo  HELLO > b.txt

at least on my btrfs/linux installation, you can do a lot of bashy
loops and stuff between
the two echos, and still a.txt and b.txt get the same nano second mtime.

Does anyone one why this is the case?

Thanks!

//Fredrik

Linux qi 4.4.0-45-generic #66-Ubuntu SMP Wed Oct 19 14:12:37 UTC 2016
x86_64 x86_64 x86_64 GNU/Linux
