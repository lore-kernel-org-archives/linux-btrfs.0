Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35254 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475AbbBDXAJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Feb 2015 18:00:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YJ8vU-0008Qw-GW
	for linux-btrfs@vger.kernel.org; Thu, 05 Feb 2015 00:00:04 +0100
Received: from moeller.plus.com ([81.174.172.105])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Feb 2015 00:00:04 +0100
Received: from huaraz by moeller.plus.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Feb 2015 00:00:04 +0100
To: linux-btrfs@vger.kernel.org
From: "Markus Moeller" <huaraz@moeller.plus.com>
Subject: Btrfs subvolume question
Date: Wed, 4 Feb 2015 22:54:49 -0000
Message-ID: <mau7vs$pjj$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi ,

   I am new to btrfs and wonder what I need to do to move subvolumes to the 
right filesystem.  I see the following:

df -h
Filesystem                       Size  Used Avail Use% Mounted on
/dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /
devtmpfs                         235M  8.0K  235M   1% /dev
tmpfs                            242M   84K  242M   1% /dev/shm
tmpfs                            242M  2.4M  240M   1% /run
tmpfs                            242M     0  242M   0% /sys/fs/cgroup
/dev/mapper/system_13.2-usr_lv    18G  6.9G   10G  41% /usr
/dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /srv
/dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /.snapshots
/dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /tmp
/dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /usr/local
/dev/sda2                        486M   59M  398M  13% /boot
/dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% 
/boot/grub2/x86_64-efi
/dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /boot/grub2/i386-pc
/dev/mapper/export_vg-export_lv   20G   18G  2.9G  86% /export
/dev/mapper/export_vg-src_lv     5.0G  2.6G  2.5G  51% /src
/dev/mapper/system_13.2-var_lv   4.0G  196M  3.4G   6% /var
/dev/mapper/system_13.2-opt_lv   6.0G  152M  5.3G   3% /opt
/dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /var/spool
/dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /var/tmp
/dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /var/opt
/dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /var/log
/dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /var/lib/named
/dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /var/lib/mailman
/dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /var/lib/pgsql


and I would like to have all the var subvolumes using the /var filesystem 
space and not root.   The same for /boot/grub2 subvolumes. They should use 
the /boot filesystem.   I don't know how I got to this and don't know how to 
change.

# cat /etc/fstab
UUID=d300b5ad-372b-4f86-b952-4aa4fc62a84e swap swap defaults 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f / btrfs defaults 0 0
UUID=fd14684f-1950-4f33-95b5-b54f069b4fe0 /boot ext4 acl,user_xattr 1 2
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /boot/grub2/i386-pc btrfs 
subvol=boot/grub2/i386-pc 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /boot/grub2/x86_64-efi btrfs 
subvol=boot/grub2/x86_64-efi 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /home btrfs subvol=home 0 0
UUID=f535177b-18a5-443c-8236-96105d58a621 /opt btrfs defaults 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /srv btrfs subvol=srv 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /tmp btrfs subvol=tmp 0 0
UUID=62ffc2f3-7e3a-433e-8a4e-5a89a352f8cf /usr btrfs defaults 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /usr/local btrfs subvol=usr/local 
0 0
UUID=323ba68a-e7ed-4f0f-9716-dcad92bb9808 /var btrfs defaults 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /var/crash btrfs subvol=var/crash 
0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /var/lib/mailman btrfs 
subvol=var/lib/mailman 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /var/lib/named btrfs 
subvol=var/lib/named 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /var/lib/pgsql btrfs 
subvol=var/lib/pgsql 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /var/log btrfs subvol=var/log 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /var/opt btrfs subvol=var/opt 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /var/spool btrfs subvol=var/spool 
0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /var/tmp btrfs subvol=var/tmp 0 0
/dev/export_vg/export_lv /export xfs defaults 1 2
/dev/export_vg/src_lv /src xfs defaults 1 2
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /.snapshots btrfs 
subvol=.snapshots 0 0

Thank you
Markus 


