From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: Updated btrfs/crypto snappy interface ready for merging
Date: Tue, 17 Jan 2012 16:56:24 +0800
Message-ID: <4F1537B8.1030706@cn.fujitsu.com>
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org> <20120116135442.GA28487@shiny> <4F1534FD.30707@cn.fujitsu.com> <20120117084650.GP11715@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120117084650.GP11715@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

Andi Kleen wrote:
>> It's because decompressing inline extents always fails. I've fixed it
>> and will send the patch out in a new mail thread.
> 
> Thanks for fixing.
> 
>>
>> But seems there's bug in lib snappy code, which makes the decompressed
>> data doesn't quite match the original data.
>>
>> Simply copy a file to a btrfs filesystem with snappy enabled, and clear
>> page cache, and check the file:
> 
> Hmm weird, I have never seen this. Do you have a reproducer?
> 

Just use some randomly chosen text files. For example:

	# mount -t btrfs -o compress=snappy /dev/xxx /mnt
	# cp -r btrfs-progs-unstable/ /mnt
	# sync
	# echo 3 > /proc/sys/vm/drop_caches
	# diff -Nurp btrfs-progs-unstable /mnt/btrfs-progs-unstable

I've tested on both x86_32 and x86_64.

> The basic compression code is quite well tested, I have a reasonable
> unit test.
> 
