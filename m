From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: free space inode generation
Date: Tue, 24 May 2011 12:10:38 +0000 (UTC)
Message-ID: <irg77u$r3s$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am getting following errors in the syslog 
(running 2.6.39-gentoo kernel, latest git btrfs-progs, 
mounted with -o space_cache)

btrfs: free space inode generation (0) did not match free space cache 
generation (325850) for block group 29360128
btrfs: free space inode generation (0) did not match free space cache 
generation (325850) for block group 55863934976
btrfs: free space inode generation (0) did not match free space cache 
generation (325865) for block group 63380127744

The filesystem is mountable and basically usable, only *very* slow and
taking resources (load around 7 or more).

Should I ignore the messages or is there something wrong and I can
do something about it?

Thank you

Lubos

