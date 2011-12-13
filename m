From: Christian Brunner <chb@muc.de>
Subject: WARNING: at fs/btrfs/extent-tree.c:5980
Date: Tue, 13 Dec 2011 09:04:54 +0100
Message-ID: <CAO47_--mEi_vQNt5TE3vZWAWRVtqsJnMc=jQUNJLSvw8S8=jiA@mail.gmail.com>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

with the latest btrfs for-linus I'm seeing seeing occasional
btrfs_alloc_free_block warnings on several nodes in our ceph cluster.

Before the warning there is an additional block rsv -28 message, but
there is plenty of free space on the disk.


[201653.774412] btrfs: block rsv returned -28
[201653.774415] ------------[ cut here ]------------
[201653.779846] WARNING: at fs/btrfs/extent-tree.c:5980
btrfs_alloc_free_block+0x347/0x360 [btrfs]()

The complte trace is here:

http://pastebin.com/0SFeZReg

The extent-tree.c:5980 is in use_block_rsv():

5974         if (ret) {
5975                 static DEFINE_RATELIMIT_STATE(_rs,
5976                                 DEFAULT_RATELIMIT_INTERVAL,
5977                                 /*DEFAULT_RATELIMIT_BURST*/ 2);
5978                 if (__ratelimit(&_rs)) {
5979                         printk(KERN_DEBUG "btrfs: block rsv
returned %d\n", ret);
5980                         WARN_ON(1);
5981                 }
5982                 ret = reserve_metadata_bytes(root, block_rsv,
blocksize, 0);

Thanks,
Christian
