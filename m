Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:40831 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750810AbdLEIZx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Dec 2017 03:25:53 -0500
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 5732DAC0081
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Dec 2017 17:25:47 +0900 (JST)
Received: from g01jpexchkw37.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id ABAEC328725
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Dec 2017 17:25:46 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [RFC] Improve subvolume usability for a normal user
Message-ID: <5fc9b66b-0bcd-c2a9-7e8e-b4d4ff828200@jp.fujitsu.com>
Date: Tue, 5 Dec 2017 17:25:07 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

I want to address some issues of subvolume usability for a normal user.
i.e. a user can create subvolumes, but
 - Cannot delete their own subvolume (by default)
 - Cannot tell subvolumes from directories (in a straightforward way)
 - Cannot check the quota limit when qgroup is enabled

Here I show the initial thoughts and approaches to this problem.
I want to check if this is a right approach or not before I start writing code.

Comments are welcome.
Tomohiro Misono

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
(1) allow deletion of subvolume if a user owns it, and 
(2) allow getting subvolume/quota info if a user has read access to it
 (sub list/qgroup show just lists the subvolumes which are readable by the user)

I think other commands not listed above (qgroup limit, send/receive etc.) should
be done by root and not be allowed for a normal user.


- Outside the scope of this RFC
There is a qualitative problem to use qgroup for limiting user disk amount;
quota limit can easily be averted by creating a subvolume. I think that forcing
inheriting quota of parent subvolume is a solution, but I won't address nor
discuss this here. 


- Proposal
 (1) deletion of subvolume

  I want to change the default behavior to allow a user to delete their own
  subvolumes.
  
  This is not the same behavior as when user_subvol_rm_alowed mount option is
  specified; in that case a user can delete the subvolume to which they have
  write+exec right.
  
  Since snapshot creation is already restricted to the subvolume owner, it is
  consistent that only the owner of the subvolume (or root) can delete it.
  
  The implementation should be straightforward.

 (2) getting subvolume/quota info

  TREE_SEARCH ioctl is used to retrieve the subvolume/quota info by btrfs-progs
  (sub show/list, qgroup show etc.). This requires the root permission.
  
  The easiest way to allow a user to get subvolume/quota info is just relaxing
  the permission of TREE_SEARCH. However, since all the tree information (inc.
  file name) will be exposed, this poses a sequrity risk and is not acceptable.
  
  So, I want to introduce 2 ioctls to get subvolume/quota info respectively for
  a normal user, which return only the info readable by the user:
  
   [subvolume info]
    Mainly search ROOT tree for ROOT_ITEM/ROOT_BACKREF, but check its read
   right by searching FS/FILE tree and comparing it with caller's uid.
  
   [quota info]
    Same as above, but mainly search QUOTA tree and only returns level 0 info.
  
  Also, in order to construct subvolume path, permission of INO_LOOKUP ioctl
  needs to be relaxed for the user who has read access to the subvolume.


- Summary of Proposal
 - Change the default behavior to allow a user to delete their own subvolumes
 - Add 2 new non-root ioctls to get subvolume/quota info for accessible subvolumes
==========

