Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:45189 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220Ab3KGXpf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Nov 2013 18:45:35 -0500
Received: from cloud.myjm.de (37-5-161-32-dynip.superkabel.de [37.5.161.32])
	by smtp.strato.de (RZmta 32.12 DYNA|AUTH)
	with (TLSv1.2:DHE-RSA-AES256-GCM-SHA384 encrypted) ESMTPSA id Y02943pA7NjWBbK
	for <linux-btrfs@vger.kernel.org>; Fri, 8 Nov 2013 00:45:32 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 08 Nov 2013 00:45:32 +0100
From: =?UTF-8?Q?Michael_G=C3=B6hler?= <visit@myjm.de>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Question about btrfs as root filesystem
Message-ID: <5eb6a9cbd3a163b70c9cfe4a1b46a1fa@myjm.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm a contributor of the Arch Linux package mkinitcpio-btrfs [1]. The 
goal of this hook is to provide Btrfs rollback support for root 
filesystems directly from initrd.

Technically we are using a subvolume to store the root filesystem. The 
user can snapshot it entirely and boot from this snapshot. In case of 
rollback our hook snapshots the snapshot again, to keep its original 
unchanged. The boot subvolume is then set with 'btrfs subvolume 
set-default' and mounted without subvol/subvolid option by Arch's 
default mount handler. That way, we ensure the best compatibility and 
lowest maintenance, as we don't overwrite default init functions.

Assuming we have the following setup:

# btrfs su li -p /
ID 256 gen 86 parent 5 top level 5 path root
ID 259 gen 86 parent 256 top level 256 path var
ID 260 gen 86 parent 256 top level 256 path usr

The use case for that is to set quotas for the child subvolumes.

Now, if we snapshots the root subvolume, the child subvolumes are not 
snapshoted with it. There is no back reference which would allow Btrfs 
to auto-mount the original child subvolumes when we mount the snapshot 
as new root filesystem. Of cause we could snapshot the childs separately 
into their desired directories. But this would not help, because our 
hook snapshots the snapshot again, to keep it's original untouched while 
rolling back. And we don't have fstab to find out the correct mount 
points at this early boot stage.

Atm. all scenarios results in /usr/bin/init not found.

So here comes my question:
Wouldn't it be helpful to add a --recursive option to 'btrfs subvolume 
snapshot' to snapshot child subvolumes together with their parent?
Or maybe it is possible to add some functionality to reference the child 
subvolumes on the snapshots fs-tree to allow auto-mounting?

I appreciate other ideas or opinions too.

Thanks,
Michael

[1] https://aur.archlinux.org/packages/mkinitcpio-btrfs/
