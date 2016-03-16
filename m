Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51636 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935047AbcCPSaH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 14:30:07 -0400
Date: Wed, 16 Mar 2016 19:29:41 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs pre-release 4.5-rc1
Message-ID: <20160316182941.GR21722@suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs 4.5-rc1 have been released. The ETA for final release is this
Friday, so please test and report if you find problems. Small fixes or
documentation updates are welcome.

Changes:

* new/moved commands
  * btrfs-show-super -> btrfs inspect-internal dump-super
  * btrfs-debug-tree -> btrfs inspect-internal dump-tree
* new commands
  * btrfs fi du - calculate disk usage, including shared extents
* enhancements
  * device delte - delete by id (needs kernel support, not merged to 4.6)
  * check - new option to specify chunk root
  * debug-tree/dump-tree - option -t understands human readable name of the
    tree (along numerical ids)
  * btrfs-debugfs - can dump block group information
* bugfixes
  * all commands should accept the option separator "--"
  * several fixes in device scan
  * restore works on filesystems with sectorsize > 4k
  * debug-tree/dump-tree - print compression type as string
* other
  * documentation updates
  * manual pages for the moved tools now point to btrfs-filesystem
  * testsuite updates

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Alexander Fougner (6):
      btrfs-progs: copy functionality of btrfs-debug-tree to inspect-internal subcommand
      btrfs-progs: update docs and completion for inspect-internal dump-tree
      btrfs-progs: introduce inspect-internal dump-super
      btrfs-progs: update docs for inspect-internal dump-super
      btrfs-progs: docs: add note about resizing to max after device replace
      btrfs-progs: docs: fix spelling errors

Anand Jain (1):
      btrfs-progs: Introduce device delete by devid

David Sterba (37):
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

Feifei Xu (1):
      btrfs-progs: Replace hardcoded PAGE_CACHE_SIZE with sectorsize.

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

Satoru Takeuchi (6):
      btrfs-progs: Describe device scan -d is a deprecated option in manpage
      btrfs-progs: Fix device scan to interpret its argument properly
      btrfs-progs: Fix a regression that btrfs filesystem label doesn't work
      btrfs-progs: Avoid interpreting options after "--" when getting unit mode
      btrfs-progs: Describe optarg of -m option in the manpage of receive
      btrfs-progs: fix a regression that "property" with -t option doesn't work

Vytas Dauksa (1):
      btrfs-progs: convert: document -O|--features flag

Wang Xiaoguang (1):
      btrfs-progs: print-tree: show the compression method string

Yauhen Kharuzhy (2):
      btrfs-progs: fix broken 'device scan' arguments parsing
      btrfs-progs: Dont' stop scanning of devices at first failed device
