Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50465 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbbJELIs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Oct 2015 07:08:48 -0400
Date: Mon, 5 Oct 2015 13:07:44 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.2.2
Message-ID: <20151005110744.GC14363@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

here's a bugfix release of btrfs-progs, fixes picked from current devel
branch.

* fi label: use fallback if the label ioctl is not available
* convert: check nodesize constraints against commandline features (-O)
* scrub: report status 'running' until all devices are finished
* device scanning might crash in some scenarios
* fi usage: print summary for non-root users

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git


Shortlog:

Anand Jain (2):
      btrfs-progs: provide fail safe for BTRFS_IOC_GET_FSLABEL ioctl
      btrfs-progs: fix is_block_device() return checks

David Sterba (3):
      btrfs-progs: make sure that is_block_device will return only 0/1
      btrfs-progs: fix double free during scanning
      btrfs-progs: fix error checking in load_device_info

Qu Wenruo (1):
      btrfs-progs: utils: Check nodesize against features

Silvio Fricke (2):
      btrfs-progs: tasks info->id is a pthread_t and should not set to -1
      btrfs-progs: check: fix memset range

Zhao Lei (2):
      btrfs-progs: Increase running state's priority in stat output
      btrfs-progs: Show detail error message when write sb failed in write_dev_supers()
