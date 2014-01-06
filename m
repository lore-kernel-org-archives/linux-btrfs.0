Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:33326 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517AbaAFTbS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 14:31:18 -0500
Received: from [192.168.0.50] (mail.coastalscience.com [66.83.151.234])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: jim@jrs-s.net)
	by mail.jrs-s.net (Postfix) with ESMTPSA id 6C5D5D2A4
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Jan 2014 14:31:17 -0500 (EST)
Message-ID: <52CB0484.8030806@jrs-s.net>
Date: Mon, 06 Jan 2014 14:31:16 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: correct way to rollback a root filesystem?
References: <52C73987.7000106@jrs-s.net> <52C87A41.9030701@jrs-s.net> <05C97109-682D-4A62-B074-4EDCF8E9CE1E@colorremedies.com> <1416119.lWHlh5idGF@quad> <C7E0F781-5F46-4C76-BCC9-0DE416553046@colorremedies.com>
In-Reply-To: <C7E0F781-5F46-4C76-BCC9-0DE416553046@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list -

I tried a kernel upgrade with moderately disastrous (non-btrfs-related) 
results this morning; after the kernel upgrade Xorg was completely 
borked beyond my ability to get it working properly again through any 
normal means. I do have hourly snapshots being taken by cron, though, so 
I'm successfully X'ing again on the machine in question right now.

It was quite a fight getting back to where I started even so, though - 
I'm embarassed to admit I finally ended up just doing a cp --reflink=all 
/mnt/@/.snapshots/snapshotname /mnt/@/ from the initramfs BusyBox 
prompt.  Which WORKED well enough, but obviously isn't ideal.

I tried the btrfs sub set-default command - again from BusyBox - and it 
didn't seem to want to work for me; I got an inappropriate ioctl error 
(which may be because I tried to use / instead of /mnt, where the root 
volume was CURRENTLY mounted, as an argument?). Before that, I'd tried 
setting subvol=@root (which is the writeable snapshot I created from the 
original read-only hourly snapshot I had) in GRUB and in fstab... but 
that's what landed me in BusyBox to begin with.

When I DID mount the filesystem in BusyBox on /mnt, I saw that @ and 
@home were listed under /mnt, but no other "directories" were - which 
explains why mounting -o subvol=@root didn't work. I guess the question 
is, WHY couldn't I see @root in there, since I had a working, readable, 
writeable snapshot which showed its own name as "root" when doing a 
btrfs sub show /.snapshots/root ?

Thanks.
