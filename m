Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dd19832.kasserver.com ([85.13.140.27]:56629 "EHLO
	dd19832.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930Ab2J3MP3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 08:15:29 -0400
Message-ID: <508FC26A.1010206@pepinghege.net>
Date: Tue, 30 Oct 2012 13:04:58 +0100
From: Felix Pepinghege <postfach@pepinghege.net>
MIME-Version: 1.0
To: ching <lsching17@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Why btrfs inline small file by default?
References: <508FB45B.9040101@gmail.com>
In-Reply-To: <508FB45B.9040101@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi ching!

Am 30.10.2012 12:04, schrieb ching:
> Hi all,
>
> I am testing my btrfs root partition with "max_inline=0", and 64k leaf size for weeks and it seems that it is fine.
>
>
> AFAIK btrfs inline small files into metadata by default, I am curious why?
>
> If there is only a few small files, then there will be neither effect nor benefit at all

I disagree in this point. There will be a (probably huge) benefit in 
terms of performance. If the file data is inlined, you have a good 
chance (especially with large leaf sizes, although even then it is not 
guaranteed) that the data is in the same leaf as the inode element. So 
you already have the file data as you always access complete leafs. If 
you would store the data in extents, you would need to read the 
respective extent, which can be anywhere on the disk. That is, you most 
likely need to move the head. This brings overhead (especially with 
small files, as the reading process is relatively fast compared to the 
time you need to position the head).

> If there is a lot of small files, then the size of metadata will be undesirable due to deduplication

Yes, that is a fact, but if that really matters depends on the use-case 
(e.g., the small files to large files ratio, ...). But as btrfs is 
designed explicitly as a general purpose file system, you usually want 
the good performance instead of the better disk-usage (especially as 
disk space isn't expensive anymore).

>
> there are also some email threads related to problem of metadata inline (i don't know whether they are fixed in recent kernel):
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg16295.html
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg05265.html
>
> How about turning off inline so that btrfs works better "out of the box"?
>
> ching
>

Regards,
Felix

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
