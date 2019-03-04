Return-Path: <SRS0=W6bw=RH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E74C43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Mar 2019 14:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFDA120815
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Mar 2019 14:47:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ch9krstk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfCDOrZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Mar 2019 09:47:25 -0500
Received: from mail-ua1-f52.google.com ([209.85.222.52]:44391 "EHLO
        mail-ua1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbfCDOrY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2019 09:47:24 -0500
Received: by mail-ua1-f52.google.com with SMTP id r21so4570638uan.11
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Mar 2019 06:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=V2VT1E1IorfkDmTPTIZlZjMu4OYm8mYI1duJaowgemI=;
        b=ch9krstkDEOCdE34TCwCys/xh5gJv501FHr1hv13pigPMEpM6ChveL8CS3r56uT6aW
         qzSgFq5YgEFCMrBc1U29vSVjb9aXbt6pEcNvJe+gfr8FwwAPNxRp+Pl0Sq/hq7rexe4s
         WOHIvlAWlxqoYsxWJE8deItelzsFtq7P+Jm5FD2q+S9AUxxpFqcqmIY766GCBz5SnAht
         rwznFTZsHWxw0qPTb+c3mZWvzn/PF9Vm4mEq1ueCutqdC9LWS0p7fCI80OXTV648JpS+
         onekagMIuFXsohtYUtJ1B7bQNSJKpyr4MFIMzMqXnyS1qc2MPTxoEnuJIigoKYCH3Ufy
         gBpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=V2VT1E1IorfkDmTPTIZlZjMu4OYm8mYI1duJaowgemI=;
        b=KZ06iCL5YquWcjcCZ2jybkQlBc+FG1sAV+npp01zPpbxcPZBdFDrPc2xp57sSdN8hP
         q3fmB4leMm4Ign7JoZ+WaMw54LFL6IKkCnA7JtNnPr6mm80O14SkZZhpXG6NMeELWePy
         33zB3j64RImb0/FmB9eYuRiBxd+LQSK9dft3h+qajQ1l9Pn9oSeZkGp1v7cFy4g58YeA
         FTWucdCPs0fClHcKtIqpy7z16aHerx4UM9gB/PS3CyGj0oPJ1x8eP3b6BKrVj44uCxPb
         iIyAQlfvPPy6t7PeJQk/ha+BWyreGnOsRrlpe78o9hvvYKWpFGQ1+lDVHgEAQyh/EgXZ
         va6g==
X-Gm-Message-State: APjAAAWmGXmK3W05w/p/IjGVrtxLBJjA5eIzGSWKnKdHOCg0BbathTfP
        hQMXDtPvUQdjqQ7yUYyrJuGfwErLOJoSl+iEw485BWH6
X-Google-Smtp-Source: APXvYqyUQadv1kn0cmYEu8AQqCu6vzBGacXntyAiTGsj6HGDqorBJrGAQ2TAidDky06zxT2Qokq3tXMnRaqtsPi53fw=
X-Received: by 2002:a67:f78a:: with SMTP id j10mr9797299vso.46.1551710842928;
 Mon, 04 Mar 2019 06:47:22 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?Q?Tomasz_K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Date:   Mon, 4 Mar 2019 14:46:56 +0000
Message-ID: <CABB28CzO9x-th16nSuvZDdsE3TLey_0L8AAPRh0SVFacnV1Xsw@mail.gmail.com>
Subject: btrfs seriouse design issue
To:     Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

I just added new disk with btrfs and my intention was to use space of
this new disk in multiple mountpoints of existing tree.
So after create new btrfs pool on tol of new device I've created two
subvolumes srv an lxc then after adding necessary entries in fstab to
mount in /srv and /var/lib/lxc -> mount -a.
So far so good because what I've done is not illegal or wrong and such
trick is possible and it works.
Then after checking what I've just done using mount command looking on
the output I've realised that something is really wrong :/

# mount | grep btrfs
/dev/mmcblk0p2 on / type btrfs
(rw,relatime,ssd,space_cache,subvolid=3D257,subvol=3D/fedora)
/dev/sda2 on /var/lib/lxc type btrfs
(rw,relatime,ssd,space_cache,subvolid=3D257,subvol=3D/lxc)
/dev/sda2 on /srv type btrfs
(rw,relatime,ssd,space_cache,subvolid=3D259,subvol=3D/srv)

As it is possible to see both mount points are listed as mounted out
of /dev/sda2.
That is a real problem for any monitoring software which will be
catching two times mountes exactly the same device.
So where is the design issue?
1) btrfs has no concept of storage poll with name like it is in case of zfs
2) all btrfs subvolumes are not listed in mount output

With zpool name is possible to present all volumes as subobject of the
storage pool like in output:

