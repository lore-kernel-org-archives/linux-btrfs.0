From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: btrfs device scan
Date: 12 May 2011 06:46:00 +0200
Message-ID: <BljOh9kD1uB@helmut.hullen.de>
References: <4DCB615D.60300@gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DCB615D.60300@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Victor,

Du meintest am 12.05.11:

> I have a couple computers running 2.6.38
> (Ubuntu Natty 2.6.38-8-generic), and on both of them
> "btrfs device scan" comes back with nothing other than
> "failed to read /dev/sr0"

> One computer has a btrfs RAID-1 volume, and the other has two
> separate btrfs filesystems. The results are the same whether the
> filesystems are mounted or not.

What tells

        ls /dev/sd*
        ls /dev/md*

> Why is "btrfs device scan" not scanning the devices?

If I have understood the scan routine then it looks for all (?) block  
devices in "/dev".

Viele Gruesse!
Helmut
