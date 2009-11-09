From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: rootfs snapshots and rollback (i.e. testing updates)
Date: Mon, 09 Nov 2009 16:00:08 +0100
Message-ID: <4AF82E78.1010200@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Is it possible, with current btrfs:

- to take a rootfs snapshot (i.e. prior to a major update),

- do changes in the root filesystem (i.e. install major update),

- if we don't like what the major update did to the system (rootfs), 
"rollback" the snapshot and make it the "original" rootfs again 
(perhaps, with a reboot in between).



If it's possible, what would be the steps/commands?


-- 
Tomasz Chmielewski
http://wpkg.org
