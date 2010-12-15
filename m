From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: What do the arguments of btrfs filesystem defragment do?
Date: Wed, 15 Dec 2010 20:18:51 +0100
Message-ID: <201012152018.51388.kreijack@libero.it>
References: <4D08E76B.40400@logtenberg.eu>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D08E76B.40400@logtenberg.eu>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, 15 December, 2010, Erik Logtenberg wrote:
> Hi,
> 
> I would like to know that the arguments of "btrfs filesystem defragment"
> do. According to the built-in help page, the invocation is as follows:
> 
> >         btrfs filesystem defragment [-vcf] [-s start] [-l len] [-t
> >                 size] <file>|<dir> [<file>|<dir>...]
> >                 Defragment a file or a directory.
> 
> Unfortunately I can't find any documentation on the meaning of these
> arguments. The man page doesn't list these arguments:

I loked at the code and I try to explain. But what I write below may be 
affected by error.

If the parameter is a directory, the subvolume where the dir is placed is 
defragged.

Instead if the parameter is a file, the switches have the following meaning:

-f -> flush after defrag
-s -> start point of defrag
-l -> length of defrag range (if len is <= 0, the rest of file is considered)
-c -> force compress
-t -> threshold for compression (if the size of file is bigger, compress the 
file ?)


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
