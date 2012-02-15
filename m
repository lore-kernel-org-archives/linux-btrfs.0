From: Anand Jain <Anand.Jain@oracle.com>
Subject: [PATCH V2] Btrfs-progs: add \"btrfs subvolume get-default\" subcommand
Date: Wed, 15 Feb 2012 13:43:02 +0800
Message-ID: <4F3B45E6.3000008@oracle.com>
References: <1310374571-20811-1-git-send-email-xin.zhong@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Hugo Mills <hugo@carfax.org.uk>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: xin.zhong@intel.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310374571-20811-1-git-send-email-xin.zhong@intel.com>
List-ID: <linux-btrfs.vger.kernel.org>


Hi Xin / Hugo,
  
  I am referring to
  git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

  has miss match parameter list for list_subvols
  ----------
  # cd btrfs-progs
  # egrep list_subvols *
  btrfs_cmds.c:	ret = list_subvols(fd, print_parent, 0);
  btrfs_cmds.c:	ret = list_subvols(fd, 0, 1);
  btrfs_cmds.h:int list_subvols(int fd, int print_parent, int get_default);  <-----
  btrfs-list.c:int list_subvols(int fd, int print_parent)  <-----
  ----------

  ----------
  # egrep -A 3 list_subvols btrfs-list.c
  int list_subvols(int fd, int print_parent)
  {
	struct root_lookup root_lookup;
	struct rb_node *n;
  ----------
  
  Looks like the following patch was checked in partially.
    http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg11103.html

  Could you pls take a look / comment.

thxs, -Anand