$ zfs list
NAME                              USED  AVAIL  REFER  MOUNTPOINT
rpool                            2.03G   298G   144K  /rpool
rpool/ROOT                       1.96G   298G   144K  legacy
rpool/ROOT/solaris-0              584K   298G  1.63G  /
rpool/ROOT/solaris-0/var          352K   298G   140M  /var
rpool/ROOT/solaris-1             1.96G   298G  1.63G  /
rpool/ROOT/solaris-1/var          225M   298G   124M  /var
rpool/VARSHARE                   31.9M   298G   312K  /var/share
rpool/VARSHARE/pkg                296K   298G   152K  /var/share/pkg
rpool/VARSHARE/pkg/repositories   144K   298G   144K
/var/share/pkg/repositories
rpool/VARSHARE/sstore            22.3M   298G  22.3M  /var/share/sstore/rep=
o
rpool/VARSHARE/tmp               9.07M   298G  9.07M  /var/tmp
rpool/export                     42.2M   298G   152K  /export
rpool/export/home                42.1M   298G   168K  /export/home
rpool/export/home/jacek           176K   298G   176K  /export/home/jacek
rpool/export/home/ss              196K   298G   196K  /export/home/ss
rpool/export/home/tkloczko       41.6M   298G  41.6M  /export/home/tkloczko

and all those zfs subvolumes are viable in mount output so they are
fully distinguishable

 mount | grep rpool
/ on rpool/ROOT/solaris-1
read/write/setuid/nodevices/rstchown/nonbmand/exec/xattr/noatime/mountpoint=
=3D/data/HPE-Builder/root//zone=3DHPE-Builder/nozonemod/sharezone=3D1/dev=
=3D35d002b
on Sun Mar  3 04:17:05 2019
/var on rpool/ROOT/solaris-1/var
read/write/setuid/nodevices/rstchown/nonbmand/exec/xattr/noatime/mountpoint=
=3D/data/HPE-Builder/root/var/zone=3DHPE-Builder/nozonemod/sharezone=3D1/de=
v=3D35d002c
on Sun Mar  3 04:17:07 2019
/var/share on rpool/VARSHARE
read/write/nosetuid/nodevices/rstchown/nonbmand/noexec/noxattr/noatime/zone=
=3DHPE-Builder/sharezone=3D1/dev=3D35d0031
on Sun Mar  3 04:17:27 2019
/var/tmp on rpool/VARSHARE/tmp
read/write/setuid/nodevices/rstchown/nonbmand/exec/xattr/noatime/zone=3DHPE=
-Builder/sharezone=3D1/dev=3D35d0032
on Sun Mar  3 04:17:27 2019
/export on rpool/export
read/write/setuid/nodevices/rstchown/nonbmand/exec/xattr/noatime/zone=3DHPE=
-Builder/sharezone=3D1/dev=3D35d0035
on Sun Mar  3 04:17:35 2019
/export/home on rpool/export/home
read/write/setuid/nodevices/rstchown/nonbmand/exec/xattr/noatime/zone=3DHPE=
-Builder/sharezone=3D1/dev=3D35d0036
on Sun Mar  3 04:17:35 2019
/export/home/jacek on rpool/export/home/jacek
read/write/setuid/nodevices/rstchown/nonbmand/exec/xattr/noatime/zone=3DHPE=
-Builder/sharezone=3D1/dev=3D35d0037
on Sun Mar  3 04:17:35 2019
/export/home/ss on rpool/export/home/ss
read/write/setuid/nodevices/rstchown/nonbmand/exec/xattr/noatime/zone=3DHPE=
-Builder/sharezone=3D1/dev=3D35d0038
on Sun Mar  3 04:17:35 2019
/export/home/tkloczko on rpool/export/home/tkloczko
read/write/setuid/nodevices/rstchown/nonbmand/exec/xattr/noatime/zone=3DHPE=
-Builder/sharezone=3D1/dev=3D35d0039
on Sun Mar  3 04:17:36 2019
/rpool on rpool
read/write/setuid/nodevices/rstchown/nonbmand/exec/xattr/noatime/zone=3DHPE=
-Builder/sharezone=3D1/dev=3D35d003a
on Sun Mar  3 04:17:36 2019
/var/share/pkg on rpool/VARSHARE/pkg
read/write/nosetuid/nodevices/rstchown/nonbmand/noexec/noxattr/noatime/zone=
=3DHPE-Builder/sharezone=3D1/dev=3D35d003f
on Sun Mar  3 04:17:37 2019
/var/share/pkg/repositories on rpool/VARSHARE/pkg/repositories
read/write/nosetuid/nodevices/rstchown/nonbmand/noexec/noxattr/noatime/zone=
=3DHPE-Builder/sharezone=3D1/dev=3D35d0040
on Sun Mar  3 04:17:37 2019
/var/share/sstore/repo on rpool/VARSHARE/sstore
read/write/nosetuid/nodevices/rstchown/nonbmand/noexec/noxattr/noatime/zone=
=3DHPE-Builder/sharezone=3D1/dev=3D35d0044
on Sun Mar  3 04:17:39 2019

