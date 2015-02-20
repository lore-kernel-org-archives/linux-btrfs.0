Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbbBTPto (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Feb 2015 10:49:44 -0500
Message-ID: <54E7578E.4090809@redhat.com>
Date: Fri, 20 Feb 2015 09:49:34 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Michael Kerrisk <mtk.manpages@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>
CC: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        XFS Developers <xfs@oss.sgi.com>, linux-man@vger.kernel.org,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: Documenting MS_LAZYTIME
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
In-Reply-To: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/20/15 2:50 AM, Michael Kerrisk wrote:
> Hello Ted,
> 
> Based on your commit message 0ae45f63d4e, I I wrote the documentation
> below for MS_LAZYTIME, to go into the mount(2) man page. Could you
> please check it over and let me know if it's accurate. In particular,
> I added pieces marked with "*" below that were not part of the commit
> message and I'd like confirmation that they're accurate.
> 
> Thanks,
> 
> Michael
> 
> [[
>        MS_LAZYTIME (since Linux 3.20)
>               Only  update  filetimes (atime, mtime, ctime) on the in-
>               memory version of the file  inode.   The  on-disk  time‐
>               stamps are updated only when:

"filetimes" and "file inode" seems a bit awkward.  How about:

>        MS_LAZYTIME (since Linux 3.20)
>		Reduce on-disk updates of inode timestamps (atime, mtime, ctime)
> 		by maintaining these changes only in memory, unless:

(maybe I'm bike-shedding too much, if so, sorry).

>               (a)  the inode needs to be updated for some change unre‐
>                    lated to file timestamps;
> 
>               (b)  the application  employs  fsync(2),  syncfs(2),  or
>                    sync(2);
> 
>               (c)  an undeleted inode is evicted from memory; or
> 
> *             (d)  more than 24 hours have passed since the i-node was
> *                  written to disk.

Please don't use "i-node" - simply "inode" is much more common in the manpages
AFAICT.

>               This mount option significantly reduces  writes  to  the
>               inode  table  for workloads that perform frequent random
>               writes to preallocated files.

This seems like an overly specific description of a single workload out
of many which may benefit, but what do others think?  "inode table" is also
fairly extN-specific.

-Eric
 
> *             As at Linux 3.20, this option is supported only on ext4.
> ]]
> 

