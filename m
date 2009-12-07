From: Chris Mason <chris.mason@oracle.com>
Subject: Re: kernel .32, btrfs-vol -b, why is metadata=data
Date: Mon, 7 Dec 2009 10:38:49 -0500
Message-ID: <20091207153849.GA2859@think>
References: <3da3b5b40912060050s752b2ff1if19799c1e5d281da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Ahmed Kamal <email.ahmedkamal@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3da3b5b40912060050s752b2ff1if19799c1e5d281da@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 06, 2009 at 10:50:45AM +0200, Ahmed Kamal wrote:
> Hi everyone,
> 
> I'm running kernel 2.6.32-0.65.rc8.git5.fc13.x86_64. And I ran
> "btrfs-vol -b", however for 10G of data I still have 9G of metadata!
> How do I fix this ?
> 
> [root@matrix ~]# btrfs-vol -b /
> ioctl returns 0
> You have mail in /var/spool/mail/root
> [root@matrix ~]# btrfs-show
> failed to read /dev/sr0
> Label: none  uuid: 06b0d069-b1cb-48c4-b26f-c5088a2360d2
>         Total devices 1 FS bytes used 10.43GB
>         devid    1 size 25.72GB used 19.02GB path /dev/dm-1

Used means something different here than it does to df.  It just means
that we've preallocated 19GB of space on the drive as either data or
metadata, but it doesn't say if that space is actively used by the FS
yet or not.

In other words, btrfs-show could tell you that 19GB has been used, but
df could say that 0 bytes are in use in the FS.  This is because btrfs
allocates from devices to create chunks at a specific raid level and
then does suballocations inside those chunks.

-chris

