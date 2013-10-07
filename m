Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39223 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab3JGHZB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 03:25:01 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 00/12] enhance btrfs qgroup show command
Date: Mon, 7 Oct 2013 15:21:36 +0800
Message-Id: <1381130508-8458-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset enhanced btrfs qgroup show command.

Firstly, we restructure show_qgroups, make it easy to add new features.
And then we add '-p' '-c', '-r',and '-e' options to print the parent
qgroup id, child qgroup id, max referenced size and max exclusive size
of qgroup respectively, add '-F' and '-f' option to list qgroups that
impact the given path.

Besides that, the users may want to sort qgroups according to some items.
For this case, we introduce '--sort' option. With this option, we can sort
the qgroup by qgroupid, rfer, excl, max_rfer and max_excl.

Notice, we force to print result as a table(as david suggest this dosen't matter
for now), and with option '--block-size', user can control to print result,for example,
k,K,m,M,etc.What's more '-h' gives a short cut to allow people to print result in
human readable format size.

You can pull this patchset from the URL:
	git://github.com/wangshilong/Btrfs-progs.git qgroup_v2

This patchset is rebased on david's intergration-20130924.

Changelog:
v2->v3:
	mainly address comments from david.
	1)print result as table in default.
	2)add '--block-size' option
	3)add '-h' option to print size in human readable format.
	4)replace '-l' with '-r' to print max referenced size.
	5)some codes cleanups.
v1->v2:
	rebase the patchset on david's integration-20130920

Wang Shilong (12):
  Btrfs-progs: restructure show_qgroups
  Btrfs-progs: introduces '-p' option to print the ID of the parent
    qgroups
  Btrfs-progs: introduces '-c' option to print the ID of the child
    qgroups
  Btrfs-progs: introduce '-r' option to print max referenced size of
    qgroups
  Btrfs-progs: introduce '-e' option to print max exclusive size of
    qgroups
  Btrfs-progs: list all qgroups impact given path(include ancestral
    qgroups)
  Btrfs-progs: list all qgroups impact given path(exclude ancestral
    qgroups)
  Btrfs-progs: enhance btrfs qgroup show to sort qgroups
  Btrfs-progs: enhance btrfs qgroup to print the result as a table
  Btrfs-progs: add '--block-size' option to control print result
  Btrfs-progs: make pretty_size_snprintf() return len
  Btrfs-progs: add '-h' options to print sizes in human readable format

 cmds-qgroup.c |  197 ++++-----
 ctree.h       |   11 +
 qgroup.c      | 1286 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 qgroup.h      |   73 ++++
 utils.c       |   59 ++-
 utils.h       |    6 +-
 6 files changed, 1532 insertions(+), 100 deletions(-)

-- 
1.8.3.1

