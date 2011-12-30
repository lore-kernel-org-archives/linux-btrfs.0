From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: data integrity in btrfs
Date: Fri, 30 Dec 2011 14:44:47 +0100
Message-ID: <brr0t8-c3q.ln1@hurikhan.ath.cx>
References: <135528.24428.61333-23184-1070446607-1325251786@email.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

As long as you create your data and metadata with a mirror policy, you can 
use btrfs scrubbing to find and correct broken data blocks. I think latest 
kernels also so this "repairing" online.

It works by finding a mirrored block with correct checksum if the block in 
question has a bad checksum.

Jaromir Zdrazil <jaromir.zdrazil@email.cz> schrieb:

> Hi again,
> 
>    I know that ZFS include data integrity verification against data
>    corruption modes using propably SHA256.
> 
>    By sketchy readings at https://btrfs.wiki.kernel.org/index.html ,
>    http://en.wikipedia.org/wiki/Btrfs and other sources I have found just
>    that there is Sha32C used and that it should be similar to ZFS.
> 
>    How are data faults detected and repaired ni BRTFS? If the answer could
>    be simple and precize, I would be more than happy.
> 
> Thank you! Gone to lunch ;O)
> 
> Jaromir
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


