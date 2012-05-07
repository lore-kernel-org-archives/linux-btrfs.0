From: "vivo75@gmail.com" <vivo75@gmail.com>
Subject: Re: btrfs and 1 billion small files
Date: Mon, 07 May 2012 13:05:23 +0200
Message-ID: <4FA7AC73.5080903@gmail.com>
References: <711331964.2091.1336382892940.JavaMail.root@zimbra.interconnessioni.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Alessio Focardi <alessiof@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <711331964.2091.1336382892940.JavaMail.root@zimbra.interconnessioni.it>
List-ID: <linux-btrfs.vger.kernel.org>

Il 07/05/2012 11:28, Alessio Focardi ha scritto:
> Hi,
>
> I need some help in designing a storage structure for 1 billion of small files (<512 Bytes), and I was wondering how btrfs will fit in this scenario. Keep in mind that I never worked with btrfs - I just read some documentation and browsed this mailing list - so forgive me if my questions are silly! :X
Are you *really* sure a database is *not* what are you looking for?

> On with the main questions, then:
>
> - What's the advice to maximize disk capacity using such small files, even sacrificing some speed?
>
> - Would you store all the files "flat", or would you build a hierarchical tree of directories to speed up file lookups? (basically duplicating the filesystem Btree indexes)
>
>
> I tried to answer those questions, and here is what I found:
>
> it seems that the smallest block size is 4K. So, in this scenario, if every file uses a full block I will end up with lots of space wasted. Wouldn't change much if block was 2K, anyhow.
>
> I tough about compression, but is not clear to me the compression is handled at the file level or at the block level.
>
> Also I read that there is a mode that uses blocks for shared storage of metadata and data, designed for small filesystems. Haven't found any other info about it.
>
>
> Still is not yet clear to me if btrfs can fit my situation, would you recommend it over XFS?
>
> XFS has a minimum block size of 512, but BTRFS is more modern and, given the fact that is able to handle indexes on his own, it could help us speed up file operations (could it?)
>
> Thank you for any advice!
>
> Alessio Focardi
> ------------------
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

