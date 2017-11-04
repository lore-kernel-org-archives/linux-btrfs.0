Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f171.google.com ([74.125.82.171]:45521 "EHLO
        mail-ot0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751970AbdKDAPz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Nov 2017 20:15:55 -0400
Received: by mail-ot0-f171.google.com with SMTP id q99so4061537ota.2
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Nov 2017 17:15:55 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 3 Nov 2017 18:15:53 -0600
Message-ID: <CAJCQCtSf1mX0kWCRjfSTwZKwZC6mMN7Vdio0LJdCCY96ifte4g@mail.gmail.com>
Subject: updatedb does not index /home when /home is Btrfs
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ancient bug, still seems to be a bug.
https://bugzilla.redhat.com/show_bug.cgi?id=906591

The issue is that updatedb by default will not index bind mounts, but
by default on Fedora and probably other distros, put /home on a
subvolume and then mount that subvolume which is in effect a bind
mount.

There's a lot of early discussion in 2013 about it, but then it's
dropped off the radar as nobody has any ideas how to fix this in
mlocate.


-- 
Chris Murphy
