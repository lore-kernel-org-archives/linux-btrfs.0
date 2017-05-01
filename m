Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33268 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751255AbdEAPsG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 May 2017 11:48:06 -0400
Received: by mail-io0-f193.google.com with SMTP id k87so22712161ioi.0
        for <linux-btrfs@vger.kernel.org>; Mon, 01 May 2017 08:48:06 -0700 (PDT)
Received: from [192.168.0.23] ([98.4.97.1])
        by smtp.gmail.com with ESMTPSA id e81sm6525149ioe.18.2017.05.01.08.17.49
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 01 May 2017 08:17:49 -0700 (PDT)
Message-ID: <5907519C.2020204@gmail.com>
Date: Mon, 01 May 2017 11:17:48 -0400
From: "J. Hart" <jfhart085@gmail.com>
Reply-To: jfhart085@gmail.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: re: ERROR: rename o3528-7220-0 -> usr failed: Directory not empty
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've got more information on the following error :

At subvol /mnt/ArchPri/backup/primary/thinkcentre/root/backup.0.2
At snapshot backup.0.2017.04.21.03.11.40
ERROR: rename o3528-7220-0 -> usr failed: Directory not empty

I've filed a bug report with additional details at:

https://bugzilla.kernel.org/show_bug.cgi?id=195619

This error occurs during a series of "btrfs send" invocations.  It does 
not occur on all of them, but always at the same point in the operation, 
and so appears to be specific to (dependent on) the data being sent.

I have a test case down to the following:

su -
btrfs send --no-data temp/backup.0.2017.04.17.07.57.17 | btrfs rec temp/test
sync
btrfs send --no-data -p temp/backup.0.2017.04.17.07.57.17 
temp/backup.0.2017.04.21.03.11.40 | btrfs rec temp/test

The error should be something like:
At subvol temp/backup.0.2017.04.21.03.11.40
At snapshot backup.0.2017.04.21.03.11.40
ERROR: rename o3528-7220-0 -> usr failed: Directory not empty

I will probably need to provide the data somehow, or at least the output 
from "btrfs send".  The original data is several GB in size.

J. Hart

