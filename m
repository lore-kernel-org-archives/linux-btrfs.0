Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outbound-queue-2.mail.thdo.gradwell.net ([212.11.70.35]:35693
	"EHLO outbound-queue-2.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030227AbbDYQCm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Apr 2015 12:02:42 -0400
Received: from outbound-edge-2.mail.thdo.gradwell.net (bonnie.gradwell.net [212.11.70.2])
	by outbound-queue-2.mail.thdo.gradwell.net (Postfix) with ESMTP id C05FC553E8
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Apr 2015 17:02:40 +0100 (BST)
Message-ID: <553BBAA0.4060100@barrowhillfarm.org.uk>
Date: Sat, 25 Apr 2015 17:02:40 +0100
From: Bob Williams <linux@barrowhillfarm.org.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs filesystem for /home has become readonly
References: <553B6BEB.9050000@barrowhillfarm.org.uk>
In-Reply-To: <553B6BEB.9050000@barrowhillfarm.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25/04/15 11:26, Bob Williams wrote:
> My system is openSUSE 13.2, using kernel 3.16.7-21-desktop. I recently
> had to reinstall the system, since when /home has become readonly. /home
> is a btrfs raid1 array, mirroring both data and metadata.
>
> btrfs check run on unmounted /home gives line after line of parent
> transid verification failures. The last few lines are retyped below (I'm
> sending this from a different machine):
>
> ...
> parent transid verify failed on 222388969472 wanted 658362 found 656682
> parent transid verify failed on 4028227584 wanted 658356 found 657902
> root 2778 inode 3051948 errors 400, nbytes wrong
> warning line 2104
> found 548489650966 bytes used err is 1
> total csum bytes: 1166534872
> total tree bytes: 2437394432
> total fs tree bytes: 803016704
> total extent tree bytes: 149839872
> btree space waste bytes: 443944348
> file data blocks allocated: 3915207680000
>   referenced 1695262269440
> Btrfs v3.16.2+20141003
> :~ #
>
> How can I repair this filesystem?
>
> Many thanks

The results of btrfs check seem to be the same, whichever device I run 
the check on. I presume that's because it's raid1, and the filesystem is 
distributed across both devices. Before this problem arose, I was 
running scrub once a week.

What is the current recommendation regarding btrfs check --repair?

-- 
Bob Williams
