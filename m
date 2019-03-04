Return-Path: <SRS0=W6bw=RH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D15C43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Mar 2019 21:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3020B20663
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Mar 2019 21:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfCDVbe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Mar 2019 16:31:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:50958 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726038AbfCDVbd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Mar 2019 16:31:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DA616AF38;
        Mon,  4 Mar 2019 21:31:31 +0000 (UTC)
Subject: Re: btrfs seriouse design issue
To:     =?UTF-8?Q?Tomasz_K=c5=82oczko?= <kloczko.tomasz@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <CABB28CzO9x-th16nSuvZDdsE3TLey_0L8AAPRh0SVFacnV1Xsw@mail.gmail.com>
From:   Jeff Mahoney <jeffm@suse.com>
Message-ID: <6c8c2345-5857-b73d-0edd-02c7230e2e9a@suse.com>
Date:   Mon, 4 Mar 2019 16:31:24 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:66.0)
 Gecko/20100101 Thunderbird/66.0
MIME-Version: 1.0
In-Reply-To: <CABB28CzO9x-th16nSuvZDdsE3TLey_0L8AAPRh0SVFacnV1Xsw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 3/4/19 9:46 AM, Tomasz Kłoczko wrote:
> Hi,
> 
> I just added new disk with btrfs and my intention was to use space of
> this new disk in multiple mountpoints of existing tree.
> So after create new btrfs pool on tol of new device I've created two
> subvolumes srv an lxc then after adding necessary entries in fstab to
> mount in /srv and /var/lib/lxc -> mount -a.
> So far so good because what I've done is not illegal or wrong and such
> trick is possible and it works.

It's not a trick.  That's the proper way to do it.

> Then after checking what I've just done using mount command looking on
> the output I've realised that something is really wrong :/
> 
> # mount | grep btrfs
> /dev/mmcblk0p2 on / type btrfs
> (rw,relatime,ssd,space_cache,subvolid=257,subvol=/fedora)
> /dev/sda2 on /var/lib/lxc type btrfs
> (rw,relatime,ssd,space_cache,subvolid=257,subvol=/lxc)
> /dev/sda2 on /srv type btrfs
> (rw,relatime,ssd,space_cache,subvolid=259,subvol=/srv)
> 
> As it is possible to see both mount points are listed as mounted out
> of /dev/sda2.
> That is a real problem for any monitoring software which will be
> catching two times mountes exactly the same device.

That's a bug in the monitoring software.  Bind mounts can do this now on 
any file system.

> So where is the design issue?
> 1) btrfs has no concept of storage poll with name like it is in case of zfs

That's not a design issue.  That's a personal preference for how zfs 
represents its storage space.

> 2) all btrfs subvolumes are not listed in mount output

This a shortcoming for which I've been working on patches.  Even when 
they're done, though, it will *not* show all subvolumes.  It will only 
show the ones currently mounted into the namespace.  With btrfs 
lightweight snapshots, it's easy to have thousands of subvolumes.  We 
don't want to see them all.

