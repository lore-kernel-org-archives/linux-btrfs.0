From: btrfs@nentwig.biz
Subject: Re: can't read superblock (but could mount)
Date: Sat, 11 Feb 2012 07:27:25 +0100
Message-ID: <20120211072725.Horde.8iYhMlNNcXdPNgpNS2yG-PA@webmail.df.eu>
References: <20120210203051.Horde.q5KnHsL8999PNXBrH5AlxdA@webmail.df.eu>
 <20120210221842.GU8384@shiny> <20120210233959.GV8384@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; DelSp=Yes
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120210233959.GV8384@shiny>
List-ID: <linux-btrfs.vger.kernel.org>


Quoting Chris Mason <chris.mason@oracle.com>:

> On Fri, Feb 10, 2012 at 05:18:42PM -0500, Chris Mason wrote:
>> Ok, step one:
>>
>> Pull down the dangerdonteveruse branch of btrfs-progs:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git  
>> dangerdonteveruse
>>
>> Run btrfs-debug-tree -r /dev/sda1 and send the output here please.
>
> Sorry, that's btrfs-debug-tree -R /dev/sda1

# ./btrfs-debug-tree -R /dev/sda1
root tree: 10229936128 level 1
chunk tree: 10364125184 level 1
extent tree key (EXTENT_TREE ROOT_ITEM 0) 10229944320 level 3
device tree key (DEV_TREE ROOT_ITEM 0) 10192654336 level 0
fs tree key (FS_TREE ROOT_ITEM 0) 10103791616 level 3
checksum tree key (CSUM_TREE ROOT_ITEM 0) 10103156736 level 2
data reloc tree key (DATA_RELOC_TREE ROOT_ITEM 0) 10027970560 level 0
btrfs root backup slot 0
         tree root gen 157090 block 10229907456
                 extent root gen 157090 block 10229911552
                 chunk root gen 124887 block 10364125184
                 device root gen 124887 block 10192654336
                 csum root gen 157032 block 10103156736
                 fs root gen 157032 block 10103791616
                 15491051520 used 40020631552 total 1 devices
btrfs root backup slot 1
         tree root gen 157091 block 10229948416
                 extent root gen 157091 block 10229952512
                 chunk root gen 124887 block 10364125184
                 device root gen 124887 block 10192654336
                 csum root gen 157032 block 10103156736
                 fs root gen 157032 block 10103791616
                 15491051520 used 40020631552 total 1 devices
btrfs root backup slot 2
         tree root gen 157092 block 10229907456
                 extent root gen 157092 block 10229911552
                 chunk root gen 124887 block 10364125184
                 device root gen 124887 block 10192654336
                 csum root gen 157032 block 10103156736
                 fs root gen 157032 block 10103791616
                 15491051520 used 40020631552 total 1 devices
btrfs root backup slot 3
         tree root gen 157093 block 10229936128
                 extent root gen 157093 block 10229944320
                 chunk root gen 124887 block 10364125184
                 device root gen 124887 block 10192654336
                 csum root gen 157032 block 10103156736
                 fs root gen 157032 block 10103791616
                 15491051520 used 40020631552 total 1 devices
total bytes 40020631552
bytes used 15491051520
uuid 9e9886fc-3e60-4c59-a246-727662769ee2
Btrfs Btrfs v0.19


But we it is that the bootloader apparently is able to load (at least)  
the kernel (and initrd) from the partition?



