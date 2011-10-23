From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Snapshot rollback
Date: Sun, 23 Oct 2011 22:35:20 +0200
Message-ID: <1420234.7VTvYPTVqo@venice>
References: <4EA46E3A.9090307@cfl.rr.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EA46E3A.9090307@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday, 23 October, 2011 15:42:50 you wrote:
>  there no way to move or hard link subvolumes to somewhere other
> than their original location?

You can use the 'mv' command.

[__active is the subvolume which I use as root]

ghigo@venice:/tmp$ btrfs sub crea a
Create subvolume './a'
ghigo@venice:/tmp$ btrfs sub crea c
Create subvolume './c'
ghigo@venice:/tmp$ btrfs sub crea a/b
Create subvolume 'a/b'
ghigo@venice:/tmp$ sudo btrfs sub list /var/btrfs/
ID 258 top level 5 path __active
ID 259 top level 5 path __active/tmp/a
ID 260 top level 5 path __active/tmp/c
ID 261 top level 5 path __active/tmp/a/b
ghigo@venice:/tmp$ mv a/b c
ghigo@venice:/tmp$ sudo btrfs sub list /var/btrfs/
ID 258 top level 5 path __active
ID 259 top level 5 path __active/tmp/a
ID 260 top level 5 path __active/tmp/c
ID 261 top level 5 path __active/tmp/c/b

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
