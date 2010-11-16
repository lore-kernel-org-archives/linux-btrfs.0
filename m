From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: mkfs.btrfs on 24 disks in parallel crashes kernel
Date: Tue, 16 Nov 2010 08:52:27 +0800
Message-ID: <4CE1D5CB.1020909@cn.fujitsu.com>
References: <AANLkTi=zjPYJ1rbb0GbYVEFQsL+cEb4NZufmL4tTxBet@mail.gmail.com> <1289275800.9102.16.camel@localhost> <1289289147.9102.21.camel@localhost> <1289830902.3248.85.camel@localhost> <20101115164834.GA2597@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ian Kent <raven@themaw.net>, Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org, Albert Strasheim <fullung@gmail.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101115164834.GA2597@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

> So I think we're on the same page for this problem, I've posted a test patch to
> the bugzilla
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=650261
> 
> Basically we just need to setup a blank root/fs_info so it can be set in
> set_super, and then we use those blank structs in open_ctree.  Hopefully this
> works, if it does I'll post it to the list for wider review.
> 

You can reproduce the bug easily by this simple script:

# cat test.sh
#! /bin/sh

for ((; ;))
{
    mount $1 $2
    umount $2
}

Now run the test (I was using loop devices):

# ./test.sh /dev/loop1 /mnt1 &
# ./test.sh /dev/loop2 /mnt2

(You'll get exactly the same crash)
