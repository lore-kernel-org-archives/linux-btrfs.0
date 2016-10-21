Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:34755 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934570AbcJUWDR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Oct 2016 18:03:17 -0400
Received: by mail-yw0-f182.google.com with SMTP id w3so117298657ywg.1
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Oct 2016 15:03:17 -0700 (PDT)
MIME-Version: 1.0
From: Gareth Pye <gareth@cerberos.id.au>
Date: Sat, 22 Oct 2016 09:03:16 +1100
Message-ID: <CA+WRLO-XY2aai7z8436yna14cjbRsPrWgHwxbcf5Kq_-7RENCQ@mail.gmail.com>
Subject: Drive Replacement
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've got a BTRFS array that is of mixed size disks:
2x750G
3x1.5T
3x3T
And it's getting fuller than I'd like. The problem is that adding
disks is harder than one would like as the computer only has 8 sata
ports. Is it viable to do the following to upgrade one of the disks?

A) Take array offline
B) DD the contents of one of the 750G drives to a new 3T drive
C) Remove the 750G from the system
D) btrfs scan
E) Mount array
F) Run a balance

I know that not physically removing the old copy of the drive will
cause massive issues, but if I do that everything should be fine
right?

-- 
Gareth Pye - chatterofjudges.mtgmelb.com
Level 2 MTG Judge, Melbourne, Australia
