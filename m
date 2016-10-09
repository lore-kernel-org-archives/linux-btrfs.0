Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:36002 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751991AbcJIRvx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Oct 2016 13:51:53 -0400
Received: by mail-lf0-f46.google.com with SMTP id b75so84522031lfg.3
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Oct 2016 10:51:52 -0700 (PDT)
MIME-Version: 1.0
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Sun, 9 Oct 2016 23:21:10 +0530
Message-ID: <CAKuJGC8oPG=oO98SKg+DwLeyPanGHdGxGxaUAW0ekhM7hE4dnw@mail.gmail.com>
Subject: btrfs-convert: migrating files with flags set using chattr
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

Looks like btrfs-progs/btrfs-convert doesn't retain file attributes
like immutable flags, is this expected behavior ?

//  test.img is ext2
[root@ mnt]# touch a b
[root@ mnt]# chattr +a a
[root@ mnt]# chattr +i b
[root@ mnt]# lsattr a b
-----a---------- a
----i----------- b


// after btrfs-convert  test.img

[root@ mnt]# lsattr a b
---------------- a
---------------- b



----
Cheers,
Lakshmipathi.G
