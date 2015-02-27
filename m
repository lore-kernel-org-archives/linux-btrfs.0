Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36814 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbbB0RwL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 12:52:11 -0500
Date: Fri, 27 Feb 2015 09:51:59 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        XFS Developers <xfs@oss.sgi.com>, linux-man@vger.kernel.org,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: Documenting MS_LAZYTIME
Message-ID: <20150227175159.GC11031@birch.djwong.org>
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
 <54E7578E.4090809@redhat.com>
 <20150221025636.GB7922@thunk.org>
 <54EEDE23.6080009@gmail.com>
 <20150226133113.GD11217@thunk.org>
 <54EF2161.90607@gmail.com>
 <20150227000409.GC17174@thunk.org>
 <54F02446.2050008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <54F02446.2050008@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 27, 2015 at 09:01:10AM +0100, Michael Kerrisk (man-pages) wrote:
> On 02/27/2015 01:04 AM, Theodore Ts'o wrote:
> > On Thu, Feb 26, 2015 at 02:36:33PM +0100, Michael Kerrisk (man-pages) wrote:
> >>
> >>     The disadvantage of MS_STRICTATIME | MS_LAZYTIME is that
> >>     in the case of a system crash, the atime and mtime fields
> >>     on disk might be out of date by at most 24 hours.
> > 
> > I'd change to "The disadvantage of MS_LAZYTIME is that..."  and
> > perhaps move that so it's clear it applies to any use of MS_LAZYTIME
> > has this as a downside.
> > 
> > Does that make sense?
> 
> Thanks, Ted. Got it. So, now we have:
> 
>        MS_LAZYTIME (since Linux 3.20)

"since Linux 4.0".

--D

>               Reduce  on-disk  updates  of  inode  timestamps  (atime,
>               mtime, ctime) by maintaining these changes only in  mem‐
>               ory.  The on-disk timestamps are updated only when:
> 
>               (a)  the inode needs to be updated for some change unre‐
>                    lated to file timestamps;
> 
>               (b)  the application  employs  fsync(2),  syncfs(2),  or
>                    sync(2);
> 
>               (c)  an undeleted inode is evicted from memory; or
> 
>               (d)  more  than 24 hours have passed since the inode was
>                    written to disk.
> 
>               This mount significantly reduces writes needed to update
>               the  inode's  timestamps,  especially  mtime  and atime.
>               However, in the event of a system crash, the  atime  and
>               mtime  fields  on  disk might be out of date by up to 24
>               hours.
> 
>               Examples of workloads where this option could be of sig‐
>               nificant  benefit include frequent random writes to pre‐
>               allocated files, as well as cases where the  MS_STRICTA‐
>               TIME  mount  option  is also enabled.  (The advantage of
>               (MS_STRICTATIME |  MS_LAZYTIME)  is  that  stat(2)  will
>               return  the  correctly  updated  atime,  but  the  atime
>               updates will be flushed to disk only when (1) the  inode
>               needs  to  be  updated for filesystem / data consistency
>               reasons or (2) the inode is pushed out of memory, or (3)
>               the filesystem is unmounted.)
> 
> Cheers,
> 
> Michael
> 
> 
> -- 
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
