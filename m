Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static-108-0-197-17.lsanca.fios.verizon.net ([108.0.197.17]:47441
	"EHLO orca4.orcaware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3B0W7m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 17:59:42 -0500
Message-ID: <512E8FD7.8020700@orcaware.com>
Date: Wed, 27 Feb 2013 14:59:35 -0800
From: Blair Zajac <blair@orcaware.com>
MIME-Version: 1.0
To: Josef Bacik <josef@toxicpanda.com>
CC: =?ISO-8859-1?Q?Daniel_Koz=E1k?= <kozzi11@gmail.com>,
        Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Running Apache Derby on 3.8 and BTRFS cause kernel oops
References: <op.ws51z2nllpxuyk@kozzifx.lan> <20130227132513.GG19641@localhost.localdomain> <op.ws6fu8smlpxuyk@kozzifx.lan> <CAEzrpqcmapgs67M2PrVz=XB3MYXV7CN6Roze-WsyS9JR-7jVvw@mail.gmail.com>
In-Reply-To: <CAEzrpqcmapgs67M2PrVz=XB3MYXV7CN6Roze-WsyS9JR-7jVvw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/27/2013 02:08 PM, Josef Bacik wrote:
> On Wed, Feb 27, 2013 at 1:19 PM, Daniel Kozák <kozzi11@gmail.com> wrote:
>>
>> [kozzi@KozziFX ~]$ mkdir derby
>> [kozzi@KozziFX ~]$ cd derby/
>> [kozzi@KozziFX derby]$ wget -c -q
>> http://mirror.hosting90.cz/apache//db/derby/db-derby-10.9.1.0/db-derby-10.9.1.0-bin.zip
>> [kozzi@KozziFX derby]$ unzip -qq db-derby-10.9.1.0-bin.zip
>> [kozzi@KozziFX derby]$ cd db-derby-10.9.1.0-bin/
>> [kozzi@KozziFX db-derby-10.9.1.0-bin]$ DERBY_HOME=`pwd`
>> [kozzi@KozziFX db-derby-10.9.1.0-bin]$ java -jar
>> $DERBY_HOME/lib/derbyrun.jar server start &
>> [kozzi@KozziFX db-derby-10.9.1.0-bin]$ java -jar
>> $DERBY_HOME/lib/derbyrun.jar ij
>> verze ij 10.9
>> ij> CONNECT 'jdbc:derby://localhost:1527/seconddb;create=true';
>>
>> BTW. after this I must restart my PC, and after restart, my system doesn't
>> boot anymore :-) (some more btrfs oops).
>> So I must use btrfs check --repair /dev/sdaX.
>>
>
> Sigh and of course I can't reproduce myself, even with importing a
> huge database into derby.  So you are just mounting with -o
> compress=lzo?  What about the mkfs, are you using raid or anything?
> Are you on a ssd?  Also when this happens is there any output above
> the --- [ cut here ] ---?  There should be something about length and
> such.  Thanks,

I was able to reproduce on with 3.8 using Ubuntu 13.04 running in KVM 
using the commands exactly as given, but it only after stopping and 
starting the server again.

I use the cloud image from here, boot of an Ubuntu CD-ROM ISO to change 
from ext4 to btrfs, then installed openjdk.

http://cloud-images.ubuntu.com/raring/current/raring-server-cloudimg-amd64-disk1.img

I could make my image available for download later if you need it, in a 
pre-failure state.  Let me know.

Blair


landscape-client is not configured, please run landscape-config.
Cloud-init v. 0.7.1 running 'modules:final' at Wed, 27 Feb 2013 21:29:24 
+0000. Up 11.54 seconds.
Cloud-init v. 0.7.1 finished at Wed, 27 Feb 2013 21:29:24 +0000. 
Datasource DataSourceEc2.  Up 11.67 seconds
[ 4884.271027] btrfs bad mapping eb start 494796800 len 4096, wanted 4096 8
[ 4884.273834] BUG: unable to handle kernel NULL pointer dereference at 
           (null)
