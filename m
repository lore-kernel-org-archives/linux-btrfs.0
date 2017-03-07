Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56482 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755328AbdCGN77 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Mar 2017 08:59:59 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BAC6DAD7C
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Mar 2017 13:59:55 +0000 (UTC)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: mount policy for subvols if root is remount,ro
Message-ID: <b390c27c-224b-b48b-eec3-218635f90a0e@suse.de>
Date: Tue, 7 Mar 2017 07:59:53 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I want to know if re-mounting the root filesystem read-only should
change subvolumes mounted as read-write to read-only as well? We do
allow mounting subvolumes RW _after_ the root filesystem is mounted RO.

 # mount /dev/vdb /mnt
 # mount -o ro,subvol=svro /dev/vdb /mnt/svro
 # mount -o rw,subvol=svrw /dev/vdb /mnt/svrw
 # mount -o remount,ro /dev/vdb /mnt
 # touch /mnt/f3
touch: cannot touch '/mnt/f3': Read-only file system

Changes subvolume to read-only as well.
 # touch /mnt/svrw/f3
touch: cannot touch '/mnt/svrw/f3': Read-only file system

However, remount of subvol as RW after remount,ro of root works:
 # mount -o remount,rw,subvol=svrw /dev/vdb /mnt/svrw
 # touch /mnt/svrw/f3

-- 
Goldwyn
