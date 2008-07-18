From: Linda Knippers <linda.knippers@hp.com>
Subject: Re: btrfsctl -A not returning useful information
Date: Fri, 18 Jul 2008 13:50:14 -0400
Message-ID: <4880D7D6.8040006@hp.com>
References: <3da3b5b40807181028p42e1a15di938dc62cccbc766c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Ahmed Kamal <email.ahmedkamal@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3da3b5b40807181028p42e1a15di938dc62cccbc766c@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Ahmed Kamal wrote:
> [root@btrfs progs-unstable]# btrfsctl -A /dev/sdb
> ioctl returns 0
> [root@btrfs progs-unstable]# btrfsctl -A /dev/sdc
> ioctl returns 0
> 
> 
> /dev/sdb has a btrfs, while /dev/sdc is blank. What's that output
> supposed to mean ? Is it a bug ?

I think not so much of a bug as not completely implemented.
If you look in /var/log/messages or where every your kernel
messages go, you'll see information about the file system on
the device.  At least that's how it worked for me.

-- ljk
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

