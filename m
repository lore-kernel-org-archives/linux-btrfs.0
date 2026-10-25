Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792951380;
	b=A5j3wvoe8jUw1GHQxUpiB+lrgeJF+35uHJT0LNBVpZnqPIj0Xe9nO/vbFhcIC1pr3vMK
	 5feHAL0iL4k4LLwP0reOW1f6HYSBkHRVq//tklxGJT0Je5u1wrQWx9xI3ZB6G4fwR7ZBT
	 +oUBLKmo2tQaw0uZDylNj03hnEqWjo5t6n2Cghue9vB73d6QnF6qMpx6Cjn7c+Vxj04cg
	 AHNTXAigAggE6thjIohQ0UPYgnZv+qKBSRSEsa/czQ5zAhmrVQiT+RSvvuAMceyea+i9d
	 ZO1BxhJ/CArqrdJd1SEjrFTZAqpJZuIABIp1hJltkUOg1IgpBZCth2cAxTEVeikSP7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792951380;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nGkB92t+CooeFQ9Nv+jcXvyrRqhslN6vzmsTBz1kQ1E=;
	b=uUjj/rKLamub2x1TCQqRGhQY3xNSZYoo7nrnV7arwwr8HSiysS6r9iifa0hchtdNGeJV
	 XpMqUmClVFTsvXAUbPbHtNzbVmnzANzN002/Hfmm6Yu71wXcN2iMEVLBWeuzJO0+frQUN
	 CA5E6FK5tkjdyl4XI5HRe0QEMG4o6FKTHRBayCAy17ExxbXc0VuBJfdP6+ajE3pKPLpDl
	 nCF0MmnLZvgJI1OU9Kd0iSVgaIRhwAX4VlzBGimHkw5BDmPGZ8HQLbwHb5c6wxez8rSLy
	 I3zcxnvP7bWulZPbmxsebZNnd45/+zLthOfGiSVbUJdWp5T90mSpO7YwktpA/TQSvlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bZOJ0b30;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65777606A322
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 18:03:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65777606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bZOJ0b30
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-353804b591eso4286908eec.0
        for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 11:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792951380; x=1793556180; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nGkB92t+CooeFQ9Nv+jcXvyrRqhslN6vzmsTBz1kQ1E=;
        b=bZOJ0b30bXZgvp232UNHOAMQJmTlfPOnQ2z3tTgcHuj7D081iTqv8KQLpQ6SmSIz9c
         iqnmeTavtswTQ5eV747Ex7MihLD1WdX72t6pYcvyiUuawNC8tfzdMt/9THyt00Js/X/G
         VJJ+gnp0Icuf8MKR3hhGI3vz+ktCvzyS88Y5tJ56+v+tL74xer0O1MYK4NFQAJ6K7FdG
         wMcbjs16xp3QW9FsTJ497vqjB2n1gWm8UsL0r9K9g3xWLLVrYXfEAAxpyCj/V3e4jh0K
         ikpSbNDd+Fgmv5PP3gm0CjjZsaDTMps/bMbu2WOv0f3AGfBxn0PhoHj7pdHieWyVKedh
         iusg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792951380; x=1793556180;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nGkB92t+CooeFQ9Nv+jcXvyrRqhslN6vzmsTBz1kQ1E=;
        b=hhOdg85w0DqhTzsZIY1pzYUjKQKIVg3ALbw/SItthMbuqoJ1nbDplzKq8L7afaknbn
         miFKXGtkN/3wkEPgct1owjbr07zol7Kk+VuCj84QfUFlhIEh4Vh2Ctjz8oB6Mwi4rK6L
         47wJ2EduqpW3WZiHH4uJAiMX55W4UY+L19ltR5Zrf1vJjL5MDFE5Xpzx8OjBH+CutwdR
         jIH0MoPogpRWvfw5GVZOhdu6bxNrvWS2bofjBQBj6mwGiaWpgatgYD6bljVgRkT/aTLu
         8jp3+zYZpu+1mNBoEfQ7BoC0GIWXymu7jGzArXARK1sGXzb5iiBxFWF0qr0UiuNt5j9/
         Kppg==
X-Forwarded-Encrypted: i=1; AKwUvBz3d77jFQcAJPmHwyUQ8wjaNfd7BKKZnoRRFJv3ofDPOwJ8nrvx7F0UJLrjs0y7fszyqrVGLpbkmLyFPg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJyLJIML9vzkaARnqdZLHQDtOgAsBwfk4gVTMgNg+OJ6hsv9dw2
	9Wk23wsMj2sWG26sX3Bid9VJfFgLmlg174CgIrZJOgcriMVjQI63Y5rg
