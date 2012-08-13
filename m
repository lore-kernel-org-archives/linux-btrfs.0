Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.robertbuhren.de ([91.190.225.190]:40469 "EHLO
	mail.robertbuhren.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2HMK3e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Aug 2012 06:29:34 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.robertbuhren.de (Postfix) with ESMTP id 9EFE26B2DC
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Aug 2012 12:23:11 +0200 (CEST)
Received: from mail.robertbuhren.de ([127.0.0.1])
	by localhost (mail.robertbuhren.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Zy5d5oaV1MCY for <linux-btrfs@vger.kernel.org>;
	Mon, 13 Aug 2012 12:22:59 +0200 (CEST)
Received: from [192.168.2.2] (a89-182-199-186.net-htp.de [89.182.199.186])
	by mail.robertbuhren.de (Postfix) with ESMTPSA id 67AE16B2DB
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Aug 2012 12:22:59 +0200 (CEST)
Message-ID: <5028D57F.5090803@robertbuhren.de>
Date: Mon, 13 Aug 2012 12:22:55 +0200
From: Robert Buhren <robert@robertbuhren.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Testing new send/receive: "ERROR: could not resolve root_id for"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

i wanted to test the new send/receive feature and i can't manage to send 
a snapshot to a file. I always get the error
"ERROR: could not resolve root_id for".

I'm using kernel 3.6-rc1 and the latest btrfs progs from git.

This is what i'm doing:

mount -o subvolid=0,discard,compress=lzo /dev/sda4 /mnt/ROOT_BTRFS

[root@robert-laptop mnt]# /home/robert/ArchLinux/btrfs-progs/btrfs 
subvolume list ROOT_BTRFS/
ID 256 top level 5 path btrfs_root <--- my rootfs subvolume
ID 265 top level 5 path btrfs_root-11082012-0023      <--- a "normal" 
snapshot"
ID 268 top level 5 path root_send <--- a read only snapshot i try to use 
with send

[root@robert-laptop ~]# cd /mnt/ROOT_BTRFS/
[root@robert-laptop ROOT_BTRFS]# 
/home/robert/ArchLinux/btrfs-progs/btrfs send root_send > outROOT
At subvol root_send
ERROR: could not resolve root_id for /mnt/ROOT_BTRFS/root_send

Am i somehow misunderstanding how the send/receive feature should work? 
My idea is to send the "root_send" snapshot to a file and then replay 
that file later on a backup btrfs partition. Once i've done that i can 
just send incremental differences to the backup partition. Is that how 
"send/receive" is supposed to work?

If you need further information just tell me.

Thanks in advance,

Robert


PS: Please respond to my email address as i'm not subscribed to the list.

