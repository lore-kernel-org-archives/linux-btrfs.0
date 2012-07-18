Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58892 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab2GRRpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jul 2012 13:45:21 -0400
Received: by obbuo13 with SMTP id uo13so2426703obb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2012 10:45:20 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 18 Jul 2012 20:45:20 +0300
Message-ID: <CAHf9xvbz92KdUrXHhEFyEqwFhA97yTw7=10YC8YyCMxDZ20_Yw@mail.gmail.com>
Subject: btrfs send/receive: if new inode ino is less than its new directory
 ino, incorrect path is sent
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Alexander Block <ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alexander,
I am testing different scenarios in order to better understand the
non-trivial magic of
get_cur_path()/will_overwrite_ref()/did_overwrite_ref()/did_overwrite_first_ref().
I hit the following issue, when testing full-send:

This is my source subvolume (inode numbers are written):
tree -A  --inodes --noreport /mnt/src/tmp/
/mnt/src/tmp/
└── [    270]  dir2
    └── [    268]  file1_nod

As you see, the ino(file1_nod) < ino(dir2). It is very easy to
achieve: first create the file, then the dir, and then move the file
to dir.

During send the following happens (I augmented the send code with many prints):

file1_nod is sent first. Since its a new inode, it is sent as an
orphan. When recording its reference, __record_new_ref() calls
get_cur_path() for its parent (270). Then __get_cur_name_and_parent()
is called on 270, which calls is_inode_existent(), which calls
get_cur_inode_state(), and the state of the parent is "will_create".
So __get_cur_name_and_parent() creates an orphan name for it, and
finally the new reference for 268 is recorded as:
o270-136-0/file1_nod:

[changed_cb:4102] key(256 INODE_ITEM 0) : NEW
[changed_cb:4102] key(256 INODE_REF 256) : NEW
[changed_cb:4102] key(268 INODE_ITEM 0) : NEW
[send_create_inode:2407] NEW ino(268,135) type=0100000, path=[o268-135-0]
[changed_cb:4102] key(268 INODE_REF 270) : NEW
[get_cur_inode_state:1475] (270,136): L(EX,136)
R(NE,18446744072099047770) sp=268 ==> will_create
[is_inode_existent:1498] (270,136): NOT existent
[__get_cur_name_and_parent:1918] ino(270,136) not existent => unique
name [o270-136-0]
[get_cur_path:2051] ino(0,0) cur_path=[o270-136-0]
[__record_new_ref:2911] record new ref [o270-136-0/file1_nod]

Then process_recorded_refs() sees that 268 is still orphan, so it
sends "rename" to its valid place, but the problem is that its parent
dir was not sent yet (and its parent dir is also an orphan):
[process_recorded_refs:2601] ino(268,135): start with refs
[28118.347602] [process_recorded_refs:2651] ino(268,135): new=1,
did_overwrite_first_ref=0, is_orphan=1, valid_path=[o268-135-0]
[28118.347605] [process_recorded_refs:2701] ino(268,135): is orphan,
move it: [o268-135-0]=>[o270-136-0/file1_nod]
[28118.347610] [process_recorded_refs:2837] checking dir(270,136)
[28118.347612] [process_recorded_refs:2869] ino(268,135) done with refs

Now the parent dir is processed:
[changed_cb:4102] key(270 INODE_ITEM 0) : NEW
[send_create_inode:2407] NEW ino(270,136) type=040000, path=[o270-136-0]
[changed_cb:4102] key(270 INODE_REF 256) : NEW
[get_cur_path:2051] ino(256,133) cur_path=[]
[__record_new_ref:2911] record new ref [dir2]
[process_recorded_refs:2601] ino(270,136): start with refs
[process_recorded_refs:2651] ino(270,136): new=1,
did_overwrite_first_ref=0, is_orphan=1, valid_path=[o270-136-0]
[process_recorded_refs:2701] ino(270,136): is orphan, move it:
[o270-136-0]=>[dir2]
[process_recorded_refs:2837] checking dir(256,133)
[get_cur_inode_state:1475] (256,133): L(EX,133)
R(NE,18446612135413283512) sp=270 ==> did_create
[process_recorded_refs:2869] ino(270,136) done with refs

Nothing special here, the parent is first sent as an orphan, and then
renamed to its valid name, but it's too late.

During receive:
ERROR: rename o268-135-0 -> o270-136-0/file1_nod failed. No such file
or directory

I am not yet sure where is the proper place to fix this, I just wanted
to report it first. Basically, I think that when sending any kind of
A_PATH, it is needed to ensure that path components exist, either as
orphan or real path (by sending them out-of-order if needed?). But I
am not yet sure where is the core place that should ensure this.

Thanks,
Alex.