> With zpool name is possible to present all volumes as subobject of the
> storage pool like in output:
> 
> $ zfs list
> NAME                              USED  AVAIL  REFER  MOUNTPOINT
> rpool                            2.03G   298G   144K  /rpool
> rpool/ROOT                       1.96G   298G   144K  legacy
> rpool/ROOT/solaris-0              584K   298G  1.63G  /
> rpool/ROOT/solaris-0/var          352K   298G   140M  /var
> rpool/ROOT/solaris-1             1.96G   298G  1.63G  /
> rpool/ROOT/solaris-1/var          225M   298G   124M  /var
> rpool/VARSHARE                   31.9M   298G   312K  /var/share
> rpool/VARSHARE/pkg                296K   298G   152K  /var/share/pkg
> rpool/VARSHARE/pkg/repositories   144K   298G   144K
> /var/share/pkg/repositories
> rpool/VARSHARE/sstore            22.3M   298G  22.3M  /var/share/sstore/repo
> rpool/VARSHARE/tmp               9.07M   298G  9.07M  /var/tmp
> rpool/export                     42.2M   298G   152K  /export
> rpool/export/home                42.1M   298G   168K  /export/home
> rpool/export/home/jacek           176K   298G   176K  /export/home/jacek
> rpool/export/home/ss              196K   298G   196K  /export/home/ss
> rpool/export/home/tkloczko       41.6M   298G  41.6M  /export/home/tkloczko
> 
> and all those zfs subvolumes are viable in mount output so they are
> fully distinguishable
> 
>   mount | grep rpool
> / on rpool/ROOT/solaris-1
> read/write/setuid/nodevices/rstchown/nonbmand/exec/xattr/noatime/mountpoint=/data/HPE-Builder/root//zone=HPE-Builder/nozonemod/sharezone=1/dev=35d002b
> on Sun Mar  3 04:17:05 2019
> /var on rpool/ROOT/solaris-1/var
> read/write/setuid/nodevices/rstchown/nonbmand/exec/xattr/noatime/mountpoint=/data/HPE-Builder/root/var/zone=HPE-Builder/nozonemod/sharezone=1/dev=35d002c
> on Sun Mar  3 04:17:07 2019
> /var/share on rpool/VARSHARE
> read/write/nosetuid/nodevices/rstchown/nonbmand/noexec/noxattr/noatime/zone=HPE-Builder/sharezone=1/dev=35d0031
> on Sun Mar  3 04:17:27 2019
> /var/tmp on rpool/VARSHARE/tmp
> read/write/setuid/nodevices/rstchown/nonbmand/exec/xattr/noatime/zone=HPE-Builder/sharezone=1/dev=35d0032
> on Sun Mar  3 04:17:27 2019
> /export on rpool/export
> read/write/setuid/nodevices/rstchown/nonbmand/exec/xattr/noatime/zone=HPE-Builder/sharezone=1/dev=35d0035
> on Sun Mar  3 04:17:35 2019
> /export/home on rpool/export/home
> read/write/setuid/nodevices/rstchown/nonbmand/exec/xattr/noatime/zone=HPE-Builder/sharezone=1/dev=35d0036
> on Sun Mar  3 04:17:35 2019
> /export/home/jacek on rpool/export/home/jacek
> read/write/setuid/nodevices/rstchown/nonbmand/exec/xattr/noatime/zone=HPE-Builder/sharezone=1/dev=35d0037
> on Sun Mar  3 04:17:35 2019
> /export/home/ss on rpool/export/home/ss
> read/write/setuid/nodevices/rstchown/nonbmand/exec/xattr/noatime/zone=HPE-Builder/sharezone=1/dev=35d0038
> on Sun Mar  3 04:17:35 2019
> /export/home/tkloczko on rpool/export/home/tkloczko
> read/write/setuid/nodevices/rstchown/nonbmand/exec/xattr/noatime/zone=HPE-Builder/sharezone=1/dev=35d0039
> on Sun Mar  3 04:17:36 2019
> /rpool on rpool
> read/write/setuid/nodevices/rstchown/nonbmand/exec/xattr/noatime/zone=HPE-Builder/sharezone=1/dev=35d003a
> on Sun Mar  3 04:17:36 2019
> /var/share/pkg on rpool/VARSHARE/pkg
> read/write/nosetuid/nodevices/rstchown/nonbmand/noexec/noxattr/noatime/zone=HPE-Builder/sharezone=1/dev=35d003f
> on Sun Mar  3 04:17:37 2019
> /var/share/pkg/repositories on rpool/VARSHARE/pkg/repositories
> read/write/nosetuid/nodevices/rstchown/nonbmand/noexec/noxattr/noatime/zone=HPE-Builder/sharezone=1/dev=35d0040
> on Sun Mar  3 04:17:37 2019
> /var/share/sstore/repo on rpool/VARSHARE/sstore
> read/write/nosetuid/nodevices/rstchown/nonbmand/noexec/noxattr/noatime/zone=HPE-Builder/sharezone=1/dev=35d0044
> on Sun Mar  3 04:17:39 2019
> 
> Because all zfs volumes are visable on VFS layer Solaris is able to
> produce per volume VFS layer statistics. In case of btrfs something
> like this is not possible because only mountpoint mounted is what was
> specified for mount (manually or over fstab)
> For example I can take from mount output dev=35d0044 and use it with kstat:
> 
> $ kstat -p | grep 35d0044
> unix:1:vopstats_35d0044:aread_bytes     0
> unix:1:vopstats_35d0044:aread_time      0
> unix:1:vopstats_35d0044:awrite_bytes    0
> unix:1:vopstats_35d0044:awrite_time     0
> unix:1:vopstats_35d0044:class   misc
> unix:1:vopstats_35d0044:crtime  254.04196691
> unix:1:vopstats_35d0044:nacancel        0
> unix:1:vopstats_35d0044:naccess 107474
> unix:1:vopstats_35d0044:naddmap 0
> unix:1:vopstats_35d0044:nafsync 0
> unix:1:vopstats_35d0044:naread  0
> unix:1:vopstats_35d0044:nawrite 0
> unix:1:vopstats_35d0044:nclose  107474
> unix:1:vopstats_35d0044:ncmp    42
> unix:1:vopstats_35d0044:ncreate 58700
> unix:1:vopstats_35d0044:ndelmap 0
> unix:1:vopstats_35d0044:ndispose        0
> unix:1:vopstats_35d0044:ndump   0
> unix:1:vopstats_35d0044:ndumpctl        0
> unix:1:vopstats_35d0044:nfid    0
> unix:1:vopstats_35d0044:nfrlock 0
> unix:1:vopstats_35d0044:nfsync  0
> unix:1:vopstats_35d0044:ngetattr        156527
> unix:1:vopstats_35d0044:ngetpage        0
> unix:1:vopstats_35d0044:ngetsecattr     58700
> unix:1:vopstats_35d0044:ninactive       58661
> unix:1:vopstats_35d0044:nioctl  0
> unix:1:vopstats_35d0044:nlink   0
> unix:1:vopstats_35d0044:nlookup 1549680
> unix:1:vopstats_35d0044:nmap    0
> unix:1:vopstats_35d0044:nmkdir  0
> unix:1:vopstats_35d0044:nopen   107474
> unix:1:vopstats_35d0044:npageio 0
> unix:1:vopstats_35d0044:npathconf       0
> unix:1:vopstats_35d0044:npoll   0
> unix:1:vopstats_35d0044:nputpage        0
> unix:1:vopstats_35d0044:nread   48729
> unix:1:vopstats_35d0044:nreaddir        87
> unix:1:vopstats_35d0044:nreadlink       0
> unix:1:vopstats_35d0044:nrealvfs        0
> unix:1:vopstats_35d0044:nrealvp 140620
> unix:1:vopstats_35d0044:nreflink        0
> unix:1:vopstats_35d0044:nreletocache    1585518
> unix:1:vopstats_35d0044:nremove 51329
> unix:1:vopstats_35d0044:nrename 7738
> unix:1:vopstats_35d0044:nreqzcbuf       0
> unix:1:vopstats_35d0044:nretzcbuf       0
> unix:1:vopstats_35d0044:nrmdir  0
> unix:1:vopstats_35d0044:nrwlock 107515
> unix:1:vopstats_35d0044:nrwunlock       107515
> unix:1:vopstats_35d0044:nseek   0
> unix:1:vopstats_35d0044:nsetattr        0
> unix:1:vopstats_35d0044:nsetfl  0
> unix:1:vopstats_35d0044:nsetsecattr     0
> unix:1:vopstats_35d0044:nshrlock        0
> unix:1:vopstats_35d0044:nspace  0
> unix:1:vopstats_35d0044:nsymlink        0
> unix:1:vopstats_35d0044:nvnevent        0
> unix:1:vopstats_35d0044:nwrite  58699
> unix:1:vopstats_35d0044:read_bytes      550957714
> unix:1:vopstats_35d0044:read_time       514114360
> unix:1:vopstats_35d0044:readdir_bytes   117480
> unix:1:vopstats_35d0044:readdir_time    286027046
> unix:1:vopstats_35d0044:snaptime        109395.47355841
> unix:1:vopstats_35d0044:write_bytes     595622652
> unix:1:vopstats_35d0044:write_time      1543437021
> 
> Other thing is that looks still btrfs does not provide any per volume metrics.

