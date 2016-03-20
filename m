Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37138 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbcCTXyA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Mar 2016 19:54:00 -0400
Date: Mon, 21 Mar 2016 00:53:30 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.5
Message-ID: <20160320235330.GG21722@suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs 4.5 have been released.

There's a new command 'btrfs filesystem du' that mimics the 'du' utility but
reports the shared extents among files and in the group defined by the
commandline arguments.

The standalone tools are starting the deprecation period, but they'll
stay for a long time due to compatibility, so there's not even a warning
about deprecation yet.

Changes:

* new/moved commands
  * btrfs-show-super -> btrfs inspect-internal dump-super
  * btrfs-debug-tree -> btrfs inspect-internal dump-tree
* new commands
  * btrfs fi du - calculate disk usage, including shared extents
* enhancements
  * device delete - delete by id (needs kernel support, not merged to 4.6)
  * check - new option to specify chunk root
  * debug-tree/dump-tree - option -t understands human readable name of the
    tree (along numerical ids)
  * btrfs-debugfs - can dump block group information
* bugfixes
  * all commands should accept the option separator "--"
  * several fixes in device scan
  * restore works on filesystems with sectorsize > 4k
  * debug-tree/dump-tree - print compression type as string
  * subvol sync: fix crash, memory corruption
  * argument parsing fixes: subvol get-default, qgroup create/destroy/assign,
    inspect subvolid-resolve
  * check for block device or regular file in several commands
* other
  * documentation updates
  * manual pages for the moved tools now point to btrfs-filesystem
  * testsuite updates

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Alexander Fougner (7):
      btrfs-progs: copy functionality of btrfs-debug-tree to inspect-internal subcommand
      btrfs-progs: update docs and completion for inspect-internal dump-tree
      btrfs-progs: introduce inspect-internal dump-super
      btrfs-progs: update docs for inspect-internal dump-super
      btrfs-progs: docs: add note about resizing to max after device replace
      btrfs-progs: docs: fix spelling errors
      btrfs-progs: fi du: fix incorrect column order

Anand Jain (1):
      btrfs-progs: Introduce device delete by devid

Austin S. Hemmelgarn (1):
      btrfs-progs: add stat check in open_ctree_fs_info

David Sterba (44):
      btrfs-progs: build: extend per-binary objects
      btrfs-progs: fi du: switch to u64
      btrfs-progs: fi du: add long options for units
      btrfs-progs: add getopt stubs where needed
      btrfs-progs: rename commandline helpers
      btrfs-progs: unify naming of argc and argv
      btrfs-progs: unify argc min/max checking
      btrfs-progs: inspect: remove unnecessary helpers
      btrfs-progs: tests: fix misc/005-long-device-name-for-ssd
      btrfs-progs: switch more error messages to common helpers
      btrfs-progs: restore: update error messages
      btrfs-progs: don't print message for a missing device
      btrfs-progs: tests: add image for bko#96971 (bad checksum type)
      btrfs-progs: unify argc min/max checking, a few more
      btrfs-progs: check: drop short option for --chunk-tree
      btrfs-progs: docs: update check options
      btrfs-progs: check: unify naming of long option values
      btrfs-progs: dump-tree: print tree keys with -e
      btrfs-progs: dump-tree: print version information earlier
      btrfs-progs: docs: update dump-tree
      btrfs-progs: dump-tree: let --tree understand name of the tree
      btrfs-progs: remove btrfs-debug-tree manual page and point to inspect-internal
      btrfs-progs: docs: fix more typos and spelling errors
      btrfs-progs: improve error messages after failed wiping
      btrfs-progs: utils: switch more error messages to common helpers
      btrfs-progs: fix resource leak during device scanning
      btrfs-progs: dump-super: switch to getopt_long
      btrfs-progs: dump-super: add more long options
      btrfs-progs: docs: rename and move dump-super
      btrfs-progs: docs: update dump-super
      btrfs-progs: remove btrfs-show-super manual page and point to inspect-internal
      btrfs-progs: docs: add filesystem du
      btrfs-progs: fi du: update help text
      btrfs-progs: fi du: make the output more aligned
      btrfs-progs: mkfs: also parse raid0 profile case-insensitive
      btrfs-progs: docs: fi defrag, make some paragraphs more visible
      Btrfs progs v4.5-rc1
      btrfs-progs: subvol sync: fix memory corruption, undersized array
      btrfs-progs: tests: add 013-subvolume-sync-crash
      btrfs-progs: docs: man5, add space_cache=v2
      btrfs-progs: handle stat errors in open_ctree_fs_info
      btrfs-progs: switch to common message helpers in open_ctree_fs_info
      btrfs-progs: tests: enumerate RWX in convert tests
      Btrfs progs v4.5

Feifei Xu (1):
      btrfs-progs: Replace hardcoded PAGE_CACHE_SIZE with sectorsize.

Lakshmipathi.G (1):
      btrfs-progs: tests: populate fs with small dataset for convert tests

Liu Bo (1):
      btrfs-progs: btrfs-debugfs: fetch block group information

Lu Fengqi (1):
      btrfs-progs: Add new option for specify chunk root bytenr

Mark Fasheh (2):
      btrfs-progs: filesystem: add 'du' command
      btrfs-progs: fi du: Calculate space shared by each directory arguments file set

Ondrej Kozina (1):
      btrfs-progs: libbtrfs: remove max/min macros from API

Qu Wenruo (1):
      btrfs-progs: util: Fix a wrong unit of pretty_size

Satoru Takeuchi (11):
      btrfs-progs: Describe device scan -d is a deprecated option in manpage
      btrfs-progs: Fix device scan to interpret its argument properly
      btrfs-progs: Fix a regression that btrfs filesystem label doesn't work
      btrfs-progs: Avoid interpreting options after "--" when getting unit mode
      btrfs-progs: Describe optarg of -m option in the manpage of receive
      btrfs-progs: fix a regression that "property" with -t option doesn't work
      btrfs-progs: subvol get-default: fix argument parsing
      btrfs-progs: qgroup create/destroy: fix argument parsing
      btrfs-progs: inspect subvolid-resolve: fix argument parsing
      btrfs-progs: qgroup assign: can't handle options
      btrfs-progs: qgroup assign: handle --no-rescan option

Vytas Dauksa (1):
      btrfs-progs: convert: document -O|--features flag

Wang Xiaoguang (1):
      btrfs-progs: print-tree: show the compression method string

Yauhen Kharuzhy (2):
      btrfs-progs: fix broken 'device scan' arguments parsing
      btrfs-progs: Dont' stop scanning of devices at first failed device

