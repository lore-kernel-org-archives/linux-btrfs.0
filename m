From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: labelling
Date: 11 Nov 2010 08:48:00 +0100
Message-ID: <B$fJyztT1uB@helmut.hullen.de>
References: <20101110111811.GA15973@vlad.carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101110111811.GA15973@vlad.carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 10.11.10:

>>         findfs LABEL=MM2
>>
>> shows "/dev/sdd2" (the first partition)
>>
>>         file -s /dev/sdd2
>>         file -s /dev/sdc3
>>
>> shows "LABEL=MM2" for both partitions

>>         mount LABEL=MM2 /srv/MM
>>
>> doesn't work now, it tries to mount /dev/sdd2 and mourns.
>>
>>         mount /dev/sdd2 /srv/MM
>>
>> shows the same error message,

# mount LABEL=MM2
mount: wrong fs type, bad option, bad superblock on /dev/sdd2,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

# mount /dev/sdd2
mount: wrong fs type, bad option, bad superblock on /dev/sdd2,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

>    What's the error message? What do you get in your kernel logs when
> you do this? This should work, so there's something wrong, but it's
> (probably) not to do with disk labels.

>>         mount /dev/sdc3 /srv/MM
>>
>> (mounting the added partition) works fine, the whole space is
>> available.

That's the behaviour after a cold boot.

        umount /srv/MM
        mount LABEL=MM2 /srv/MM

then works.
Only the first try with LABEL or with "the other" device seems to fail.

I don't like testing via reboot ...

Viele Gruesse!
Helmut
