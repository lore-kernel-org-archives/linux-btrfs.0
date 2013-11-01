Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54803 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab3KAMv6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Nov 2013 08:51:58 -0400
Received: by mail-wi0-f177.google.com with SMTP id f4so1019120wiw.16
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Nov 2013 05:51:56 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 1 Nov 2013 13:51:56 +0100
Message-ID: <CADxbMS9iGjDo4aXcp=gqkfStZh4h7yWUm5AfWDgvRNYOpO_y1A@mail.gmail.com>
Subject: btrfsck: cmds-check.c:2214: check_owner_ref: Assertion
 `!(rec->is_root)' failed.
From: Dawid Kowalski <dkadds2@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Guys,

I've tried to do all possible things by myself, but unfortunately all
have failed.
Therefore I'm looking for your help to get back my valuable data as FS
failed at the time before I was able to finish backup tasks

The error I'm getting is:

# mount -o ro,nospace_cache /mnt/btrfs-backup/btrfs_backup.img /mnt/ssd-source/
[ 4417.684213] parent transid verify failed on 46587904 wanted 10081 found 10212
[ 4417.696899] parent transid verify failed on 46587904 wanted 10081 found 10212
[ 4417.728226] btrfs: open_ctree failed
[ 4494.525556] device fsid c21fcec1-ab9a-4661-a9c0-25899886c91a devid
1 transid 10209 /dev/loop0
[ 4494.525570] device fsid c21fcec1-ab9a-4661-a9c0-25899886c91a devid
1 transid 10209 /dev/loop0
[ 4494.526924] btrfs: disabling disk space caching
[ 4494.529273] device fsid c21fcec1-ab9a-4661-a9c0-25899886c91a devid
1 transid 10209 /dev/loop0
[ 4494.533728] parent transid verify failed on 46587904 wanted 10081 found 10212
[ 4494.533901] parent transid verify failed on 46587904 wanted 10081 found 10212
[ 4494.569029] btrfs: open_ctree failed

# ./btrfsck /mnt/btrfs-backup/btrfs_backup.img
# full output: http://bpaste.net/show/GeJtOSSLwcAvrD4BJIey/
[cut]
parent transid verify failed on 55267328 wanted 10099 found 10212
Ignoring transid failure
Check tree block failed, want=52756480, have=4325488229236153881
Check tree block failed, want=52756480, have=4325488229236153881
Check tree block failed, want=52756480, have=4325488229236153881
Check tree block failed, want=52756480, have=4325488229236153881
Check tree block failed, want=52756480, have=4325488229236153881
read block failed check_tree_block
btrfsck: cmds-check.c:2214: check_owner_ref: Assertion `!(rec->is_root)' failed.
Aborted (core dumped)

# ./btrfsck -s 1 /mnt/btrfs-backup/btrfs_backup.img
# full output: http://bpaste.net/show/epgrx5iHO0iJYNgPt4Cn/
[cut]
parent transid verify failed on 55267328 wanted 10099 found 10212
Ignoring transid failure
Check tree block failed, want=52756480, have=4325488229236153881
Check tree block failed, want=52756480, have=4325488229236153881
Check tree block failed, want=52756480, have=4325488229236153881
Check tree block failed, want=52756480, have=4325488229236153881
Check tree block failed, want=52756480, have=4325488229236153881
read block failed check_tree_block
btrfsck: cmds-check.c:2214: check_owner_ref: Assertion `!(rec->is_root)' failed.
Aborted (core dumped)

#./btrfsck -s 2 /mnt/btrfs-backup/btrfs_backup.img
using SB copy 2, bytenr 274877906944
No valid Btrfs found on /mnt/btrfs-backup/btrfs_backup.img
Couldn't open file system

btrfs restore does not help neither (using -u 1 with same result)
./btrfs restore /mnt/btrfs-backup/btrfs_backup.img /mnt/btrfs-restore/restore/
parent transid verify failed on 46587904 wanted 10081 found 10212
parent transid verify failed on 46587904 wanted 10081 found 10212
parent transid verify failed on 46587904 wanted 10081 found 10212
parent transid verify failed on 46587904 wanted 10081 found 10212
Ignoring transid failure
parent transid verify failed on 76275712 wanted 10110 found 10212
parent transid verify failed on 76275712 wanted 10110 found 10212
parent transid verify failed on 76275712 wanted 10110 found 10212
parent transid verify failed on 76275712 wanted 10110 found 10212
Ignoring transid failure
Check tree block failed, want=69304320, have=4325488229236153881
Check tree block failed, want=69304320, have=4325488229236153881
Check tree block failed, want=69304320, have=4325488229236153881
Check tree block failed, want=69304320, have=4325488229236153881
Check tree block failed, want=69304320, have=4325488229236153881
read block failed check_tree_block
Error searching -5

I've run into problem in a silly way, system got suspended and then
run out of power, therefore had to restart system.
At the boot time, system did not mount root fs sitting on BTRFS.

Having some experience, I've done some research and:
1. Made copy of my FS into file to work on this only to make sure I
can always revert back to original FS with issue and restart recovery
procedure from scratch
2. Built another system with full tool set to easily manipulate my FS image.
3. Pulled latest git clone git://github.com/josefbacik/btrfs-progs.git
and built tools
4. Used latest tools trying to fix problem.

I've checked multiple articles on the net and have tried following.

./btrfs restore /mnt/btrfs-backup/btrfs_backup.img /mnt/btrfs-restore/restore/
http://bpaste.net/show/fEXWHpRrVK8RBfKuhrjs/

System is:
 3.11.0-12-generic #19-Ubuntu
Btrfs tools were polled and compiled today.

Any help would be highly appreciated, as I've said, I've just moved
all my data from other faulty drive and backup task did not finish,
therefore I've just one copy of my data sitting on this BTRFS :(

Regards,
Dawid