X-Gm-Gg: AYBFou0eAe9vzjzxkvCJip16A/oodPiRI8TDxVYYsuvDLsnlZc7mhkyrSThU2mJirVM
	8u/rAcj+KOq+LtctAJwaBEP+acUf75nasW8bLoqHaFXkJX793Mx5mXRdhzigDlEHS3As/oNh0tl
	xhPjweC8/8DQ14KL9Ei8GwEMiIdsM9oJrqz7ikpbZQ9m2fWq0KJd8LoI1/0/aswS8faEjng0jzX
	Dfj5sNQP8q5mENYhkCeAiBZSchbbygm2mTZnVcEAGHFGitUirddeqYGVMjaXDXUMKE0Tekesf6k
	jJp6fgPV4yinmxB36cHB6U7wwTG4TbhDUgPuhe2G7eA6mswj8sR/oIX3oc3Gq6UID1jwcOKEl7L
	t4c8qpLRaJ+MAoFfBgZlQzNnFtTvP00iYig2TA14LLcxicVWCwCDLR2AqVtgKuVQ7294hvPlBwR
	ndUGqXnLLKxp15chlZYBIFBAo405EjjwTu8WoGROj8UM8+9nvGwr7oQpX1SrCWv4LFfqkskdMPO
	mMVoSk55hhINGXIkZi5OW1VQMY4svjKEc9voKNHTvsY9dAoLPUf2uddPOG5CFskIa5grBF4Be7Y
	QYtzCgc3YvmT5kfXkF8=
X-Received: by 2002:a05:693c:65cb:b0:369:38e3:5363 with SMTP id 5a478bee46e88-369e847a65cmr6902562eec.7.1792951379486;
        Sun, 25 Oct 2026 11:02:59 -0700 (PDT)
Received: from youngkk-vm.localdomain (67.216.200.102.16clouds.com. [67.216.200.102])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a01fa4c58sm1829947eec.21.2026.10.25.11.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 11:02:58 -0700 (PDT)
From: Cheng Yongkang <teel4res@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cheng Yongkang <teel4res@gmail.com>
Subject: [PATCH] btrfs: remove devid kobject when deleting a missing device
Date: Sun, 25 Oct 2026 11:02:52 -0700
Message-Id: <20261025180252.349049-1-teel4res@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_rm_device() removes the sysfs device entry only when
device->bdev_file is non-NULL.  A missing device (created by
add_missing_dev() for an absent disk) has bdev_file == NULL, but
btrfs_sysfs_add_device() still registers its devid kobject under
/sys/fs/btrfs/<uuid>/devinfo/<devid>.

When such a device is deleted, btrfs_free_device() frees the
btrfs_device while the devid kobject remains registered.  The kobject
is embedded in the freed btrfs_device and its show functions use
container_of() to reach it, so reading any devinfo attribute is a
use-after-free:

  BUG: KASAN: slab-use-after-free in sysfs_kf_seq_show+0x157/0x490
  Read of size 8 at addr ffff88801d8172a8 by task poc/9385
  ...
  Freed by task 9385:
   kfree
   btrfs_rm_device+0x11ee/0x17b0
   btrfs_ioctl_rm_dev+0x265/0x400
  Allocated by task 9390:
   btrfs_alloc_device+0x7e/0x400
   device_list_add
   btrfs_scan_one_device
   btrfs_control_ioctl

The freed object is kmalloc-1k and the faulting access is 680 bytes
inside it (offsetof(struct btrfs_device, devid_kobj) = 640 plus
offsetof(struct kobject, ktype) = 40), confirming the embedded
devid_kobj.

Reproducer: create a three-device RAID1 btrfs, detach one device,
mount with -o degraded, delete the missing device with
BTRFS_IOC_RM_DEV("missing"), then read
/sys/fs/btrfs/<uuid>/devinfo/<devid>/fsid.

btrfs_sysfs_remove_device() already skips the block-device link when
device->bdev is NULL and only touches the devid kobject when it is
initialized.  Call it for missing devices too.

Assisted-by: LLM
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
---
 fs/btrfs/volumes.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 85ea9c5..912a1ef 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2479,11 +2479,11 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 
 	btrfs_assign_next_active_device(device, NULL);
 
-	if (device->bdev_file) {
+	if (device->bdev_file)
 		cur_devices->open_devices--;
-		/* remove sysfs entry */
-		btrfs_sysfs_remove_device(device);
-	}
+
+	/* remove sysfs entry, including for a missing device */
+	btrfs_sysfs_remove_device(device);
 
 	num_devices = btrfs_super_num_devices(fs_info->super_copy) - 1;
 	btrfs_set_super_num_devices(fs_info->super_copy, num_devices);
-- 
2.34.1