Because all zfs volumes are visable on VFS layer Solaris is able to
produce per volume VFS layer statistics. In case of btrfs something
like this is not possible because only mountpoint mounted is what was
specified for mount (manually or over fstab)
For example I can take from mount output dev=3D35d0044 and use it with ksta=
t:

$ kstat -p | grep 35d0044
unix:1:vopstats_35d0044:aread_bytes     0
unix:1:vopstats_35d0044:aread_time      0
unix:1:vopstats_35d0044:awrite_bytes    0
unix:1:vopstats_35d0044:awrite_time     0
unix:1:vopstats_35d0044:class   misc
unix:1:vopstats_35d0044:crtime  254.04196691
unix:1:vopstats_35d0044:nacancel        0
unix:1:vopstats_35d0044:naccess 107474
unix:1:vopstats_35d0044:naddmap 0
unix:1:vopstats_35d0044:nafsync 0
unix:1:vopstats_35d0044:naread  0
unix:1:vopstats_35d0044:nawrite 0
unix:1:vopstats_35d0044:nclose  107474
unix:1:vopstats_35d0044:ncmp    42
unix:1:vopstats_35d0044:ncreate 58700
unix:1:vopstats_35d0044:ndelmap 0
unix:1:vopstats_35d0044:ndispose        0
unix:1:vopstats_35d0044:ndump   0
unix:1:vopstats_35d0044:ndumpctl        0
unix:1:vopstats_35d0044:nfid    0
unix:1:vopstats_35d0044:nfrlock 0
unix:1:vopstats_35d0044:nfsync  0
unix:1:vopstats_35d0044:ngetattr        156527
unix:1:vopstats_35d0044:ngetpage        0
unix:1:vopstats_35d0044:ngetsecattr     58700
unix:1:vopstats_35d0044:ninactive       58661
unix:1:vopstats_35d0044:nioctl  0
unix:1:vopstats_35d0044:nlink   0
unix:1:vopstats_35d0044:nlookup 1549680
unix:1:vopstats_35d0044:nmap    0
unix:1:vopstats_35d0044:nmkdir  0
unix:1:vopstats_35d0044:nopen   107474
unix:1:vopstats_35d0044:npageio 0
unix:1:vopstats_35d0044:npathconf       0
unix:1:vopstats_35d0044:npoll   0
unix:1:vopstats_35d0044:nputpage        0
unix:1:vopstats_35d0044:nread   48729
unix:1:vopstats_35d0044:nreaddir        87
unix:1:vopstats_35d0044:nreadlink       0
unix:1:vopstats_35d0044:nrealvfs        0
unix:1:vopstats_35d0044:nrealvp 140620
unix:1:vopstats_35d0044:nreflink        0
unix:1:vopstats_35d0044:nreletocache    1585518
unix:1:vopstats_35d0044:nremove 51329
unix:1:vopstats_35d0044:nrename 7738
unix:1:vopstats_35d0044:nreqzcbuf       0
unix:1:vopstats_35d0044:nretzcbuf       0
unix:1:vopstats_35d0044:nrmdir  0
unix:1:vopstats_35d0044:nrwlock 107515
unix:1:vopstats_35d0044:nrwunlock       107515
unix:1:vopstats_35d0044:nseek   0
unix:1:vopstats_35d0044:nsetattr        0
unix:1:vopstats_35d0044:nsetfl  0
unix:1:vopstats_35d0044:nsetsecattr     0
unix:1:vopstats_35d0044:nshrlock        0
unix:1:vopstats_35d0044:nspace  0
unix:1:vopstats_35d0044:nsymlink        0
unix:1:vopstats_35d0044:nvnevent        0
unix:1:vopstats_35d0044:nwrite  58699
unix:1:vopstats_35d0044:read_bytes      550957714
unix:1:vopstats_35d0044:read_time       514114360
unix:1:vopstats_35d0044:readdir_bytes   117480
unix:1:vopstats_35d0044:readdir_time    286027046
unix:1:vopstats_35d0044:snaptime        109395.47355841
unix:1:vopstats_35d0044:write_bytes     595622652
unix:1:vopstats_35d0044:write_time      1543437021

Other thing is that looks still btrfs does not provide any per volume metri=
cs.

Other thing that in case of btrfs it is not possible to have subvolume
but mounted.
In case of zfs all volumes with mountpoint "legacy" are not mouted
when zpool is imported which creates perfect platform for cloning
rootfs which always is as not mounted/legacy. With multiple clones is
possible to use them as separated instances of boot environments
(BEs). Without such feature looks like using btrfs would be way
harder.
There is of course much more ZFS features which do not have any
analogues in case of btrfs. Some people here familiar with zfs are
probably more or less aware what is till missing.

Just in case .. I'm not complaining. I'm only trying gently point on
something which already will cause some confusion maybe starting kind
of discussion about how to solve current state.
I thing that redesign btrfs to have subvolumes visible in mount could
solve few things.

Comments?

kloczek
--=20
Tomasz K=C5=82oczko | LinkedIn: http://lnkd.in/FXPWxH
