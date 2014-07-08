Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay06.libero.it ([212.52.84.110]:47291 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaGHECj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jul 2014 00:02:39 -0400
Message-ID: <53BB6E7B.6080205@libero.it>
Date: Tue, 08 Jul 2014 06:07:23 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes with
 different ro/rw options"
References: <1404207001-7510-1-git-send-email-quwenruo@cn.fujitsu.com>	<53B445F5.6060709@libero.it> <53B4A3C7.1020805@cn.fujitsu.com>	<53B594E7.9070500@inwind.it> <53B6032D.6090207@cn.fujitsu.com>	<53B6E744.1060204@inwind.it> <53B9FBE4.6040300@cn.fujitsu.com>	<53BADAF1.80803@inwind.it> <pan$5e578$d83c9a0b$aad1fa2b$9a41848@cox.net>
In-Reply-To: <pan$5e578$d83c9a0b$aad1fa2b$9a41848@cox.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/08/2014 04:43 AM, Duncan wrote:
> The remaining problem to deal with is that if say the root subvol (id=5) 
> is mounted rw,subvolmode=rw, while a subvolume below it is mounted 
> subvolmode=ro, then what happens if someone tries to make an edit in the 
> portion of the filesystem visible in the subvolume, but from the parent, 
> id=5/root in this case?  Obviously if that modification is allowed from 
> the parent, it'll change what's visible in the child subvolume as well, 
> which would be rather unexpected.

The ro/rw status is a subvolume flag.
So if a subvolume is marked rw (or ro), is writable (not writable) in all
the mount(S)
This flag is not inheritable.

What could be strange is the following:

      # mount -o subvolid=5,rw /dev/sda1 /mnt/btrfs-root
      # btrfs subvol create /mnt/btrfs-root/subvolname/
then
      # touch /mnt/btrfs-root/subvolname/touch-file

succeeds; but

      # mount -o subvolid=5,rw /dev/sda1 /mnt/btrfs-root
      # btrfs subvol create /mnt/btrfs-root/subvolname/
      # mount -o subvol=subvolname,ro /dev/sda1 /mnt/btrfs-subvol
then
      # touch /mnt/btrfs-root/subvolname/touch-file2

fails.




-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
