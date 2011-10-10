From: Jeff Mahoney <jeffm@suse.de>
Subject: Re: read error: how to fix?
Date: Mon, 10 Oct 2011 10:07:49 -0400
Message-ID: <4E92FC35.1040608@suse.de>
References: <Bv$Fe34y1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Helmut Hullen <Hullen@t-online.de>, linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Bv$Fe34y1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/10/2011 09:28 AM, Helmut Hullen wrote:
> Hallo, David,
> 
> Du meintest am 10.10.11:
> 
>>> Oct  7 18:16:55 Arktur kernel: ata5.00: exception Emask 0x0
>>> SAct 0x0 SErr 0x0 action 0x0 Oct  7 18:16:55 Arktur kernel:
>>> ata5.00: BMDMA2 stat 0x80d2009 Oct  7 18:16:55 Arktur kernel:
>>> ata5.00: failed command: READ DMA Oct  7 18:16:55 Arktur
>>> kernel: ata5.00: cmd c8/00:40:57:d0:34/00:00:00:00:00/ee tag 0
>>> dma 32768 in Oct  7 18:16:55 Arktur kernel:          res 
>>> 51/40:40:57:d0:34/00:03:0e:00:00/fe Emask 0x9 (media error) Oct
>>> 7 18:16:55 Arktur kernel: ata5.00: status: { DRDY ERR } Oct  7 
>>> 18:16:55 Arktur kernel: ata5.00: error: { UNC } Oct  7
>>> 18:16:55 Arktur kernel: ata5.00: configured for UDMA/100 Oct  7
>>> 18:16:55 Arktur kernel: ata5: EH complete
>>> 
>>> (repeating every 3 seconds)
>>> 
>>> The files contain no valuable data (*.mpeg files,
>>> reproducable). But how can I tell the disk not to use the
>>> damaged sector(s)?
>>> 
>>> On an ext2/3 system I used "badblocks" - is there some
>>> comparable tool for btrfs?
> 
>> No there isn't, but it's a good topic for a btrfs project :)
> 
>> (I see lots of interesting problems like relocating superblocks, 
>> damaged allocator structures, ...)
> 
> I've just worked again with the 2 unreadable files.
> 
> Copying them to another partition stopped somewhere, one time/file
> at about 98%, the other time at about 2%.
> 
> I had to kill the "cp" order with "killall cp".
> 
> The same problem with deleting: I had to use "killall rm". "I'm not
>  amused" ...
> 
> And I'm curious what the system will do with the 2 unreadable
> sectors. In about 1 year I have to add the next 2 TByte disk, with
> "add" and "balance". Maybe I have to copy the 3-disks cluster to a
> 4-disks-cluster ...

I'd try replacing the SATA cable and if that doesn't fix it up, you
may be out of luck. The thing is that marking sectors bad is a (pretty
poor) band-aid for a much bigger problem: If you're hitting persistent
read errors and re-writing the blocks doesn't fix it, your disk is
already close to being completely kaput and no amount of software is
going to help with that.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk6S/DUACgkQLPWxlyuTD7LSXgCfZDTgMjg4mc/cbRBZeYLbmlKS
A08An0DoPONviCz64sYq9H9HL3Xt0ywZ
=p/lR
-----END PGP SIGNATURE-----
