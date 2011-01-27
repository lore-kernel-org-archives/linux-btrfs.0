From: "Helmut Hullen" <Hullen@t-online.de>
Subject: no space left (was: version)
Date: 27 Jan 2011 14:49:00 +0100
Message-ID: <BeeuNkKD1uB@helmut.hullen.de>
References: <1296114256-sup-4788@think>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1296114256-sup-4788@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Chris,

Du meintest am 27.01.11:

>> crashes with the "dmesg" lines
>>
>> --------------------- dmesg -------------------
>>
>> bio too big device sdc (256 > 240)
>> bio too big device sdc (256 > 240)
>> bio too big device sdc (256 > 240)
>> bio too big device sdc (256 > 240)
>> ------------[ cut here ]------------
>> kernel BUG at fs/btrfs/volumes.c:2097!

> Ugh, this one is an old friend I thought I had fixed up.  The two
> devices have different limits on the max size of the bio, and we're
> using one that is too large.

> I'll get it fixed for the next rc.

Sorry - the problem seems to exist in kernel 2.6.37 too.

/dev/sdb1 with about 8 GByte
/dev/sdc1 with about 12 GByte

    mkfs.btrfs /dev/sdb1
    mount /dev/sdb1 /mnt/btr
    cp <dir with 6 GByte>
    btrfs device add /dev/sdc1 /mnt/btr

looks good.

    btrfs filesystem balance /mnt/btr

seems to look good.

But then (at about 14:34)

    cp <dir with 2 Gbyte> /mnt/btr

sends the following lines to "/var/log/messages":

-------------- var/log/messages ----------------------

Jan 27 14:08:15 ElNath kernel: device fsid e144bfc5cb117745- 
187a9339eb8c0daa devid 1 transid 7 /dev/sdb1
Jan 27 14:24:04 ElNath kernel: end_request: I/O error, dev fd0, sector 0

Jan 27 14:25:34 ElNath kernel: btrfs: relocating block group 7330660352 flags 1
Jan 27 14:25:35 ElNath last message repeated 2 times
Jan 27 14:25:35 ElNath kernel: btrfs: relocating block group 12582912 flags 1
Jan 27 14:25:36 ElNath kernel: btrfs: found 19 extents
Jan 27 14:25:36 ElNath kernel: btrfs: found 19 extents
Jan 27 14:25:36 ElNath kernel: btrfs: relocating block group 4194304 flags 4
Jan 27 14:26:37 ElNath kernel: end_request: I/O error, dev fd0, sector 0

Jan 27 14:34:28 ElNath kernel: bio too big device sdc1 (256 > 240)
Jan 27 14:34:59 ElNath last message repeated 2474 times
Jan 27 14:35:02 ElNath last message repeated 357 times
Jan 27 14:35:04 ElNath squid[3493]: NETDB state saved; 0 entries, 239 msec

but the system seems to copy all files, without any "no space left".

Does this error depend on the sequence (?) of the commands?

Earlier I always typed

        mkfs.btrfs /dev/sdb1
        mount /dev/sdb1 /mnt/btr
        btrfs device add /mnt/sdc1 /mnt/btr
        cp ...
        btrfs filesystem balance /mnt/btr

and then copying more files led to "no space left".

Viele Gruesse!
Helmut
