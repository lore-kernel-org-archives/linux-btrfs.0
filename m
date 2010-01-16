From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: Free space left
Date: Sat, 16 Jan 2010 20:10:37 +0100
Message-ID: <201001162010.37752.kreijack@libero.it>
References: <20100116164120.47eceecd@simplux>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100116164120.47eceecd@simplux>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 16 January 2010, Michael Niederle wrote:
> How can I detect how much free space is left on a btrfs-volume?
> 
> As I read (and learned in practice!) "df" reports cannot be trusted if used 
on
> btrfs-volumes.

Try btrfs-show

$ btrfs-show
Label: bar  uuid: ec2918cd-ad47-4eac-9e85-5604b02fd922
        Total devices 1 FS bytes used 302.25MB
        devid    1 size 964.81MB used 614.50MB path /dev/sdc1

Label: debian-root  uuid: 6e2a647f-5da2-4bd0-a7d7-9b13d13a47cc
        Total devices 1 FS bytes used 23.52GB
        devid    1 size 232.11GB used 118.03GB path /dev/sdc3

Btrfs Btrfs v0.19


BR
G.Baroncelli


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
