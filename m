Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38795 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751386AbdAYL5t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 06:57:49 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs pre-release 4.9.1-rc1
Date: Wed, 25 Jan 2017 12:57:29 +0100
Message-Id: <20170125115729.10310-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a pre-release has been tagged, fixes that have queued so far.

* check:
  * use correct inode number for lost+found files
  * lowmem mode: fix false alert on dropped leaf
* size reports: negative numbers might appear in size reports during device
  deletes (previously in EiB units)
* mkfs: print device being trimmed
* defrag: v1 ioctl support dropped
* quota: print message before starting to wait for rescan
* qgroup show: new option to sync before printing the stats
* other:
  * corrupt-block enhancements
  * backtrace and co. cleanups
  * doc fixes

ETA for 4.9.1 is in +2 days (2017-01-27).

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (18):
      btrfs-progs: make negative number pretty printing optional
      btrfs-progs: enable negative numbers for unallocated device space
      btrfs-progs: mkfs: print device name while trimming
      btrfs-progs: defrag: force using v2 defrag ioctl and make default 32M threshold actually work
      btrfs-progs: defrag: remove v1 ioctl support
      btrfs-progs: qgroups show: clean up errno passing
      btrfs-progs: qgroup show: refine error messages
      btrfs-progs: tests: 005-qgroup-show
      btrfs-progs: kerncompat: add separate trace print for BUG_ON
      btrfs-progs: kerncompat: pass exact condition value from ASSERT
      btrfs-progs: kerncompat: disconnect assert and warning messages
      btrfs-progs: kerncompat: simplify warning_trace
      btrfs-progs: qgroup show: do not error if sync fails
      btrfs-progs: tests: add variable quotation to cli-tests
      btrfs-progs: tests: use built binaries for 004-send-parent-multi-subvol
      btrfs-progs: mkfs/convert: separate the convert part from make_btrfs
      btrfs-progs: update CHANGES for v4.9.1
      Btrfs progs v4.9.1-rc1

Esteve Fernandez (1):
      btrfs-progs: docs: fix typo in btrfs-subvolume

Goldwyn Rodrigues (2):
      btrfs-progs: check: get the highest inode for lost+found
      btrfs-progs: sanitize - Use correct source for memcpy

Jeff Mahoney (1):
      btrfs-progs: quota: fix printing during wait mode

Lakshmipathi.G (2):
      btrfs-progs: corrupt-block: Include inode nlink field
      btrfs-progs: corrupt-block: Include more inode fields

Nicholas D Steeves (1):
      btrfs-progs: Fix spelling/typos in user-facing strings

Qu Wenruo (2):
      btrfs-progs: check: fix false alert on dropped leaf in lowmem mode
      btrfs-progs: Fix disable backtrace assert error

Tsutomu Itoh (3):
      btrfs-progs: qgroup: add sync option to 'qgroup show'
      btrfs-progs: qgroup: change the value of sort option
      btrfs-progs: tests: add test for --sync option of qgroup show

Zygo Blaxell (1):
      btrfs-progs: utils: negative numbers are more plausible than sizes over 8 EiB

