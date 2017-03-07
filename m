Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35866 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751949AbdCGRSA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 12:18:00 -0500
Received: by mail-wm0-f50.google.com with SMTP id n11so95382967wma.1
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Mar 2017 09:16:41 -0800 (PST)
MIME-Version: 1.0
From: Chad Walker <chad@chad-cat-lore-eddie.com>
Date: Tue, 7 Mar 2017 11:16:39 -0600
Message-ID: <CAOcw3LkKwnxgt0quH=A+wpm5zamQGUnnSGrCcboCYE_nuMgjww@mail.gmail.com>
Subject: raid6 volume stuck in replace
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, I know that raid5/6 is experimental. I have a volume that I can
mount read-only but not read-write that is stuck in a replace. I've
put a bunch of info into this pastebin: http://pastebin.com/1SQuRGet

Since then I have updated to kernel 4.10.1 and btrfs-progs to 4.9.1,
same issue. It seems that since it can mount it read-only, I should be
able to fix the problem and get it mounted read-write.

-chad
