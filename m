From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: read error: how to fix?
Date: 21 Oct 2011 11:40:00 +0200
Message-ID: <BwGlMqfy1uB@helmut.hullen.de>
References: <1318793530.2588.28.camel@nayuki.kepstin.ca>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1318793530.2588.28.camel@nayuki.kepstin.ca>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Calvin,

Du meintest am 16.10.11:

[...]

> If you have pending sectors, causing the drive to reallocate them is
> very simple. Write data (any data) over the sector in question - the
> drive will then remap it onto the spare area to do the write. (The
> easiest way is to do something like dd if=/dev/zero of=/dev/sdX; but
> if you know the exact sector number, "hdparm --write-sector" can
> remap it quickly.)

(instead of a blog ... and please excuse my gerlish)

I've buyed another 2-TByte disk (Samsung - seems to be bullet proofed).

   dd if=/dev/baddisk of=/dev/gooddisk bs=8M conv=noerror

worked (about 30 hours for 2 TByte), it produced many error messages.

Unplugged /dev/baddisk, plugged /dev/gooddisk, mounted the 3-disk- 
cluster: worked.
Looking into the directories: showed no problem (with the bad disk even  
that produced error messages).
Trying to play an *.mpg: nothing. Shit.
Some error messages.

Next adventure:
Removed the good disk, plugged the bad disk.

Extracted the bad sectors (for baddisk = sdd) with

  grep 'I/O error' /var/log/warn | grep 'dev sdd' | \
    cut -d' ' -f11- | sort -u > /home/tmp/WDC-20111021.txt

"repaired" them with

#! /bin/bash
# Geruest: Joerg Sommer, de.comp.os.unix.linux.hardware 18.10.2011

Platte=/dev/sdd
# WD 20EARS

# bad sector 778550400

  for blk in $(seq 778550000 778551000)
  do
    hdparm --read-sector $blk $Platte > /dev/null
    test $? -eq 5 || continue
    hdparm --write-sector $blk --yes-i-know-what-i-am-doing $Platte
done
#

Seems to work as desired; it seems to be a good idea to "repair" not  
only the sectors shown in "/var/log/warn" but their probably environment  
too.

Ok - the file that uses this sector may be badly damaged. But people who  
have worked with LPs or MCs know such a behaviour ... no real problem.


Run btrfsck.
Many error messages.
When
        btrfs filesystem show

shows 3 disks in the cluster: have I to run btrfsck for each disk, or  
runs btrfsck over all disks of this cluster?

But now I can not only the the directories but can "open" the contents  
too - much better than nothing!

Possible next adventure:

        for Datei in /Path/to/*.mpg
          do
            cat "$Datei" > /dev/null
          done

produces (if necessary) not only the error messages in "/var/log/warn"  
but the names of the damaged files too.

Viele Gruesse!
Helmut
