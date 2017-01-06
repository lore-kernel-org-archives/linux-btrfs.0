Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58403 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbdAFRWi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jan 2017 12:22:38 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
Subject: [Regression 4.7-rc1] btrfs: bugfix: handle
 FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
To: luke@dashjr.org
Cc: luke-jr+git@utopios.org, jbacik@fb.com, dsterba@suse.com, dsterba@suse.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org, clm@fb.com,
        jbacik@fb.com, linux-btrfs@vger.kernel.org, 1619918@bugs.launchpad.net
Message-ID: <a555bec3-f0c8-b973-52e0-02bc2e3b5b29@canonical.com>
Date: Fri, 6 Jan 2017 12:22:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Luke,

A kernel bug report was opened against Ubuntu [0].  This bug was fixed
by the following commit in v4.7-rc1:


commit 4c63c2454eff996c5e27991221106eb511f7db38

Author: Luke Dashjr <luke@dashjr.org>
Date:   Thu Oct 29 08:22:21 2015 +0000

    btrfs: bugfix: handle FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in
btrfs_ioctl


However, this commit introduced a new regression.  With this commit
applied, "btrfs fi show" no longer works and the btrfs snapshot
functionality breaks.



I was hoping to get your feedback, since you are the patch author.  Do
you think gathering any additional data will help diagnose this issue,
or would it be best to submit a revert request?


Thanks,

Joe


[0] http://pad.lv/1619918


