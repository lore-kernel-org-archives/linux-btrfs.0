Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1844 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753312AbcA0G6N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 01:58:13 -0500
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'David Sterba'" <dsterba@suse.cz>
CC: "'btrfs'" <linux-btrfs@vger.kernel.org>
Subject: test fail for btrfs: synchronize incompat feature bits with sysfs files
Date: Wed, 27 Jan 2016 14:57:18 +0800
Message-ID: <003501d158cf$f71750f0$e545f2d0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David Sterba

I find this patch caused NULL pointer accessing in lattest integration-4.5:
  btrfs: synchronize incompat feature bits with sysfs files
  CommitID: 14e46e04958df740c6c6a94849f176159a333f13

Several xfstests(as btrfs/103) failed with "BUG: unable to handle kernel NULL pointer..." warning.
Can be reproduced by following way:
  mkfs.btrfs -f /dev/sdb20
  mount -o "compress=lzo" /dev/sdb20 /mnt/tmp
  (panic)

Maybe caused by following reason:
(Only guessd by review source, hadn't trace to confirm)
 In open_ctree(), btrfs_parse_options()->btrfs_sysfs_feature_update()->sysfs_remove_group()
 is trying to remove fs_info->fs_devices->fsid_kobj, but this kobject is not initialized before.
 It is initialized in open_ctree() after btrfs_parse_options().

Cound you try to confirm it?

Thanks
Zhaolei




