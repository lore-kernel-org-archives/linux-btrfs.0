From: Clint Adams <clint@debian.org>
Subject: Bug#632475: btrfs flushing hangs
Date: Wed, 20 Jul 2011 09:51:28 +0000
Message-ID: <20110720095128.GA1071@scru.org>
References: <20110702162649.GA14328@scru.org>
 <1309750917.3244.94.camel@localhost>
 <20110704182631.GA17222@scru.org>
 <1310357615.8783.76.camel@localhost>
Reply-To: Clint Adams <clint@debian.org>, 632475@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 632475@bugs.debian.org
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
In-Reply-To: <1310357615.8783.76.camel@localhost>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

When my Sheevaplug's btrfs partition gets near-full (df will report 1.8
or 1.9 gigs free), the filesystem hangs.  I get messages as seen below,
and I can no longer read or write.

This occurs with Debian's linux-image-2.6.39-2-kirkwood and
3.0.0~rc5-1~experimental.1 as well.  It is consistently reproducible.

Please let me know what additional information would be helpful.

[ 4852.113592] device fsid 1b48baae86d0b237-51ab536c499a6594 devid 1 transid 163957 /dev/sda1
[ 5288.244963] INFO: task btrfs-transacti:2232 blocked for more than 120 seconds.
[ 5288.252250] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5288.260132] btrfs-transacti D c02e3e4c     0  2232      2 0x00000000
[ 5288.266549] [<c02e3e4c>] (schedule+0x4ac/0x510) from [<c02e43b8>] (schedule_timeout+0x1c/0x230)
[ 5288.275492] [<c02e43b8>] (schedule_timeout+0x1c/0x230) from [<bf0df564>] (btrfs_commit_transaction+0x2dc/0x6ec [btrfs])
[ 5288.286568] [<bf0df564>] (btrfs_commit_transaction+0x2dc/0x6ec [btrfs]) from [<bf0d9df8>] (transaction_kthread+0x12c/0x200 [btrfs])
[ 5288.298586] [<bf0d9df8>] (transaction_kthread+0x12c/0x200 [btrfs]) from [<c006177c>] (kthread+0x84/0x8c)
[ 5288.308149] [<c006177c>] (kthread+0x84/0x8c) from [<c00315b0>] (kernel_thread_exit+0x0/0x8)
[ 5408.308976] INFO: task btrfs-transacti:2232 blocked for more than 120 seconds.
[ 5408.316338] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5408.324204] btrfs-transacti D c02e3e4c     0  2232      2 0x00000000
[ 5408.330642] [<c02e3e4c>] (schedule+0x4ac/0x510) from [<c02e43b8>] (schedule_timeout+0x1c/0x230)
[ 5408.339655] [<c02e43b8>] (schedule_timeout+0x1c/0x230) from [<bf0df564>] (btrfs_commit_transaction+0x2dc/0x6ec [btrfs])
[ 5408.350780] [<bf0df564>] (btrfs_commit_transaction+0x2dc/0x6ec [btrfs]) from [<bf0d9df8>] (transaction_kthread+0x12c/0x200 [btrfs])
[ 5408.362807] [<bf0d9df8>] (transaction_kthread+0x12c/0x200 [btrfs]) from [<c006177c>] (kthread+0x84/0x8c)
[ 5408.372359] [<c006177c>] (kthread+0x84/0x8c) from [<c00315b0>] (kernel_thread_exit+0x0/0x8)
[ 5528.397412] INFO: task btrfs-transacti:2232 blocked for more than 120 seconds.
[ 5528.404701] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5528.412564] btrfs-transacti D c02e3e4c     0  2232      2 0x00000000
[ 5528.418985] [<c02e3e4c>] (schedule+0x4ac/0x510) from [<c02e43b8>] (schedule_timeout+0x1c/0x230)
[ 5528.427927] [<c02e43b8>] (schedule_timeout+0x1c/0x230) from [<bf0df564>] (btrfs_commit_transaction+0x2dc/0x6ec [btrfs])
[ 5528.439004] [<bf0df564>] (btrfs_commit_transaction+0x2dc/0x6ec [btrfs]) from [<bf0d9df8>] (transaction_kthread+0x12c/0x200 [btrfs])
[ 5528.451025] [<bf0d9df8>] (transaction_kthread+0x12c/0x200 [btrfs]) from [<c006177c>] (kthread+0x84/0x8c)
[ 5528.460580] [<c006177c>] (kthread+0x84/0x8c) from [<c00315b0>] (kernel_thread_exit+0x0/0x8)
