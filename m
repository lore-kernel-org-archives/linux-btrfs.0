Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:34047 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932232Ab2LFJn1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Dec 2012 04:43:27 -0500
Message-ID: <50C068D4.6020105@cn.fujitsu.com>
Date: Thu, 06 Dec 2012 17:43:48 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Arne Jansen <sensille@gmx.net>
Subject: [PATCH 0/9] enhance btrfs qgroup show command
Content-Type: text/plain; charset=UTF-8
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

We can pull this patchset from the URL

	git://github.com/miaoxie/btrfs-progs.git qgroup

Thanks
Miao
---
Wang Shilong (9):
      Btrfs-progs: restructure show_qgroups
      Btrfs-progs: introduces '-p' option to print the ID of the parent qgroups
      Btrfs-progs: introduces '-c' option to print the ID of the child qgroups
      Btrfs-progs: introduce '-l' option to print max referenced size of qgroups
      Btrfs-progs: introduce '-e' option to print max exclusive size of qgroups
      Btrfs-progs: list all qgroups impact given path(include ancestral qgroups)
      Btrfs-progs: list all qgroups impact given path(exclude ancestral qgroups)
      Btrfs-progs: enhance btrfs qgroup show to sort qgroups
      Btrfs-progs: enhance btrfs qgroup to print the result as a table

 cmds-qgroup.c |  198 +++++-----
 ctree.h       |   11 +
 qgroup.c      | 1216 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 qgroup.h      |   71 ++++
 4 files changed, 1396 insertions(+), 100 deletions(-)
