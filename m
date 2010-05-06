From: liubo <liubo2009@cn.fujitsu.com>
Subject: [BUG] btrfs: report a direct-IO bug
Date: Thu, 06 May 2010 09:47:45 +0800
Message-ID: <4BE21FC1.1010901@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	"Yan, Zheng" <zheng.yan@oracle.com>
To: jim owens <owens6336@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When we tested the series of jim owens' direct-IO patch, a bug occured.

It could be reproduced on a 2.6.34-rc6 kernel with
direct-IO patch by the following steps...

# mkfs.btrfs /dev/sdb
# mount /dev/sdb /home/btrfsdisk
# cd /home/btrfsdisk
# create test.c
# dd if=/dev/zero of=file bs=7K count=1
# gcc test.c -o test
# ./test

===================================
test.c:
===================================
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <malloc.h>

#define BUFFERSIZE    8192

#ifndef O_DIRECT
#define O_DIRECT    00040000
#endif
int main(int argc, char *argv[])
{
    ssize_t n;
    char *buf;
    int fd, nullfd;

    buf = valloc(BUFFERSIZE);
    if (!buf) {
        perror("valloc error");
        exit(1);
    }
   
    if ((fd = open("file", O_RDONLY|O_DIRECT)) < 0 ||
        (nullfd = open("/dev/null", O_WRONLY)) < 0) {
        fprintf(stderr, "open error\n");
        return -1;
    }

    while ((n=read(fd, buf, BUFFERSIZE)) > 0) {
        if (write(nullfd, buf, n) != n) {
            fprintf(stderr, "write error\n");
        }
           
        fprintf(stdout, "read/write %d\n", n);
    }

    if (n < 0) {
        fprintf(stderr, "read error\n");
    }

    close(fd);
    close(nullfd);   

    return 0;
}
===================================
dmesg log:
===================================
[...]
Btrfs loaded
device fsid 7344e3b9386a90be-70bb98f95f99c1af devid 1 transid 327 /dev/sdb
SELinux: initialized (dev sdb, type btrfs), uses xattr
btrfs end < start 8191 8192
------------[ cut here ]------------
WARNING: at fs/btrfs/extent_io.c:379 insert_state+0x46/0x15e [btrfs]()
Hardware name: VirtualBox
Modules linked in: btrfs zlib_deflate libcrc32c sunrpc ip6t_REJECT
nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 dm_multipath uinput
snd_intel8x0 snd_ac97_codec ac97_bus snd_seq snd_seq_device snd_pcm
ppdev snd_timer parport_pc snd parport floppy i2c_piix4 pcnet32
soundcore pcspkr i2c_core mii snd_page_alloc ata_generic pata_acpi [last
unloaded: microcode]
Pid: 1117, comm: test Not tainted 2.6.34-rc5direct-io #2
Call Trace:
 [<c043ea8c>] warn_slowpath_common+0x6a/0x81
 [<e2a70aea>] ? insert_state+0x46/0x15e [btrfs]
 [<c043eab5>] warn_slowpath_null+0x12/0x15
 [<e2a70aea>] insert_state+0x46/0x15e [btrfs]
 [<e2a70cac>] set_extent_bit+0xaa/0x491 [btrfs]
 [<e2a742f8>] ? extent_writepages+0x48/0x54 [btrfs]
 [<e2a5c4e9>] ? btrfs_writepages+0x20/0x25 [btrfs]
 [<e2a715b6>] lock_extent_bits+0x41/0x93 [btrfs]
 [<e2a71622>] lock_extent+0x1a/0x1c [btrfs]
 [<e2a8d093>] btrfs_dio_read+0x114/0x1011 [btrfs]
 [<e2a8cef0>] ? kzalloc.clone.0+0x12/0x14 [btrfs]
 [<e2a8cef0>] ? kzalloc.clone.0+0x12/0x14 [btrfs]
 [<e2a8e12a>] btrfs_direct_IO+0x19a/0x1e4 [btrfs]
 [<c04a458d>] generic_file_aio_read+0xea/0x4e5
 [<c04d3db2>] do_sync_read+0x8f/0xca
 [<c0573809>] ? security_file_permission+0x14/0x16
 [<c04d3e8a>] ? rw_verify_area+0x9d/0xc0
 [<c04d3d23>] ? do_sync_read+0x0/0xca
 [<c04d43d8>] vfs_read+0x82/0xe1
 [<c04d44d5>] sys_read+0x40/0x62
 [<c07947ac>] syscall_call+0x7/0xb
