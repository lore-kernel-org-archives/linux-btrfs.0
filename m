From: Espen Trydal <espen.trydal@gmail.com>
Subject: btrfs: failed to read chunk root
Date: Sun, 14 Aug 2011 22:06:00 +0200
Message-ID: <CAAaHQFWhDPjPWF_YA2Ag-DcmGXKiPt3_XY79nZrCNn+fB-AjdQ@mail.gmail.com>
References: <CAAaHQFUUvwo=s2UbLz1ZNBNHb7MukFc8X4J+A0LRwka6KfBvng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAaHQFUUvwo=s2UbLz1ZNBNHb7MukFc8X4J+A0LRwka6KfBvng@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

trying out btrfs on my linux installation. I am running Funtoo with
Linux 3.0 kernel. After a reboot kernel panicked (no access to error
log since it is my root volume that failed). I get this using a rescue
cd (2.6.38, btrfs v 0.19) and then trying to mount :

[=C2=A0 752.129118] btrfs bad tree block start 0 131072
[=C2=A0 752.129152] btrfs: failed to read chunk root on sda5
[=C2=A0 752.132190] btrfs: open_ctree failed
[ 1132.984600] device label deux devid 1 transid 86 /dev/sdb3
[ 1171.796682] device fsid 9d42de57e2bebde7-4824b05acb3c538d devid 1
transid 346 /dev/sda5

Trying btrfsck:
btrfsck: disk-io.c:721: open_ctree_fd: Assertion `!(!chunk_root->node)'=
 failed.

It had worked alright during the last couple of reboots. Before
rebooting I created a new btrfs volume which I am able to mount
without problems in rescue mode.

Thanks for any help,
Espen
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
