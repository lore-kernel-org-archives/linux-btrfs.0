Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:38187 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753268AbdGMUt3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 16:49:29 -0400
Received: by mail-wm0-f54.google.com with SMTP id f67so4171376wmh.1
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jul 2017 13:49:28 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 13 Jul 2017 14:49:27 -0600
Message-ID: <CAJCQCtQiCcWZXhXo1nDt0qeGHr=WQH1cs8Syrbc9cXwez8ENjg@mail.gmail.com>
Subject: Containers, Btrfs vs Btrfs + overlayfs
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Has anyone been working with Docker and Btrfs + overlayfs? It seems
superfluous or unnecessary to use overlayfs, but the shared page cache
aspect and avoiding some of the problems with large numbers of Btrfs
snapshots, might make it a useful combination. But I'm not finding
useful information with searches. Typically it's Btrfs alone vs
ext4/XFS + overlayfs.

?

-- 
Chris Murphy
