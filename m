Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:55681 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbaGDUd4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 16:33:56 -0400
Message-ID: <53B710C9.9020601@libero.it>
Date: Fri, 04 Jul 2014 22:38:33 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Bob Williams <linux@barrowhillfarm.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: A question about subvolumes
References: <53B6BC65.3080302@barrowhillfarm.org.uk>
In-Reply-To: <53B6BC65.3080302@barrowhillfarm.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/04/2014 04:38 PM, Bob Williams wrote:
> I have a disc formatted as btrfs, on which is mounted /home.
> 
> /home/bob is a regular directory.
> 
> /home/bob/Documents is a btrfs subvolume
> 
> /home is btrfs root
> 
> If I do
> 
> # mv /home/bob /home/bob_original
> # btrfs subvolume create /home/bob
> # mv /home/bob_original/* /home/bob/
> # rm /home/bob_original
> 
> will the original subvolume /home/bob/Documents survive this
> operation, and will it now exist as a subvolume under the new
> subvolume /home/bob?

Yes. 

A subvolume is a way to partition a btrfs file-system. You can think a subvolume like a filesystem. 
For objects like files and directory a move command between *different* subvolumes is equal to a copy+remove. If fact is like you are moving data between different file-systems.

Instead moving a subvolume  in *its btrfs filesystem* is a cheap operation (is like moving a link); this is true even if you move a subvolume between different subvolumes.

To increase the speed when you move files between subvolumes (of the *same* btrfs filesystem), you could do a "cp --reflink" + "rm" instead of a "mv"; eg

	# mv subvolume-A/* subvolume-B/

is equal to

	# cp -rf  subvolume-A/* subvolume-B/
	# rm -rf subvolume-A/*

but 
	# cp --reflink -R  subvolume-A/* subvolume-B/
	# rm -rf subvolume-A/

is faster  because "cp --reflink" shared the data between source and destination. This means that you are doing a copy (and a delete) of metadata only.




> 
> I realise it's best to create subvolumes progressively from the top of
> the filesystem tree, but this system originated as an ext4fs which was
> migrated to btrfs, and some sensible things got missed in all the
> excitement. ;-)
> 
> Bob
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
