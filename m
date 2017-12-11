Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:49167 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750709AbdLKGik (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Dec 2017 01:38:40 -0500
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id BC2F4AC0143
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Dec 2017 15:38:36 +0900 (JST)
Received: from G01JPEXCHKW16.g01.fujitsu.local (G01JPEXCHKW16.g01.fujitsu.local [10.0.194.55])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 17425BD6660
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Dec 2017 15:38:36 +0900 (JST)
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [RFC v2] Improve subvolume usability for a normal user
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <eae0749c-eca0-4952-d4b3-ec4175d22653@jp.fujitsu.com>
Date: Mon, 11 Dec 2017 15:38:31 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

I reflected the comments of the first version of the RFC[1]. 
Thanks for all those who commented.

The summary of updated proposal is:
 - Change the default behavior to allow a user to delete subvolume which is empty
 - Add 2 new non-root ioctls to get subvolume/quota info under the specified path

Please see the 'Proposal' section below for the detail.

More comments are welcome.
Regards,
Tomohiro Misono

[1] https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg70666.html

==========
- Goal and current problem
The goal of this RFC is to give a normal user more control to their own subvolumes.
Currently the control to subvolumes for a normal user is restricted as below: 

+-------------+------+------+
|   command   | root | user |
+-------------+------+------+
| sub create  | Y    | Y    |
| sub snap    | Y    | Y    |
| sub del     | Y    | N    |
| sub list    | Y    | N    |
| sub show    | Y    | N    |
| qgroup show | Y    | N    |
+-------------+------+------+

In short, I want to change this as below in order to improve user's usability:

+-------------+------+--------+
|   command   | root | user   |
+-------------+------+--------+
| sub create  | Y    | Y      |
| sub snap    | Y    | Y      |
| sub del     | Y    | N -> Y |
| sub list    | Y    | N -> Y |
| sub show    | Y    | N -> Y |
| qgroup show | Y    | N -> Y |
+-------------+------+--------+

In words,
(1) allow deletion of subvolume (if it is empty) and
(2) allow getting subvolume/quota info (under the specified path)

I think other commands not listed above (qgroup limit, send/receive etc.) should be done
by root and not be allowed for a normal user.


- Proposal
 (1) deletion of subvolume

  Change the default behavior for a user to allow to delete a subvolume (by "subvol del") if 
    1. the user has write+exec right to it, and
    2. it is empty
  So, it is the same as user_subvol_rm_allowed option with emptiness check.

  Emptiness check is needed because Snapshot creation wont' check the permission and 
  can copy a dir which cannot be deleted by the user, and therefore just allowing deletion 
  may cause data loss.

  Summary of behavior by different condition is as follows:

  +===============================+========================+======================+
  |                               |        Current         |       Proposal       |
  +===============================+========================+======================+
  | root                          | Can delete all         | Same as the current  |
  +-------------------------------+------------------------+----------------------+
  | user (user_subvol_rm_allowed) | Can delete if he       | Same as the current  |
  |                               | has write+exec right   |                      |
  +-------------------------------+------------------------+----------------------+
  | user (default)                | Cannot delete anything | Can delete if he     |
  |                               |                        | has write+exec right |
  |                               |                        | and is empty         |
  +-------------------------------+------------------------+----------------------+
 
 (2) getting subvolume/quota info

  Introduce 2 new ioctls to get subol/quota info under the specified path (which needs
  to be able to be opened by the user) and modify INO_LOOKUP to check permission
  during path construction for a normal user. 

  Current approach cannot be used directly for a normal user as explained below:
    TREE_SEARCH ioctl is used to retrieve the subvolume/quota info by btrfs-progs
    (sub show/list, qgroup show etc.). This requires the root permission. Also, 
    in order to construct the path, INO_LOOKUP will be called afterwards, which also
    requires root permission and omits the permission check during path construction.
  
    The easiest way to allow a user to get subvolume/quota info is just relaxing
    the permission of TREE_SEARCH. However, since all the tree information (inc.
    file name) will be exposed, this poses a sequrity risk and is not acceptable.
 
  The detail of new ioctls and approach is here:
   [subvolume info]
    Searching ROOT tree for ROOT_ITEM/ROOT_BACKREF under the specified path, and 
    checking its read right by searching FS/FILE tree and comparing the mode with caller's uid.
    
    After this ioctl is called, btrfs-progs calls modified INO_LOOKUP to construct the path
    with permission check. In case path construction fails due to permission, btrfs-progs
    skips to output the infomation of the subvolume.
  
   [quota info]
    Same as above, but mainly searching QUOTA tree.


- Summary of Proposal
 - Change the default behavior to allow a user to delete subvolume which is empty
 - Add 2 new non-root ioctls to get subvolume/quota info under the specified path
==========

