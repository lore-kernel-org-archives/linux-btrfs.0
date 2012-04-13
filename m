From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: btr fs unmountable after disk failure
Date: Fri, 13 Apr 2012 15:42:14 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1204131536110.24064@frira.zrqbmnf.qr>
References: <alpine.LNX.2.01.1204131252070.26191@frira.zrqbmnf.qr> <20120413105822.GF4856@carfax.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120413105822.GF4856@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


On Friday 2012-04-13 12:58, Hugo Mills wrote:
>On Fri, Apr 13, 2012 at 12:55:43PM +0200, Jan Engelhardt wrote:
>> 
>> I originally created a RAID1(0) compound out of 4 drives. One of them 
>> [sdf] failed recently and was removed. The filesystem is no longer 
>> mountable with the 3 drives left.
>> On 3.3.1:
>> 
>> # btrfs dev scan
>> [ 1065.572938] device label srv devid 1 transid 11386 /dev/sdc
>> [ 1065.573044] device label srv devid 3 transid 11386 /dev/sde
>> [ 1066.089981] device label srv devid 2 transid 11386 /dev/sdd
>> # mount /dev/sdd /top.srv
>> [ 1070.201339] device label srv devid 2 transid 11386 /dev/sdd
>> [ 1070.201666] btrfs: disk space caching is enabled
>> [ 1070.203310] btrfs: failed to read the system array on sde
>> [ 1070.204458] btrfs: open_ctree failed
>> (Sparse error message, innit..)
>
>   I think you need "-o degraded" in this case.

Yes indeed, -o degraded makes it go. Where is such documented? I know
I can't expect mount(8) to yet have it, but there is not a
mount.btrfs(8) either.

After mounting, df shows

Filesystem               1K-blocks       Used Available Use% Mounted on
/dev/sdd                5860554336 2651644680  20368600 100% /top.srv

Adding the new disk now yields yet another kernel warning.

# btrfs dev add /dev/sdf /top.srv; df
[10852.064139] btrfs: free space inode generation (0) did not match
free space cache generation (11385)
Filesystem               1K-blocks       Used Available Use% Mounted on
/dev/sdd                7325692920 2651643152 2974681688  48% /top.srv

According to
# btrfs fi show
Label: 'srv'  uuid: 88300cd5-dbcb-4147-9ee4-c65a1c895e1d
        Total devices 5 FS bytes used 1.23TB
        devid    2 size 1.36TB used 692.88GB path /dev/sdd
        devid    5 size 1.36TB used 51.00GB path /dev/sdf
        devid    3 size 1.36TB used 692.88GB path /dev/sde
        devid    1 size 1.36TB used 692.90GB path /dev/sdc
        *** Some devices missing

devices are missing, but how would I remove the old devid 4
(the "some" that's "missing")? `btrfs fi del` does not take
ids, unfortunately.
