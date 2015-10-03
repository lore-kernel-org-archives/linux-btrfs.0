Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.digint.ch ([92.42.190.51]:50792 "EHLO mail.digint.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbbJCM3C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Oct 2015 08:29:02 -0400
Received: from [10.0.1.10] (77-59-134-149.dclient.hispeed.ch [77.59.134.149])
	by mail.digint.ch (Postfix) with ESMTPSA id A2F752F70056
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2015 14:28:59 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Axel Burri <axel@tty0.ch>
Subject: btrfs-progs: bugs in "subvolume list" command
Message-ID: <560FCA35.7010100@tty0.ch>
Date: Sat, 3 Oct 2015 14:29:41 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While digging deeper into the "subvolume list" command, I found
some flaws which I'm addressing here:


1. The "parent id" seems to be a relict of old days.
btrfs-subvolume(8) states:

  "If -p is given, then parent <ID> is added to the output between
  ID and top level. The parent's ID may be used at mount time via
  the subvolrootid= option."

The "Mount Options" site [1] tells me that the "subvolrootid="
mount option is deprecated since kernel 3.2. A quick check on my
system (kernel 4.2.2) shows that "parent" is equal to "top level"
for all subvolumes. Is this always true for kernels >3.2 ?

Furthermore, the output is confusing, as "parent" is not related
at all to "parent_uuid".

Note that this is also true for "subvolume show", which
prints "parent" as "Parent ID".

Suggestion: drop the '-p' option and don't print "parent"
anymore. I don't know the "backwards compatibility policy" the
btrfs-devs have here, but my impression is that kernel 3.2 is not
really supported anymore.


2. The output of -a option (as well as -o) is inconsistent. Given
/tmp/btr_test is mounted with subvolid=0:

  # btrfs subvolume create /tmp/btr_test/vol0
  # btrfs subvolume create /tmp/btr_test/vol0/vol1
  # btrfs subvolume create /tmp/btr_test/vol0/vol1/vol2
  # list_path=/tmp/btr_test
  # btrfs subvolume list -a $list_path
  ID 256 gen 8 top level 5 path vol0
  ID 257 gen 9 top level 256 path <FS_TREE>/vol0/vol1
  ID 258 gen 9 top level 257 path <FS_TREE>/vol0/vol1/vol2

The only relative path shown is "vol0", which is
at "$list_path/vol0", as expected. But then "vol0/vol1" are
printed as absolute, while they are relative to $list_path.

  # list_path=/tmp/btr_test/vol0
  # btrfs subvolume list -a $list_path
  ID 256 gen 8 top level 5 path <FS_TREE>/vol0
  ID 257 gen 9 top level 256 path vol0/vol1
  ID 258 gen 9 top level 257 path <FS_TREE>/vol0/vol1/vol2

But if $list_path points to a subvolume, the relative path shown
is now "vol0/vol1", which is actually at "$list_path/../vol0/vol1".

Things get even more confusing when subvolumes are within
directories:

  # mkdir /tmp/btr_test/vol0/dir1
  # btrfs subvolume create /tmp/btr_test/vol0/dir1/vol3
  # list_path=/tmp/btr_test/vol0/dir1
  # btrfs subvolume list -a $list_path
  ID 256 gen 11 top level 5 path <FS_TREE>/vol0
  ID 257 gen 9 top level 256 path vol0/vol1
  ID 258 gen 9 top level 257 path <FS_TREE>/vol0/vol1/vol2
  ID 259 gen 11 top level 256 path vol0/dir1/vol3

I know that handling "real" directories is very tricky to handle
correctly (involving symlinks et all), and is probably not a
feature that "subvolume list" command should handle.


Suggestions:

- Fix '-a' option to also print sub-subvolumes as relative, or
  drop it (there is the -o option for this purpose).
- Fix output of '-o' option, by always printing relative
  paths ("vol1" instead of "vol0/vol1" in the example above).


Regards,

- Axel

  [1] https://btrfs.wiki.kernel.org/index.php/Mount_options
