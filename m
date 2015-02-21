Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:40871 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbbBUH5I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Feb 2015 02:57:08 -0500
Message-ID: <54E83A51.6000807@gmail.com>
Date: Sat, 21 Feb 2015 08:57:05 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>
CC: mtk.manpages@gmail.com, Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        XFS Developers <xfs@oss.sgi.com>, linux-man@vger.kernel.org,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: Documenting MS_LAZYTIME
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com> <54E7578E.4090809@redhat.com>
In-Reply-To: <54E7578E.4090809@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/20/2015 04:49 PM, Eric Sandeen wrote:
> On 2/20/15 2:50 AM, Michael Kerrisk wrote:
>> Hello Ted,
>>
>> Based on your commit message 0ae45f63d4e, I I wrote the documentation
>> below for MS_LAZYTIME, to go into the mount(2) man page. Could you
>> please check it over and let me know if it's accurate. In particular,
>> I added pieces marked with "*" below that were not part of the commit
>> message and I'd like confirmation that they're accurate.
>>
>> Thanks,
>>
>> Michael
>>
>> [[
>>        MS_LAZYTIME (since Linux 3.20)
>>               Only  update  filetimes (atime, mtime, ctime) on the in-
>>               memory version of the file  inode.   The  on-disk  time‐
>>               stamps are updated only when:
> 
> "filetimes" and "file inode" seems a bit awkward.  How about:
> 
>>        MS_LAZYTIME (since Linux 3.20)
>> 		Reduce on-disk updates of inode timestamps (atime, mtime, ctime)
>> 		by maintaining these changes only in memory, unless:
> 
> (maybe I'm bike-shedding too much, if so, sorry).

Nah it''s the good sort of bikeshedding ;-). "filetimes" was a wordo--I 
meant "timestamps". I've taken your wording mostly.

> 
>>               (a)  the inode needs to be updated for some change unre‐
>>                    lated to file timestamps;
>>
>>               (b)  the application  employs  fsync(2),  syncfs(2),  or
>>                    sync(2);
>>
>>               (c)  an undeleted inode is evicted from memory; or
>>
>> *             (d)  more than 24 hours have passed since the i-node was
>> *                  written to disk.
> 
> Please don't use "i-node" - simply "inode" is much more common in the manpages
> AFAICT.

Yup, that was a typo. Fixed.

>>               This mount option significantly reduces  writes  to  the
>>               inode  table  for workloads that perform frequent random
>>               writes to preallocated files.
> 
> This seems like an overly specific description of a single workload out
> of many which may benefit, but what do others think?  

Fair enough. I reworded that to note it as an example.

> "inode table" is also fairly extN-specific.

I'll await further input on that point.

Now we have:

       MS_LAZYTIME (since Linux 3.20)
              Reduce  on-disk  updates  of  inode  timestamps  (atime,
              mtime, ctime) by maintaining these changes only in  mem‐
              ory.  The on-disk timestamps are updated only when:

              (a)  the inode needs to be updated for some change unre‐
                   lated to file timestamps;

              (b)  the application  employs  fsync(2),  syncfs(2),  or
                   sync(2);

              (c)  an undeleted inode is evicted from memory; or

              (d)  more  than 24 hours have passed since the inode was
                   written to disk.

              This mount option significantly reduces  writes  to  the
              inode  table  for  some workloads (e.g., when performing
              frequent random writes to preallocated files).

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
