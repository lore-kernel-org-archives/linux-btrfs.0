Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:34904 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517AbcCaUtd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 16:49:33 -0400
Received: by mail-wm0-f41.google.com with SMTP id 191so139270960wmq.0
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Mar 2016 13:49:32 -0700 (PDT)
Received: from rabbit.myhome.local ([2.28.97.250])
        by smtp.gmail.com with ESMTPSA id j18sm26687292wmd.2.2016.03.31.13.49.30
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Mar 2016 13:49:30 -0700 (PDT)
Received: from elephant.myhome.local ([192.168.12.5])
	by rabbit.myhome.local with esmtp (Exim 4.84)
	(envelope-from <chrismurray84@gmail.com>)
	id 1aljWz-0005x1-QI
	for linux-btrfs@vger.kernel.org; Thu, 31 Mar 2016 21:49:29 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: "/tmp/mnt.", and not honouring compression
Date: Thu, 31 Mar 2016 21:49:29 +0100
Message-ID: <E30C9D57EC226049B1226989BABB2728418CE4@elephant.myhome.local>
From: "Chris Murray" <chrismurray84@gmail.com>
To: <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm trying to troubleshoot a ceph cluster which doesn't seem to be
honouring BTRFS compression on some OSDs. Can anyone offer some help? Is
it likely to be a ceph issue or a BTRFS one? Or something else? I've
asked on ceph-users already, but not received a response yet.

Config is set to mount with "noatime,nodiratime,compress-force=lzo"

Some OSDs have been getting much more full than others though, which I
think is something to do with these 'tmp' mounts e.g. below:

/dev/sdc1 on /var/lib/ceph/tmp/mnt.AywYKY type btrfs
(rw,noatime,space_cache,user_subvol_rm_allowed,subvolid=5,subvol=/)
/dev/sdd1 on /var/lib/ceph/osd/ceph-16 type btrfs
(rw,noatime,nodiratime,compress-force=lzo,space_cache,subvolid=5,subvol=
/)
/dev/sdc1 on /var/lib/ceph/osd/ceph-15 type btrfs
(rw,noatime,nodiratime,space_cache,user_subvol_rm_allowed,subvolid=5,sub
vol=/)
/dev/sdb1 on /var/lib/ceph/osd/ceph-20 type btrfs
(rw,noatime,nodiratime,compress-force=lzo,space_cache,subvolid=5,subvol=
/)

After a reboot, it's moved to another drive:

/dev/sdd1 on /var/lib/ceph/tmp/mnt.kWh2NA type btrfs
(rw,noatime,space_cache,user_subvol_rm_allowed,subvolid=5,subvol=/)
/dev/sdd1 on /var/lib/ceph/osd/ceph-16 type btrfs
(rw,noatime,nodiratime,space_cache,user_subvol_rm_allowed,subvolid=5,sub
vol=/)
/dev/sdc1 on /var/lib/ceph/osd/ceph-15 type btrfs
(rw,noatime,nodiratime,compress-force=lzo,space_cache,subvolid=5,subvol=
/)
/dev/sdb1 on /var/lib/ceph/osd/ceph-20 type btrfs
(rw,noatime,nodiratime,compress-force=lzo,space_cache,subvolid=5,subvol=
/)

I'm using Proxmox, based on Debian. Kernel version 4.2.8-1-pve. Btrfs
v3.17.

Thank you,
Chris
