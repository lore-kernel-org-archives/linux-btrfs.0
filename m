Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32139 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbcCAQIi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2016 11:08:38 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>
Subject: [RFC] Experimental btrfs encryption
Date: Wed,  2 Mar 2016 00:08:09 +0800
Message-Id: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset adds btrfs encryption support.

Warning:
The code is in prototype/experimental stage and is not suitable
for the production data yet.

Example usage:
Create an encrypted subvolume:
  btrfs subvol create -e /btrfs/sv1
  Paraphrase: <-

Review encryption status
  btrfs subvol show /btrfs/sv1
  btrfs/sv1
    Name: sv1
    UID: d8bf1718-56a7-da40-86d9-b8e87315f63f
    Parent UUID: -
    Received UUID: -
    Creation time: 2016-03-01 17:11:58 +0800
    Subvolume ID: 257
    Generation: 13
    Gen at creation:7
    Parent ID: 5
    Top level ID: 5
    Flags: -
    Encryption: aes@btrfs:d8bf1718 (188612608)
                   ^ ^^^^^^^^^^^^^^ ^^^^^^^^^
                   |        |               |
                Algorithm Key-Tag Key-serial-number

  keyctl show
  ::
  188612608 --alswrv 0 0 \_ user: btrfs:d8bf1718

Logout/revoke:
  btrfs subvol encrypt -k out /btrfs/sv1
  btrfs subvol show /btrfs/sv1 | egrep Encrypt
  Encryption: aes@btrfs:d8bf1718 (Required key not available)

sign in:
  btrfs subvol encrypt -k in /btrfs/sv1

Known issues / limitation / for future expansion:
- Need to set FS incompatible feature.

- No password verification yet.

- Move of files across subvolume is not supported when both
  or either one has encryption set.

- No way to change the password.

- Does not drop the cached pages when key is revoked.

- Need to get password twice from the user.

- No user permeable subvol info ioctl.

- Provide a method to pass key using the mount option.

- Provide a method to read the key from the file.

- Current encryption method is symmetric (same key for both
  encryption and decryption), however we could easily expand
  this to other potentially useful methods like asymmetric
  (private/public) encryption.

- As of now uses "user" keytype, I am still considering/
  evaluating other key type such as logon.

- Evaluate other encryption algorithms,  as of now it is
  using "cts(cbc(aes)".

- Uses btrfs compression framework, so compression and then
  encryption is not possible. However yet evaluate if there
  are encryption algorithm which can compress as well.


Anand Jain (1):
  btrfs: encryption

 fs/btrfs/Makefile      |   2 +-
 fs/btrfs/btrfs_inode.h |   2 +
 fs/btrfs/compression.c |  53 ++++-
 fs/btrfs/compression.h |   1 +
 fs/btrfs/ctree.h       |  11 +-
 fs/btrfs/encrypt.c     | 544 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/encrypt.h     |  21 ++
 fs/btrfs/inode.c       |  37 +++-
 fs/btrfs/ioctl.c       |   7 +
 fs/btrfs/props.c       | 140 ++++++++++++-
 fs/btrfs/super.c       |   5 +-
 11 files changed, 812 insertions(+), 11 deletions(-)
 create mode 100644 fs/btrfs/encrypt.c
 create mode 100644 fs/btrfs/encrypt.h

Anand Jain (2):
  btrfs-progs: subvolume functions reorg
  btrfs-progs: add encrypt as subvol sub-command

 Makefile.in      |   5 +-
 btrfs-list.c     |  33 +++++
 cmds-qgroup.c    |   1 +
 cmds-send.c      |  12 +-
 cmds-subvolume.c | 209 +++++++++++++++--------------
 commands.h       |   1 +
 encrypt.c        | 397 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 encrypt.h        |  33 +++++
 props.c          |   3 +
 subvolume.c      | 152 +++++++++++++++++++++
 subvolume.h      |  22 +++
 11 files changed, 757 insertions(+), 111 deletions(-)
 create mode 100644 encrypt.c
 create mode 100644 encrypt.h
 create mode 100644 subvolume.c
 create mode 100644 subvolume.h

-- 
2.7.0

