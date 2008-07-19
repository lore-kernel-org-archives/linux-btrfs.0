From: "Gerald Nowitzky" <Nowitzky@igne.de>
Subject: Re: single disk reed solomon codes
Date: Sat, 19 Jul 2008 17:18:04 +0200
Message-ID: <0cb201c8e9b2$a4272b20$0a00a8c0@ALDI2>
References: <3da3b5b40807190521x35477489sc06195bb182a4561@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

ECC codes like Reed-Solomon are very useful to recognize and locate random 
bit-errors. On a HDD as a unit, as it is seen from OS level, I don't think 
it will be of any help: When a HDD drive reads a sector from disk, it does a 
whole bunch of error recognition and correction measures. Usually there are, 
at least, two layers of error correction with different bit spreads on it. 
*If* this still isn't enough, it is very likely that the whole sector will 
come back completely spoiled, or, much more likely, won't come back at all 
and the drive will report a read error.

So, the only thing that could be done is to add some redundancy on 
sector-level with something like a "Intra-Disk-RAID5" by adding a number of 
parity sectors. A simple parity will be enough, as error recognition and 
location can be done by sector checksums. However, there will be a *huge* 
performance penalty, as every sector write will cause an additional seek and 
write for the parity sector.

In the end, you would add very little security by the price of -at least- 
cutting half your write performance. Thus, I don't think there is any point 
in adding redundancy to single disk systems.

Just my 2 cents...
(Gerald)

>Hi,
>Since btrfs is someday going to be the default FS for Linux, and will
>be on so many single disk PCs and laptops, I was thinking it should be
>a good idea to insert some redundancy in single disk deployments. Of
>course it can help with disk failures, since it's obviously a "single"
>disk, but it can help with bit-rot, and with hardware sector read
>errors. To get that we'd need to implement some kind of forward error
>correction, possibly reed solomon code. I am not sure why no
>filesystem seems to implement such scheme, although I believe at the
>hardware level, such schemes are being used (so the idea is
>applicable) ?
>Not that I am an expert on such matters, but I thought I'd drop that
>suggestion here, maybe at least I'll know why no one else seems to do
>that

