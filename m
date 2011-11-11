From: "Ken D'Ambrosio" <ken@jots.org>
Subject: Re: Stupid newb tricks: making a subvolume of root.
Date: Fri, 11 Nov 2011 14:06:42 -0500
Message-ID: <68365841c0d5cfbc86aff3e90dc407eb@www.jots.org>
References: <6c5dc86169d45cbc1001d0daa2d51a08@www.jots.org>,
        <20111110145944.GK28749@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=fixed
Cc: <linux-btrfs@vger.kernel.org>
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111110145944.GK28749@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 10 Nov 2011 14:59:44 +0000 Hugo Mills <hugo@carfax.org.uk> wrote

>    Alternatively, if you want the top level to be simply a container
> for subvolumes (and to use a default subvolume to mount / ), then you
> could do the switch-over by making a snapshot of your current /,
> remounting with the snapshot as / (possibly using "btrfs sub
> set-default"), and then mounting subvolid=0 on /media/btrfs-management
> to delete the old contents of /

So, I did this.  I think correctly:
mkdir /tmp/foo
mount /dev/sda1 /tmp/foo -o subvolid=0
And lo!  I did an ls, and everything was there.  And then the kernel panic'd. 
I rebooted, re-mounted, and it was there again.  And then the kernel panic'd. 
Last time, I didn't even try an ls -- I just did a "btrfs subvol list
/tmp/foo", and yet another panic.  This is running 3.2rc1 (with tools built off
 the git repository on kernel.org, if that makes any difference).

My system is, technically, working.  Any suggestions on how to get rid of my
old root?

Thanks...

-Ken





