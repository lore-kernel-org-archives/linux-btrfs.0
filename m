Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:43765 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab3IWGUF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 02:20:05 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8N6K2iL012946
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 14:20:02 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/9] enhance btrfs qgroup show command
Date: Mon, 23 Sep 2013 14:17:19 +0800
Message-Id: <1379917048-9720-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset enhanced btrfs qgroup show command.

Firstly, we restructure show_qgroups, make it easy to add new features.
And then we add '-p' '-c', '-l',and '-e' options to print the parent
qgroup id, child qgroup id, max referenced size and max exclusive size
of qgroup respectively, add '-F' and '-f' option to list qgroups that
impact the given path.

Besides that, the users may want to sort qgroups according to some items.
For this case, we introduce '--sort' option. With this option, we can sort
the qgroup by qgroupid, rfer, excl, max_rfer and max_excl.

And finally, Since there are so many columns can be output, the users may
be confused about the output result, so i add '-t' option to print the result
as a table.

You can pull this patchset from the URL:
	git://github.com/wangshilong/Btrfs-progs.git qgroup

Changelog v1->v2:
	rebase the patchset on david's integration-20130920

Wang Shilong (9):
  Btrfs-progs: restructure show_qgroups
  Btrfs-progs: introduces '-p' option to print the ID of the parent
    qgroups
  Btrfs-progs: introduces '-c' option to print the ID of the child
    qgroups
  Btrfs-progs: introduce '-l' option to print max referenced size of
    qgroups
  Btrfs-progs: introduce '-e' option to print max exclusive size of
    qgroups
  Btrfs-progs: list all qgroups impact given path(include ancestral
    qgroups)
  Btrfs-progs: list all qgroups impact given path(exclude ancestral
    qgroups)
  Btrfs-progs: enhance btrfs qgroup show to sort qgroups
  Btrfs-progs: enhance btrfs qgroup to print the result as a table

 cmds-qgroup.c |  190 ++++-----
 ctree.h       |   11 +
 qgroup.c      | 1218 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 qgroup.h      |   71 ++++
 4 files changed, 1396 insertions(+), 94 deletions(-)

-- 
1.8.3.1

