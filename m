Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:35000 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161287AbdDUXMh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Apr 2017 19:12:37 -0400
Received: by mail-it0-f43.google.com with SMTP id 70so3261898ita.0
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Apr 2017 16:12:36 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id l136sm830416itb.15.2017.04.21.16.12.35
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Apr 2017 16:12:35 -0700 (PDT)
Date: Fri, 21 Apr 2017 23:12:34 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: allow processes with exceed quota with override
Message-ID: <20170421231232.GA3769@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset makes it so that on a per-filesystem basis one can disable
quota enforcement for users with cap_sys_resource. This patchset can
likely later be extended to per-qgroup, or a per-volume basis. I'm
thinking of extending the sysfs interface to list the qgroups and
this same interface for the qgroups themselves.

Sargun Dhillon (2):
  btrfs: add quota override attribute
  btrfs: Add quota_override knob into sysfs

 fs/btrfs/ctree.h  |  3 +++
 fs/btrfs/qgroup.c |  9 +++++++--
 fs/btrfs/sysfs.c  | 36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 2 deletions(-)

-- 
2.9.3

