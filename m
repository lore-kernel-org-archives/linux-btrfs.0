Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33404 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbaHSDcY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Aug 2014 23:32:24 -0400
Received: by mail-pa0-f49.google.com with SMTP id hz1so9055847pad.22
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Aug 2014 20:32:24 -0700 (PDT)
Received: from localhost ([203.114.244.88])
        by mx.google.com with ESMTPSA id pr5sm17631304pbb.53.2014.08.18.20.32.21
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Aug 2014 20:32:23 -0700 (PDT)
Date: Tue, 19 Aug 2014 11:32:16 +0800
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [BUG] cannot mount subvolume with selinux context
Message-ID: <20140819033216.GB3013@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Description of the problem:

mount btrfs with selinux context, then create a subvolume, the new
subvolume cannot be mounted, even with the same context.

mkfs -t btrfs /dev/sda5
mount -o context=system_u:object_r:nfs_t:s0 /dev/sda5 /mnt/btrfs
btrfs subvolume create /mnt/btrfs/subvol
mount -o subvol=subvol,context=system_u:object_r:nfs_t:s0 /dev/sda5 /mnt/test

The last mount fails, and dmesg shows:
SELinux: mount invalid.  Same superblock, different security settings for (dev sda5, type btrfs)

But in fact, the security settings are the same.

from fs/super.c

struct dentry *
mount_fs(struct file_system_type *type, int flags, const char *name, void *data)
{
        struct dentry *root;
        struct super_block *sb;
        char *secdata = NULL;
        int error = -ENOMEM;

        if (data && !(type->fs_flags & FS_BINARY_MOUNTDATA)) {
                secdata = alloc_secdata();
                if (!secdata)
                        goto out;

                error = security_sb_copy_data(data, secdata);
                if (error)
                        goto out_free_secdata;
        }

        root = type->mount(type, flags, name, data);

The security_sb_copy_data() takes out selinux context data to
"secdata", then mount_subvol() calls mount_fs() (via vfs_kern_mount())
again without selinux context, so mount_subvol() fails, which fails
the whole mount.

Not sure what's the proper fix. Zach suggestted that the fix will
probably be to rework the vfs functions a bit as he said in rh
bugzilla[1].

Thanks,
Eryu

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1130860
