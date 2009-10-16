From: John Dong <jdong@ubuntu.com>
Subject: Building btrfs-unstable.git against 2.6.31?
Date: Fri, 16 Oct 2009 10:59:27 -0400
Message-ID: <3FDCD4F7-B65A-4085-9ED8-72EF31FC0A58@ubuntu.com>
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=windows-1252;
	format=flowed	delsp=yes
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hey guys, I was trying to build the btrfs modules from btrfs-=20
unstable.git/master against the Ubuntu Karmic 2.6.31 kernel, and get =20
some failures in ref-cache.c:

/home/jdong/code/kernel/btrfs-0.17/ref-cache.h:62: error: =20
dereferencing pointer to incomplete type
/home/jdong/code/kernel/btrfs-0.17/ref-cache.c: In function =20
=91btrfs_remove_leaf_refs=92:
/home/jdong/code/kernel/btrfs-0.17/ref-cache.c:123: error: =91struct =20
btrfs_root=92 has no member named =91ref_tree=92
/home/jdong/code/kernel/btrfs-0.17/ref-cache.c:126: error: =91struct =20
btrfs_fs_info=92 has no member named =91shared_ref_tree=92


And so on.


Am I not supposed to be building btrfs this way?

Sorry for the potentially braindead obvious question :)


John Dong--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
