Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:64201 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbbBHPRa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Feb 2015 10:17:30 -0500
MIME-Version: 1.0
Message-ID: <trinity-eca39016-0bbe-4b48-bf9b-0f8891294c3a-1423408648492@3capp-webde-bs08>
From: "Thomas Schneider" <c.monty@web.de>
To: linux-btrfs@vger.kernel.org
Subject: Replicate snapshot to second machine fails
Content-Type: text/plain; charset=UTF-8
Date: Sun, 8 Feb 2015 16:17:28 +0100
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hi,
 
I want to replicate a snapshot from PC1 to virtual machine using this command:

user@pc1-gigabyte ~ $ sudo btrfs send "/home/.snapshots/lmde_home_2015-02-07_02:38:21" | ssh vm1-debian sudo btrfs receive /home/.snapshots/
At subvol /home/.snapshots/lmde_home_2015-02-07_02:38:21
sudo: Kein TTY vorhanden und kein »askpass«-Programm angegeben
 
Unfortunately I cannot detect the root cause for the failure.
Any ideas?
 
On both machines I have installed programs ssh-askpass and ssh-askpass-gnome.
 

user@pc1-gigabyte ~ $ uname -a
Linux pc1-gigabyte 3.16.0-4-686-pae #1 SMP Debian 3.16.7-ckt2-1 (2014-12-08) i686 GNU/Linux
user@pc1-gigabyte ~ $ sudo btrfs --version
Btrfs v3.17
user@pc1-gigabyte ~ $ sudo btrfs fi show
Label: none  uuid: 236fe36a-3187-4955-977d-f22cd818c424
    Total devices 1 FS bytes used 103.96GiB
    devid    1 size 147.00GiB used 147.00GiB path /dev/sda5
Btrfs v3.17
user@pc1-gigabyte ~ $ sudo btrfs fi df /home
Data, single: total=142.97GiB, used=103.03GiB
System, DUP: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=2.00GiB, used=957.17MiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=320.00MiB, used=0.00B
 