---[ end trace 9fa80a579b4087ce ]---
btrfs found node 0 8191 on insert of 8192 8191
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent_io.c:783!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:06.0/usb2/devnum
Modules linked in: btrfs zlib_deflate libcrc32c sunrpc ip6t_REJECT
nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 dm_multipath uinput
snd_intel8x0 snd_ac97_codec ac97_bus snd_seq snd_seq_device snd_pcm
ppdev snd_timer parport_pc snd parport floppy i2c_piix4 pcnet32
soundcore pcspkr i2c_core mii snd_page_alloc ata_generic pata_acpi [last
unloaded: microcode]

Pid: 1117, comm: test Tainted: G        W  2.6.34-rc5direct-io #2
/VirtualBox
EIP: 0060:[<e2a70cba>] EFLAGS: 00010246 CPU: 0
EIP is at set_extent_bit+0xb8/0x491 [btrfs]
EAX: ffffffef EBX: 00002000 ECX: ffffffef EDX: 00000000
ESI: 00000000 EDI: 00000000 EBP: df321cec ESP: df321cb0
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process test (pid: 1117, ti=df320000 task=d8eb3fc0 task.ti=df320000)
Stack:
 e2a742f8 df321cb8 00000000 00000010 00000000 d89093f4 d89093e0 00000000
<0> d89093e0 df321ce4 e2a5c4e9 d890d630 00002000 00001fff 00000000 df321d30
<0> e2a715b6 00001fff 00000000 00000008 00000008 df321d1c 00000000 00000050
Call Trace:
 [<e2a742f8>] ? extent_writepages+0x48/0x54 [btrfs]
 [<e2a5c4e9>] ? btrfs_writepages+0x20/0x25 [btrfs]
 [<e2a715b6>] ? lock_extent_bits+0x41/0x93 [btrfs]
 [<e2a71622>] ? lock_extent+0x1a/0x1c [btrfs]
 [<e2a8d093>] ? btrfs_dio_read+0x114/0x1011 [btrfs]
 [<e2a8cef0>] ? kzalloc.clone.0+0x12/0x14 [btrfs]
 [<e2a8cef0>] ? kzalloc.clone.0+0x12/0x14 [btrfs]
 [<e2a8e12a>] ? btrfs_direct_IO+0x19a/0x1e4 [btrfs]
 [<c04a458d>] ? generic_file_aio_read+0xea/0x4e5
 [<c04d3db2>] ? do_sync_read+0x8f/0xca
 [<c0573809>] ? security_file_permission+0x14/0x16
 [<c04d3e8a>] ? rw_verify_area+0x9d/0xc0
 [<c04d3d23>] ? do_sync_read+0x0/0xca
 [<c04d43d8>] ? vfs_read+0x82/0xe1
 [<c04d44d5>] ? sys_read+0x40/0x62
 [<c07947ac>] ? syscall_call+0x7/0xb
Code: 85 c0 89 45 d4 75 28 ff 75 10 ff 75 0c ff 75 08 8b 55 f0 8b 45 e4
56 53 e8 f8 fd ff ff 83 c4 14 83 f8 ef 89 c1 0f 85 68 03 00 00 <0f> 0b
eb fe 8b 7d d4 89 5d e8 8b 5d 1c 89 75 ec 83 ef 10 89 5d
EIP: [<e2a70cba>] set_extent_bit+0xb8/0x491 [btrfs] SS:ESP 0068:df321cb0
---[ end trace 9fa80a579b4087cf ]---
