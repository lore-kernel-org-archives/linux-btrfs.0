From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: LABEL only 1 device
Date: 27 Feb 2012 13:24:00 +0100
Message-ID: <C3f3Dlli1uB@helmut.hullen.de>
References: <20120227120640.GO1046@twin.jikos.cz>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120227120640.GO1046@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, David,

Du meintest am 27.02.12:

[deleting btrfs partition]

>>    OK, the real problem you're seeing is that when btrfs removes a
>> device from the filesystem, that device is not modified in any way.
>> This means that the old superblock is left behind on it, containing
>> the FS label information. What you need to do is, immediately after
>> removing a device from the FS, zero the first part of the partition
>> with dd and /dev/zero.

> A correction here: if the device being removed is writable, the
> superblock is cleared so it's not recognized as a part of any other
> fs:

[...]

> Doing this manually means zeroing 4k block at all offsets up to
> partition size:

> Superblock 0 offset 65536
> Superblock 1 offset 67108864
> Superblock 2 offset 274877906944
> Superblock 3 offset 1125899906842624
> Superblock 4 offset 4611686018427387904

My actual experiments:

  dd if=/dev/zero of=/dev/sdxn bs=16M count=1

seems to be enough. Perhaps deleting the first 16 MByte is too much.

Viele Gruesse!
Helmut
