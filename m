Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35695 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbbBTMdD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Feb 2015 07:33:03 -0500
Received: by padfa1 with SMTP id fa1so7804795pad.2
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Feb 2015 04:33:02 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Subject: Re: Documenting MS_LAZYTIME
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
Date: Fri, 20 Feb 2015 05:32:58 -0700
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        XFS Developers <xfs@oss.sgi.com>, linux-man@vger.kernel.org,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Message-Id: <44893EA7-B11A-469A-9911-6CE2E8B26EB4@dilger.ca>
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Feb 20, 2015, at 1:50 AM, Michael Kerrisk <mtk.manpages@gmail.com> wrote:
> 
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
>       MS_LAZYTIME (since Linux 3.20)
>              Only  update  filetimes (atime, mtime, ctime) on the in-
>              memory version of the file  inode.   The  on-disk  time‐
>              stamps are updated only when:
> 
>              (a)  the inode needs to be updated for some change unre‐
>                   lated to file timestamps;
> 
>              (b)  the application  employs  fsync(2),  syncfs(2),  or
>                   sync(2);
> 
>              (c)  an undeleted inode is evicted from memory; or
> 
> *             (d)  more than 24 hours have passed since the i-node was
> *                  written to disk.
> 
>              This mount option significantly reduces  writes  to  the
>              inode  table  for workloads that perform frequent random
>              writes to preallocated files.
> 
> *             As at Linux 3.20, this option is supported only on ext4.

I _think_ that the lazytime mount option is generic for all filesystems.
I believe ext4 has an extra optimization for it, but that's it.

Cheers, Andreas





