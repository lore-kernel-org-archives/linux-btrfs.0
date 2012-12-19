Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:36408 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab2LSLZK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Dec 2012 06:25:10 -0500
Message-ID: <50D1A430.607@cn.fujitsu.com>
Date: Wed, 19 Dec 2012 19:25:36 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Arne Jansen <sensille@gmx.net>, wangshilong <wangsl-fnst@cn.fujitsu.com>
Subject: About btrfs qgroup import/export command
References: <50D1632E.6010801@cn.fujitsu.com>
In-Reply-To: <50D1632E.6010801@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, everyone.

As we know, there is no backup function for qgroup. when the problem
occurs, the users must recover qgroup configuration manually, it is not
convenient. And besides that, some users might want to import an existed
qgroup configuration into a new filesystem. Btrfs does not have such a
function,it can only be done manually.

So we want to implement btrfs qgroup import/export commands.
1)'btrfs qgroup export' commands will export qgroup tree
  into a user's specified file.(stdout by default)

2)user may modify the configuration file firstly and then
  import it into the filesystem.(by 'btrfs qgroup import' command)

The file may be formated as the following:

Qgroupid     is_compressed     is_exclusive   limited_size    parent
----------------------------------------------------------------------
 0/1            0                 0              10G            1/0
 1/0            1                 1              20G            ---
  
 If 'is_exclusive' is set, 'limited_size' corresponds to max exlusive size,
 else max referenced size. Here 'parent' exclude ancestral qgroups. 

Is there any comment about this idea? 

Thanks
Miao








