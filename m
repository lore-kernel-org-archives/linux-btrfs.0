Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:38191 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751737AbdG0Oti (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 10:49:38 -0400
Received: by mail-it0-f45.google.com with SMTP id h199so83573943ith.1
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jul 2017 07:49:38 -0700 (PDT)
MIME-Version: 1.0
From: Alan Brand <alan@georgiabrands.com>
Date: Thu, 27 Jul 2017 10:49:37 -0400
Message-ID: <CAFcRpx4q7N1zG4gz-g6MgkU6c-F_gQ6+2-4ibgm+nyRCp5pTXQ@mail.gmail.com>
Subject: Raid0 rescue
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I know I am screwed but hope someone here can point at a possible solution.

I had a pair of btrfs drives in a raid0 configuration.  One of the
drives was pulled by mistake, put in a windows box, and a quick NTFS
format was done.  Then much screaming occurred.

I know the data is still there.  Is there anyway to rebuild the raid
bringing in the bad disk?  I know some info is still good, for example
metadata0 is corrupt but 1 and 2 are good.
The trees look bad which is probably the killer.

I can't run a normal recovery as only half of each file is there.

$100 reward if you come up with a workable solution.
