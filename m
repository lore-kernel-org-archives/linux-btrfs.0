Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53140 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751465AbdBBRii (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Feb 2017 12:38:38 -0500
To: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
From: Joseph Salisbury <joseph.salisbury@canonical.com>
Subject: Subject: [REVERT][v4.x.y] btrfs: bugfix: handle
 FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
Cc: luke@dashjr.org, jbacik@fb.com, dsterba@suse.com, clm@fb.com,
        jbacik@fb.com, linux-btrfs@vger.kernel.org, 1619918@bugs.launchpad.net
Message-ID: <c5c953d1-c276-daec-faf4-4115827dd381@canonical.com>
Date: Thu, 2 Feb 2017 12:38:33 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Please consider reverting commit
4c63c2454eff996c5e27991221106eb511f7db38 in the next v4.x.y release.  It
was included upstream as of v4.7-rc1  This commit introduced a
regression, described in the following bug:
http://bugs.launchpad.net/bugs/1619918

This new regression was discussed in the following thread:

https://lkml.org/lkml/2017/1/6/467


Sincerely,

Joseph Salisbury


