From: Marco Neubauer <icetea1@gmx.net>
Subject: Re: kernel BUG at fs/btrfs/inode.c:2271!
Date: Fri, 27 May 2011 21:23:11 +0200
Message-ID: <D6012E08-3AC7-4C9A-88DE-42BBDFA40CCB@gmx.net>
References: <383ECFA9-9E51-4CCD-BE24-21FD30813217@gmx.net> <4DC0170C.8000906@redhat.com> <63FD432D-9173-40E4-9A82-711C8C625B0E@gmx.net> <4DDAB207.6060500@redhat.com> <8E5549B7-EBD9-4D7C-87FA-4C49D1C453F8@gmx.net> <4DDD57B5.4070309@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DDD57B5.4070309@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>


Am 25.05.2011 um 21:25 schrieb Josef Back:
> 
> Hrm well that's doubly weird, the root should be right so it should be
> able to find the orphan item to delete it for the bad inode, and why the
> hell are we looping on that orphan item?  Remove the previous patch I
> gave you and apply this one instead and run with this please and provide
> me the log.  Sorry in advance, it will likely give you a giant log file
> again.  Thanks,

The system didn't crash until now and all I got in the log was the following output.
This is the expected correct behavior?

May 26 03:10:13 mainframe kernel: found orphan item for 909457 on 267
May 26 03:10:13 mainframe kernel: lookup of inode was from disk
May 26 03:10:13 mainframe kernel: inode needs to be truncated
May 26 03:10:13 mainframe kernel: drop is 0
May 26 03:10:13 mainframe kernel: found orphan item for 909415 on 267
May 26 03:10:13 mainframe kernel: lookup of inode was from disk
May 26 03:10:13 mainframe kernel: inode needs to be unlinked
May 26 03:10:13 mainframe kernel: drop is 1
May 26 03:10:13 mainframe kernel: found orphan item for 909414 on 267
May 26 03:10:13 mainframe kernel: lookup of inode was from disk
May 26 03:10:13 mainframe kernel: inode needs to be unlinked
May 26 03:10:13 mainframe kernel: drop is 1
May 26 03:10:13 mainframe kernel: found orphan item for 899452 on 267
May 26 03:10:13 mainframe kernel: lookup of inode was from disk
May 26 03:10:13 mainframe kernel: inode needs to be unlinked
May 26 03:10:13 mainframe kernel: drop is 1
May 26 03:10:13 mainframe kernel: found orphan item for 899451 on 267
May 26 03:10:13 mainframe kernel: lookup of inode was from disk
May 26 03:10:13 mainframe kernel: inode needs to be unlinked
May 26 03:10:13 mainframe kernel: drop is 1
May 26 03:10:13 mainframe kernel: btrfs: unlinked 4 orphans
May 26 03:10:13 mainframe kernel: btrfs: truncated 1 orphans
May 26 03:10:46 mainframe kernel: drop is 0

I'll keep an eye on it.

-marco



