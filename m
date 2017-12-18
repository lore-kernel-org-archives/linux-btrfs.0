Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:44849 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933204AbdLRRel (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 12:34:41 -0500
Received: by mail-lf0-f42.google.com with SMTP id x204so18648662lfa.11
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Dec 2017 09:34:40 -0800 (PST)
Received: from [192.168.1.7] (ppp109-252-90-255.pppoe.spdop.ru. [109.252.90.255])
        by smtp.gmail.com with ESMTPSA id n10sm2876026lfn.71.2017.12.18.09.34.38
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Dec 2017 09:34:38 -0800 (PST)
Subject: Re: btrfs subvolume list for not mounted filesystem?
To: linux-btrfs@vger.kernel.org
References: <20171218164941.GA22020@rus.uni-stuttgart.de>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <e0054e4f-1b80-ecd0-791b-ec146ecbc822@gmail.com>
Date: Mon, 18 Dec 2017 20:34:38 +0300
MIME-Version: 1.0
In-Reply-To: <20171218164941.GA22020@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

18.12.2017 19:49, Ulli Horlacher пишет:
> I want to mount an alternative subvolume of a btrfs filesystem.
> I can list the subvolumes when the filesystem is mounted, but how do I
> know them, when the filesystem is not mounted? Is there a query command?
> 
> root@xerus:~# mount | grep /test
> /dev/sdd4 on /test type btrfs (rw,relatime,space_cache,user_subvol_rm_allowed,subvolid=5,subvol=/)
> 
> root@xerus:~# btrfs subvolume list /test
> ID 258 gen 156 top level 5 path tux/zz
> ID 259 gen 156 top level 5 path tux/z1
> ID 260 gen 156 top level 5 path tmp/zz
> ID 261 gen 19 top level 260 path tmp/zz/z1
> ID 269 gen 156 top level 5 path tux/test
> ID 271 gen 129 top level 269 path tux/test/.snapshot/2017-12-02_1341.test
> 
> root@xerus:~# umount /test
> 
> root@xerus:~# btrfs subvolume list /dev/sdd4
> ERROR: not a btrfs filesystem: /dev/sdd4
> ERROR: can't access '/dev/sdd4'
> 
> 
> 

btrfs-debug-tree -r /dev/sdd4

(or in more recent btrfs-progs, "btrfs inspect-internal dump-tree") will
show subvolume IDs (as ROOT_ITEM); I'm not sure of there is simple way
to resolve subvolume path names on unmounted device.
