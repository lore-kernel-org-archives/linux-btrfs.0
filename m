Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51733 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2GDAkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2012 20:40:06 -0400
Received: by pbbrp8 with SMTP id rp8so10097484pbb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jul 2012 17:40:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120703152208.GA28701@carfax.org.uk>
References: <4FF30B55.6060205@petaramesh.org>
	<20120703152208.GA28701@carfax.org.uk>
Date: Wed, 4 Jul 2012 07:40:05 +0700
Message-ID: <CAG1y0scaAqck=LYJdfhQa02BsrnBM7=24RFG5j00pb0QSdn1LA@mail.gmail.com>
Subject: Re: BTRFS fsck apparent errors
From: "Fajar A. Nugraha" <list@fajar.net>
To: Hugo Mills <hugo@carfax.org.uk>,
        =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 3, 2012 at 10:22 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Tue, Jul 03, 2012 at 05:10:13PM +0200, Swâmi Petaramesh wrote:

>> After I had shifted, I tried to defragment and compress my FS using
>> commands such as :
>>
>> find /mnt/STORAGEFS/STORAGE/ -exec btrfs fi defrag -clzo -v {} \;
>>
>> During execution of such commands, my kernel oopsed, so I restarted.

>    I would also suggest using a 3.4 kernel. There's at least one FS
> corruption bug known to exist in 3.2 that's been fixed in 3.4.


Are there any known btrfs regression in 3.4? I'm using 3.4.0-3-generic
from a ppa, but a normal mount - umount cycle seems MUCH longer
compared to how it was on 3.2, and iostat shows the disk is
read-IOPS-bound

# time mount LABEL=WD-root

real	0m10.400s
user	0m0.000s
sys	0m0.060s

# time umount /media/WD-root/

real	0m22.419s
user	0m0.000s
sys	0m0.064s

# /proc/10142/stack  <--- the PID of umount process
[<ffffffff8111dd1e>] sleep_on_page+0xe/0x20
[<ffffffff8111de88>] wait_on_page_bit+0x78/0x80
[<ffffffff8111e08c>] filemap_fdatawait_range+0x10c/0x1a0
[<ffffffffa00744eb>] btrfs_wait_marked_extents+0x6b/0xc0 [btrfs]
[<ffffffffa007457b>] btrfs_write_and_wait_marked_extents+0x3b/0x60 [btrfs]
[<ffffffffa00745cb>] btrfs_write_and_wait_transaction+0x2b/0x50 [btrfs]
[<ffffffffa0074e69>] btrfs_commit_transaction+0x759/0x960 [btrfs]
[<ffffffffa00700db>] btrfs_commit_super+0xbb/0x110 [btrfs]
[<ffffffffa0071490>] close_ctree+0x2a0/0x310 [btrfs]
[<ffffffffa004b6c9>] btrfs_put_super+0x19/0x20 [btrfs]
[<ffffffff811810b2>] generic_shutdown_super+0x62/0xf0
[<ffffffff811811d6>] kill_anon_super+0x16/0x30
[<ffffffffa004df3a>] btrfs_kill_super+0x1a/0x90 [btrfs]
[<ffffffff811816ac>] deactivate_locked_super+0x3c/0xa0
[<ffffffff81181f9e>] deactivate_super+0x4e/0x70
[<ffffffff8119df9c>] mntput_no_expire+0xdc/0x130
[<ffffffff8119f296>] sys_umount+0x66/0xe0
[<ffffffff8169e129>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

-- 
Fajar
