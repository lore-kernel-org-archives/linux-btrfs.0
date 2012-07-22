Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57300 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2GVTn0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jul 2012 15:43:26 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: brtfs on top of dmcrypt with SSD -> ssd or nossd + crypt performance?
Date: Sun, 22 Jul 2012 21:43:24 +0200
Cc: Marc MERLIN <marc@merlins.org>, Chris Mason <chris.mason@fusionio.com>,
        mbroz@redhat.com, Calvin Walton <calvin.walton@kepstin.ca>,
        jeff@deserettechnology.com
References: <20120202124241.GW16796@shiny> <20120722185848.GA10089@merlins.org> <201207222135.11159.Martin@lichtvoll.de> (sfid-20120722_213808_282941_5CBF6112)
In-Reply-To: <201207222135.11159.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201207222143.25126.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 22. Juli 2012 schrieb Martin Steigerwald:
> Hi Marc,
> 
> Am Sonntag, 22. Juli 2012 schrieb Marc MERLIN:
> > I'm still getting a bit more data before updating the btrfs wiki with
> > my best recommendations for today.
> > 
> > First, everything I've read so far says that the ssd btrfs mount
> > option makes btrfs slower in benchmarks.
> > What gives?
> > Anyone using it or know of a reason not to mount my ssd with nossd?
> > 
> > 
> > Next, I got a new Samsumg 830 512GB SSD which is supposed to be very
> > high performance.
> > The raw device seems fast enough on a quick hdparm test:
> > 
> > 
> > But once I encrypt it, it drops to 5 times slower than my 1TB
> > spinning disk in the same laptop:
> > gandalfthegreat:~# hdparm -tT /dev/mapper/ssdcrypt
> > 
> > /dev/mapper/ssdcrypt:
> >  Timing cached reads:   15412 MB in  2.00 seconds = 7715.37 MB/sec
> >  Timing buffered disk reads:  70 MB in  3.06 seconds =  22.91 MB/sec
> > 
> > <<<<
> > 
> > gandalfthegreat:~# hdparm -tT /dev/mapper/cryptroot (spinning disk)
> > 
> > /dev/mapper/cryptroot:
> >  Timing cached reads:   16222 MB in  2.00 seconds = 8121.03 MB/sec
> >  Timing buffered disk reads: 308 MB in  3.01 seconds = 102.24 MB/sec
> > 
> > <<<<
> 
> Have you looked whether certain kernel threads are eating CPU?
> 
> I would have a look at this.
> 
> Or use atop to have a complete system overview during the hdparm run.
> You may want to use its default 10 seconds delay.
> 
> Anyway, hdparm is only a very rough measurement. (Test time 2 / 3
> seconds is really short.)
> 
> Did you repeat tests three or five times and looked at the deviation?
> 
> For what it is worth I can beat that with ecryptfs on top of Ext4 ontop
> of an Intel SSD 320 (SATA 300 based):
> 
> martin@merkaba:~> su - ms
> Passwort:
> ms@merkaba:~> df -hT .
> Dateisystem    Typ      Größe Benutzt Verf. Verw% Eingehängt auf
> /home/.ms      ecryptfs  224G    211G   11G   96% /home/ms
> ms@merkaba:~> dd if=/dev/zero of=testfile bs=1M count=1000 conv=fsync
> 1000+0 Datensätze ein
> 1000+0 Datensätze aus
> 1048576000 Bytes (1,0 GB) kopiert, 20,1466 s, 52,0 MB/s
> ms@merkaba:~> rm testfile
> ms@merkaba:~> sudo fstrim /home
> [sudo] password for ms:
> ms@merkaba:~>
> 
> Thats way slower than a dd without encryption, but its way faster than
> your hdparm figures. The SSD was underutilized according to the
> harddisk LED of this ThinkPad T520 with Intel i5 Sandybridge 2.5 GHz
> dualcore. Did start atop to late to see whats going on.
> 
> (I did not yet test ecryptfs on top of BTRFS, but you didn´t test a
> filesystem with hdparm anyway.)


You measured read speed. So here read speed as well:

martin@merkaba:~#1> su - ms
Passwort: 
ms@merkaba:~> LANG=C df -hT .
Filesystem     Type      Size  Used Avail Use% Mounted on
/home/.ms      ecryptfs  224G  211G   11G  96% /home/ms
ms@merkaba:~> LANG=C df -hT /home
Filesystem               Type  Size  Used Avail Use% Mounted on
/dev/mapper/merkaba-home ext4  224G  211G   11G  96% /home


ms@merkaba:~> dd if=/dev/zero of=testfile bs=1M count=1000 conv=fsync
1000+0 Datensätze ein
1000+0 Datensätze aus
1048576000 Bytes (1,0 GB) kopiert, 19,4592 s, 53,9 MB/s


ms@merkaba:~> sync ; su -c "echo 3 > /proc/sys/vm/drop_caches" ; dd 
if=testfile of=/dev/null bs=1M count=1000
Passwort: 
1000+0 Datensätze ein
1000+0 Datensätze aus
1048576000 Bytes (1,0 GB) kopiert, 12,4633 s, 84,1 MB/s
ms@merkaba:~>

ms@merkaba:~> sync ; su -c "echo 3 > /proc/sys/vm/drop_caches" ; dd 
if=testfile of=/dev/null bs=1M count=1000
Passwort: 
1000+0 Datensätze ein
1000+0 Datensätze aus
1048576000 Bytes (1,0 GB) kopiert, 12,0747 s, 86,8 MB/s


ms@merkaba:~> sync ; su -c "echo 3 > /proc/sys/vm/drop_caches" ; dd 
if=testfile of=/dev/null bs=1M count=1000
Passwort: 
1000+0 Datensätze ein
1000+0 Datensätze aus
1048576000 Bytes (1,0 GB) kopiert, 11,7131 s, 89,5 MB/s
ms@merkaba:~>


Figures got faster with each measurement. Maybe SSD internal caching?

At leasts that way faster than 22.91 MB/sec ;)

On reads dd used up one core. On writes dd and flush-ecryptfs used up a 
little more than one core, about 110-150%, but not all two cores 
completely.

Kernel is 3.5.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
