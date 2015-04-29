Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422869AbbD2PS5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Apr 2015 11:18:57 -0400
Date: Wed, 29 Apr 2015 17:18:55 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 3.19
Message-ID: <20150429151855.GY4996@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs 4.0 have been released. There are few enhancments to
subcommands restore, receive, resize and a few bugfixes elsewhere.

The zero-log functionality is now avaiable under 'rescue' so you can
drop the standalone utility btrfs-zero-log from init ramdisks or other
space-tight rescue environments.

The version is 4.0 and matches kernel versioning, though there are no
major changes or incompatibilities.

Changelog:

* resize:
  * don't accept file as an argument (it's confusing)
  * print better error message in case of an error
* restore: optionally restore metadata (time, mode, uid/gid)
* receive: optionally enforce chroot
* new rescue subcommand 'zero-log', same as btrfs-zero-log, but
  now also part of the main utility
* check:
  * free space checks match kernel, fixes incorrect reports
* convert: fix setting of checksum bit if --no-datasum is used
* fsck.btrfs: don't print messages
* fix quota rescan on PPC64 (mangled ioctl number)
* test updates
* documentation: files renamed to .asciidoc, misc fixups

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Anand Jain (3):
      Btrfs-progs: fix compile warnings
      btrfs-progs: improve troubleshooting avoid duplicate error strings
      btrfs-progs: fix typo in btrfs-device.txt

Chen Hanxiao (1):
      btrfs-progs doc: emphasis that only mounted device works for btrfs device stats

Dan Merillat (2):
      btrfs-progs: restore: optionally restore metadata
      btrfs-progs: restore: document metadata restore.

David Sterba (22):
      btrfs-progs: convert tests: preserve test image permissions
      btrfs-progs: tests: split make rule for fsck and convert tests, fix prerequisities
      btrfs-progs: tests: remove duplicate output for fsck test 013
      btrfs-progs: convert: use exact size for reading superblock
      btrfs-progs: mkfs, deprecate leafsize and clean up the code
      btrfs-progs: move feature parsing from mkfs to utils
      btrfs-progs: print fs features filtered by a mask
      btrfs-progs: cleanup option index argument from getopt_long
      btrfs-progs: getopt, use symbolic name for argument requirements
      btrfs-progs: Documentaion: rename to .asciidoc
      btrfs-progs: fi resize: accept only directories as paths
      btrfs-progs: cleanup, rename *disk_usage* files to usage
      btrfs-progs: add zero-log to rescue command
      btrfs-progs: restore: fix path leak in copy_metadata
      btrfs-progs: restore: convert search_dir exit paths to a single return
      btrfs-progs: restore: convert copy_file exit paths to a single return
      btrfs-progs: check: fix compile warnings in del_file_extent_hole
      btrfs-progs: restore: cleanup, use PATH_MAX
      btrfs-progs: fix typos in restore help/doc
      btrfs-progs: receive: unconditionally print if doing chroot
      btrfs-progs: restore: don't misreport errors from search_dir
      Btrfs progs v4.0

George Wang (1):
      btrfs-progs: fix btrfs quota rescan failed on PPC64 arch

Josef Bacik (1):
      btrfs-progs: check for matching free space in cache

Lauri Võsandi (1):
      btrfs-progs: optionally enforce chroot for btrfs receive

Qu Wenruo (8):
      btrfs-progs: convert: Make ext*_image file obey datacsum setting.
      btrfs-progs: test-frame: Update variant names
      btrfs-progs: fsck-tests: Remove duplicatesd TEST_MNT setup.
      btrfs-progs: fsck-tests: Update 013-extent-tree-rebuild to use more test framework infrastructure.
      btrfs-progs: fsck-tests: Add fallback TEST_DEV for test case 013
      btrfs-progs: convert-tests: Update to use test framework infrastructure.
      btrfs-progs: convert-tests: Add check for converted btrfs with regular file extent.
      btrfs-progs: Doc: Add warning and note on btrfs-convert.

WorMzy Tykashi (1):
      btrfs-progs: use local btrfs-image in leaf corruption test

Zach Brown (1):
      btrfs-progs: silence fake fsck

Zygo Blaxell (1):
      btrfs-progs: report failure when resize ioctl fails
