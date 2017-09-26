Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:46864 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966816AbdIZOlm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 10:41:42 -0400
Received: by mail-qk0-f176.google.com with SMTP id z143so10270014qkb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Sep 2017 07:41:42 -0700 (PDT)
MIME-Version: 1.0
From: Eric Wolf <19wolf@gmail.com>
Date: Tue, 26 Sep 2017 10:41:21 -0400
Message-ID: <CAJ_hD5Dw0H+2c0qztzUc2kEhZZ-PbRTMpzR+R_isQ_S0ph99iQ@mail.gmail.com>
Subject: rm: it is dangerous to operate recursively on '/data/Backup/@' (same
 as '/')
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I accidentally filled my OS drive with a copy of itself? The problem
is, /data/ is a separate pool from the OS drive. And now it looks like
I can't erase it? I don't even know how I got here. All I did was "dd
if=/dev/sda of=/data/Backup/backup-new.img && mv
/data/Backup/backup-new.img /data/Backup/backup.img" I don't really
know where to go from here.