[ 4884.276166] IP: [<ffffffffa00ca9a3>] write_extent_buffer+0xd3/0x150 
[btrfs]
[ 4884.276848] PGD 3e907067 PUD 3a281067 PMD 0
[ 4884.276848] Oops: 0000 [#1] SMP
[ 4884.276848] Modules linked in: dm_crypt(F) microcode(F) 
virtio_balloon(F) psmouse(F) serio_raw(F) acpiphp(F) btrfs(F) 
zlib_deflate(F) libcrc32c(F) ghash_clmulni_intel(F) aesni_intel(F) 
8139too(F) aes_x86_64(F) floppy(F) xts(F) lrw(F) gf128mul(F) 
ablk_helper(F) cryptd(F) 8139cp(F)
[ 4884.276848] CPU 0
[ 4884.276848] Pid: 13258, comm: java Tainted: GF       W 
3.8.0-7-generic #15-Ubuntu Bochs Bochs
[ 4884.276848] RIP: 0010:[<ffffffffa00ca9a3>]  [<ffffffffa00ca9a3>] 
write_extent_buffer+0xd3/0x150 [btrfs]
[ 4884.276848] RSP: 0018:ffff8800380d79c8  EFLAGS: 00010202
[ 4884.276848] RAX: 0000000000000000 RBX: 0000000000000008 RCX: 
0000000000000008
[ 4884.276848] RDX: 0000000000001008 RSI: 0000000000001000 RDI: 
ffff880037c31428
[ 4884.276848] RBP: ffff8800380d79f8 R08: 000000000000000a R09: 
0000000000000000
[ 4884.276848] R10: 0000000000001000 R11: 0000000000000002 R12: 
ffff8800380d7a28
[ 4884.276848] R13: ffff880037c31428 R14: 0000000000000000 R15: 
0000000000000008
[ 4884.276848] FS:  00007f28536a8700(0000) GS:ffff88006ca00000(0000) 
knlGS:0000000000000000
[ 4884.276848] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4884.276848] CR2: 0000000001960000 CR3: 000000003d7c7000 CR4: 
00000000000407f0
[ 4884.276848] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 4884.276848] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 4884.276848] Process java (pid: 13258, threadinfo ffff8800380d6000, 
task ffff880067e38000)
[ 4884.276848] Stack:
[ 4884.276848]  0000000000001000 ffff8800380d7b18 ffff880037c31428 
0000000000001000
[ 4884.276848]  000000000000002d 0000000000000fd3 ffff8800380d7a58 
ffffffffa00c0bd0
[ 4884.276848]  0000000000001000 ffff880038007000 0000000000001000 
0000000000001000
[ 4884.276848] Call Trace:
[ 4884.276848]  [<ffffffffa00c0bd0>] btrfs_set_token_64+0xf0/0x100 [btrfs]
[ 4884.276848]  [<ffffffffa00df98b>] 
btrfs_log_changed_extents+0x3ab/0x670 [btrfs]
[ 4884.276848]  [<ffffffffa00e3425>] btrfs_log_inode+0x3d5/0x650 [btrfs]
[ 4884.276848]  [<ffffffff8113aae1>] ? pagevec_lookup_tag+0x21/0x30
[ 4884.276848]  [<ffffffffa00e433c>] btrfs_log_inode_parent+0x17c/0x460 
[btrfs]
[ 4884.276848]  [<ffffffffa00e4667>] btrfs_log_dentry_safe+0x47/0x70 [btrfs]
[ 4884.276848]  [<ffffffffa00bb597>] btrfs_sync_file+0x167/0x230 [btrfs]
[ 4884.276848]  [<ffffffff811c2c9d>] generic_write_sync+0x4d/0x60
[ 4884.276848]  [<ffffffffa00bce20>] btrfs_file_aio_write+0x3d0/0x590 
[btrfs]
[ 4884.276848]  [<ffffffff816c161e>] ? __wait_on_bit+0x7e/0x90
[ 4884.276848]  [<ffffffff81193117>] do_sync_write+0xa7/0xe0
[ 4884.276848]  [<ffffffff811937fc>] vfs_write+0xac/0x180
[ 4884.276848]  [<ffffffff81193b42>] sys_write+0x52/0xa0
[ 4884.276848]  [<ffffffff816cc5dd>] system_call_fastpath+0x1a/0x1f
[ 4884.276848] Code: e0 0c 48 01 d0 4c 89 c2 4a 8d 3c 30 45 31 f6 e8 f4 
88 28 e1 4c 8b 45 d0 4d 01 c4 4d 29 c7 74 38 49 8b 85 50 01 00 00 48 8b 
04 18 <48> 8b 30 83 e6 08 75 95 be af 12 00 00 48 c7 c7 e8 7a 11 a0 48
[ 4884.276848] RIP  [<ffffffffa00ca9a3>] write_extent_buffer+0xd3/0x150 
[btrfs]
[ 4884.276848]  RSP <ffff8800380d79c8>
[ 4884.276848] CR2: 0000000000000000
[ 4884.327410] ---[ end trace 932d1698c8bbdd7c ]---

