Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout06.t-online.de ([194.25.134.19]:54654 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab2FEQ6n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 12:58:43 -0400
Date: 05 Jun 2012 18:19:00 +0200
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CAIin7n9CXB@helmut.hullen.de>
In-Reply-To: <4FCE19D3.4090908@webstarts.com>
Subject: Re: delete disk proceedure
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Jim,

Du meintest am 05.06.12:

> /dev/sda               11T  4.9T  6.0T  46% /btrfs
> [root@advanced ~]# btrfs fi show
> failed to read /dev/sr0
> Label: none  uuid: c21f1221-a224-4ba4-92e5-cdea0fa6d0f9
>          Total devices 12 FS bytes used 4.76TB
>          devid    6 size 930.99GB used 429.32GB path /dev/sdf
>          devid    5 size 930.99GB used 429.32GB path /dev/sde
>          devid    8 size 930.99GB used 429.32GB path /dev/sdh
>          devid    9 size 930.99GB used 429.32GB path /dev/sdi
>          devid    4 size 930.99GB used 429.32GB path /dev/sdd
>          devid    3 size 930.99GB used 429.32GB path /dev/sdc
>          devid   11 size 930.99GB used 429.08GB path /dev/sdk
>          devid    2 size 930.99GB used 429.32GB path /dev/sdb
>          devid   10 size 930.99GB used 429.32GB path /dev/sdj
>          devid   12 size 930.99GB used 429.33GB path /dev/sdl
>          devid    7 size 930.99GB used 429.32GB path /dev/sdg
>          devid    1 size 930.99GB used 429.09GB path /dev/sda

> Btrfs v0.19-35-g1b444cd

> df -h and btrfs fi show seem to be in good size agreement.  Btrfs was
> created as raid1 metadata and raid0 data.  I would like to delete the
> last 4 drives leaving 7T of space to hold 4.9T of data.  My plan
> would be to remove /dev/sdi, j, k, l one at a time.  After all are
> deleted run "btrfs fi balance /btrfs".

I'd prefer

        btrfs device delete /dev/sdi
        btrfs filesystem balance /btrfs
        btrfs device delete /dev/sdj
        btrfs filesystem balance /btrfs

etc. - after every "delete" its "balance" run.

That may take a lot of hours - I use the last lines of "dmesg" to  
extrapolate the needed time (btrfs produces a message about every  
minute).

And you can't use the console from where you have started the "balance"  
command. Therefore I wrap this command:

      echo 'btrfs filesystem balance /btrfs' | at now


Viele Gruesse!
Helmut
