Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78898C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 05:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A966208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 05:31:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A966208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jp.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbeK0Q2T (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 11:28:19 -0500
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:47094 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbeK0Q2S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 11:28:18 -0500
Received: from yt-mxoi1.gw.nic.fujitsu.com (unknown [192.168.229.67]) by mgwym04.jp.fujitsu.com with smtp
         id 548b_2c25_16f20bcc_6792_4e56_a288_d14eacc36ce3;
        Tue, 27 Nov 2018 14:20:24 +0900
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 1E5FDAC0147
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 14:20:23 +0900 (JST)
Received: from g01jpexchyt37.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 77D0A6D656B
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 14:20:22 +0900 (JST)
Received: from luna3.soft.fujitsu.com (10.124.196.199) by
 g01jpexchyt37.g01.fujitsu.local (10.128.193.67) with Microsoft SMTP Server id
 14.3.352.0; Tue, 27 Nov 2018 14:20:22 +0900
From:   Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
Subject: [PATCH RESEND 0/8] btrfs-progs: sub: Relax the privileges of "subvolume list/show"
Date:   Tue, 27 Nov 2018 14:24:41 +0900
Message-ID: <cover.1543294426.git.misono.tomohiro@jp.fujitsu.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-MML: disable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

This is basically the resend of 
  "[PATCH v2 00/20] btrfs-progs: Rework of "subvolume list/show" and relax the
	root privileges of them" [1]
which I submitted in June. The aim of this series is to allow non-privileged user
to use basic subvolume functionality (create/list/snapshot/delete; this allows "list")

They were once in devel branch with some whitespace/comment modification by david.
I rebased them to current devel branch.

github: https://github.com/t-msn/btrfs-progs/tree/rework-sub-list

Basic logic/code is the same as before. Some differences are:
 - Use latest libbtrfsutil from Omar [2] (thus drop first part of patches).
   As a result, "sub list" cannot accept an ordinary directry to be
   specified (which is allowed in previous version)
 - Drop patches which add new options to "sub list"
 - Use 'nobody' as non-privileged test user just like libbtrfsutil test
 - Update comments

Importantly, in order to make output consistent for both root and non-privileged
user, this changes the behavior of "subvolume list": 
 - (default) Only list in subvolume under the specified path.
   Path needs to be a subvolume.
 - (-a) filter is dropped. i.e. its output is the same as the
        default behavior of "sub list" in progs <= 4.19

Therefore, existent scripts may need to update to add -a option
(I believe nobody uses current -a option).
If anyone thinks this is not good, please let me know.

Behavior summary from cover letter in [1]
====
* Behavior summary of new "sub list"
  - default (no option)
    - lists subvolumes below the specified path (inc. path itself)
    - If new ioctls exists non-privileged user can call it
        (subvolumes to which the user cannot access will be skipped)

  - -a
    - updated to remove filter. i.e. the output is the same as current progs
      without option (require root privileges)

 [Example]
  $ mkfs.btrfs -f $DEV
  $ mkfs.btrfs -f $DEV2
  $ mount $DEV $MNT

  $ btrfs subvolume create $MNT/AAA
  $ btrfs subvolume create $MNT/BBB
  $ btrfs subvolume create $MNT/CCC
  $ btrfs subvolume create $MNT/DDD
  $ mkdir $MNT/AAA/bbb
  $ mkdir $MNT/AAA/ccc
  $ mkdir $MNT/AAA/other

  $ umount $MNT
  $ mount -o subvol=AAA $DEV $MNT
  $ mount -o subvol=BBB $DEV $MNT/bbb
  $ mount -o subvol=CCC $DEV $MNT/ccc
  $ mount -o $DEV2 $MNT/other

  $ btrfs subvolume list $MNT # print subvolumes below the path
  ID 256 gen 10 top level 5 path .

  $ btrfs subvolume list -a $MNT
  # print all subvolumes in the fs. the same output as progs<=4.19 without option
  ID 256 gen 10 top level 5 path AAA
  ID 258 gen 7 top level 5 path BBB
  ID 259 gen 8 top level 5 path CCC
  ID 260 gen 9 top level 5 path DDD

* Behavior summary of new "sub show"
  - No change for root's output
  - If new ioctls exists, non-privileged user can call it
    - In that case, path to be shown is absolute path
      (for root, it is relative to top-level subvolume)
      Also, snapshots to be shown are to which the user can access from current
			mount point.
      (for root, all snapshots in the fs)
===

[1] https://lore.kernel.org/linux-btrfs/cover.1529310485.git.misono.tomohiro@jp.fujitsu.com/
[2] https://lore.kernel.org/linux-btrfs/cover.1542181521.git.osandov@fb.com/

Thanks,
Misono

Misono Tomohiro (8):
  btrfs-progs: sub list: Use libbtrfsuitl for subvolume list
  btrfs-progs: sub list: factor out main part of btrfs_list_subvols
  btrfs-progs: sub list: Change the default behavior of "subvolume list"
    and allow non-privileged user to call it
  btrfs-progs: sub list: Update -a option and remove meaningless filter
  btrfs-progs: utils: Fallback to open without O_NOATIME flag in
    find_mount_root():
  btrfs-progs: sub show: Allow non-privileged user to call "subvolume
    show"
  btrfs-progs: test: Add helper function to check if test user exists
  btrfs-porgs: test: Add cli-test/009 to check subvolume list for both
    root and normal user

 Documentation/btrfs-subvolume.asciidoc     |   25 +-
 cmds-subvolume.c                           | 1149 +++++++++++++++++++-
 tests/cli-tests/009-subvolume-list/test.sh |  130 +++
 tests/common                               |   10 +
 utils.c                                    |    3 +
 5 files changed, 1266 insertions(+), 51 deletions(-)
 create mode 100755 tests/cli-tests/009-subvolume-list/test.sh

-- 
2.19.1


