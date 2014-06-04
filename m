Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62054 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751500AbaFDJQr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jun 2014 05:16:47 -0400
Message-ID: <538EE31B.8080701@cn.fujitsu.com>
Date: Wed, 4 Jun 2014 17:12:59 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org Btrfs" <linux-btrfs@vger.kernel.org>
CC: "dsterba@suse.cz Sterba" <dsterba@suse.cz>,
        Anand Jain <Anand.Jain@oracle.com>
Subject: Race condition between btrfs and udev
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Originally this problem was reproduced by the following scripts:

# dd if=/dev/zero of=data bs=1M  count=50
# losetup /dev/loop1 data
# i=1
# while [ 1 ]
    do
            mkfs.btrfs -fK /dev/loop1 >& /dev/null || exit 1
            i++
            echo "loop $i"
    done

Further, a easy way to trigger this problem is by running the followng c 
codes repeatedly:

int main(int argc, char **argv)
{

         int fd = open(argv[1], O_RDWR | O_EXCL);
         if (fd < 0) {
                 perror("fail to open");
                 exit(1);
         }
         close(fd);
         return 0;
}
here @argv[1] needs a btrfs block device.

So the problem is RW opening would trigger udev event which will call 
btrfs_scan_one_device()
In btrfs_scan_one_device(), it would open the block device with EXCL 
flag...meanwhile if another
program try to open that device with O_EXCL, it would fail with EBUSY....

I don't know whether this is a serious problem, now there are two places 
in btrfs-progs that is
trying to open device with O_EXCL:

1. in utils.c: test_dev_for_mkfs()
2. in disk-io.c: __open_ctree_fd()

Any ideas on this? maybe we can remove @EXCL flag from btrfs-progs?

Thanks,
Wang

