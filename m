Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:50862 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaGEGXL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Jul 2014 02:23:11 -0400
Message-ID: <53B79AE4.3030404@libero.it>
Date: Sat, 05 Jul 2014 08:27:48 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Bob Williams <linux@barrowhillfarm.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: A question about subvolumes
References: <53B6BC65.3080302@barrowhillfarm.org.uk> <53B710C9.9020601@libero.it> <53B7176F.1020409@barrowhillfarm.org.uk>
In-Reply-To: <53B7176F.1020409@barrowhillfarm.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/04/2014 11:06 PM, Bob Williams wrote:
> On 04/07/14 21:38, Goffredo Baroncelli wrote:

> 
> Thank you, Goffredo. As the current /home/bob is not a subvolume, but
> a regular linux directory/folder, will the "cp --reflink" still carry
> the same speed advantage?
> 
> In other words, using your example above, will this work:
> 
> 	# cp --reflink -R normal_directory-A/* subvolume-B/
> 	# rm -rf normal_directory-A/

Yes.

If you want to move (or copy) files between subvolume, cp --reflink is faster.


I have to point out that the "--reflink" is only an internal detail. The two file are logically separated: if you after the copy change the source, the destination is unaffected.

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
