From: Svein Erik Brostigen <svein.brostigen@oracle.com>
Subject: Re: Free space left
Date: Sat, 16 Jan 2010 14:31:44 -0500
Message-ID: <4B521420.8030306@oracle.com>
References: <20100116164120.47eceecd@simplux> <201001162010.37752.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001162010.37752.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli wrote:
> Try btrfs-show
>   
Ok:

$ mount
/dev/sdc on /media/452f782b-738a-4699-abfa-588eecab07ea type btrfs 
(rw,nosuid,nodev,uhelper=devkit)

$ df
/dev/sdc              932G  6.7G  925G   1% 
/media/452f782b-738a-4699-abfa-588eecab07ea

$ btrfs-show
failed to read /dev/sdb1
failed to read /dev/sdc
failed to read /dev/sdb
failed to read /dev/sda5
failed to read /dev/sda1
failed to read /dev/sda6
failed to read /dev/sda2
failed to read /dev/sda
failed to read /dev/sr0
failed to read /dev/loop1
failed to read /dev/ram2
failed to read /dev/ram10
failed to read /dev/ram11
failed to read /dev/loop7
failed to read /dev/ram1
failed to read /dev/loop0
failed to read /dev/loop5
failed to read /dev/loop2
failed to read /dev/loop3
failed to read /dev/loop4
failed to read /dev/loop6
failed to read /dev/ram12
failed to read /dev/ram4
failed to read /dev/ram13
failed to read /dev/ram5
failed to read /dev/ram8
failed to read /dev/ram14
failed to read /dev/ram15
failed to read /dev/ram0
failed to read /dev/ram3
failed to read /dev/ram6
failed to read /dev/ram9
failed to read /dev/ram7
Btrfs Btrfs v0.19

The drive used is a Seagate FreeAgent 1Tb USB drive under Ubuntu 9.10

$ uname -a
Linux ebrostig-laptop 2.6.31-18-generic-pae #55-Ubuntu SMP Fri Jan 8 
16:13:23 UTC 2010 i686 GNU/Linux

Erik

