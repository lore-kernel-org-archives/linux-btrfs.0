From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Fsck, parent transid verify failed
Date: Thu, 02 Dec 2010 11:21:23 -0500
Message-ID: <1291306826-sup-7837@think>
References: <003501cb9147$09197540$1b4c5fc0$@gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tommy Jonsson <quazzie@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <003501cb9147$09197540$1b4c5fc0$@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Tommy Jonsson's message of 2010-12-01 06:00:56 -0500:
> Hi folks!
> 
> Been using btrfs for quite a while now, worked great until now. 
> Got power-loss on my machine and now i have the "parent transid verify
> failed on X wanted X found X" problem.
> So I can't get it to mount.
> 
> My btrfs is spread over sda (2tb), sdc(2tb), sdd(1tb).
> 
> Is this something that an offline fsck could fix ? 
> If so is the fsck-util being developed ?
> Is there a way to mount the FS in a read-only mode or something to rescue
> the data ?

Which kernel are you on?  Unless you formatted with -m raid0, the
current git tree should be able to read this FS by using the second copy
of the metadata.

-chris