There is no standard interface for Linux for this, so whether it's 
associated with a mountpoint or not doesn't make any difference.  If you 
(or someone) wanted to add support for this, hanging it off btrfs_root 
and exporting via ioctl would probably be the easiest way to do it.  We 
already have subvolume iterators in the tools.

> Other thing that in case of btrfs it is not possible to have subvolume
> but mounted.
> In case of zfs all volumes with mountpoint "legacy" are not mouted
> when zpool is imported which creates perfect platform for cloning
> rootfs which always is as not mounted/legacy. With multiple clones is
> possible to use them as separated instances of boot environments
> (BEs). Without such feature looks like using btrfs would be way
> harder.
> There is of course much more ZFS features which do not have any
> analogues in case of btrfs. Some people here familiar with zfs are
> probably more or less aware what is till missing.
> 
> Just in case .. I'm not complaining. I'm only trying gently point on
> something which already will cause some confusion maybe starting kind
> of discussion about how to solve current state.
> I thing that redesign btrfs to have subvolumes visible in mount could
> solve few things.
> 
> Comments?

It sounds like you're coming from a Solaris environment with ZFS and are 
expecting Btrfs on Linux to be a drop-in replacement, and neither are. 
There are certainly ideas we can borrow from ZFS, though.

-Jeff

-- 
Jeff Mahoney
SUSE Labs
