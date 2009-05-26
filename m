From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Oops on a converted ext4 system
Date: Tue, 26 May 2009 23:25:18 +0200
Message-ID: <4A1C5E3E.1040607@wpkg.org>
References: <4A1B8BD0.6050203@wpkg.org> <20090526091404.GA25723@think> <4A1BB4BC.3000301@wpkg.org> <4A1BE05E.5040804@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A1BE05E.5040804@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski wrote:
> Tomasz Chmielewski wrote:
> 
>>>> Pid: 11454, comm: lzop Not tainted (2.6.30-0.rc7.1mdv #1) MS-6728
>>>
>>> Does this kernel have any extra patches in it?
>>
>> It's a distribution kernel with this description: "NOTE: This kernel 
>> has no patches and no third-party drivers".
>> So there shouldn't be any extra patches in it.
> 
> BTW, mini-904.img.lzo is ~57 GB big; I wanted to uncompress it on the 
> same btrfs filesystem with 15 GB left; but it failed immediately.

I rebooted the system and tried once again - after uncompressing about 3 
GB, it didn't like the checksums:

# lzop -d mini-904.img.lzo
lzop: mini-904.img.lzo: Checksum error

# dmesg
btrfs no csum found for inode 9874460 start 2604158976
btrfs no csum found for inode 9874460 start 2604163072
btrfs no csum found for inode 9874460 start 2604167168
btrfs no csum found for inode 9874460 start 2604171264
btrfs no csum found for inode 9874460 start 2604175360
btrfs no csum found for inode 9874460 start 2604179456
btrfs no csum found for inode 9874460 start 2604183552
btrfs no csum found for inode 9874460 start 2604187648
btrfs no csum found for inode 9874460 start 2604191744
btrfs no csum found for inode 9874460 start 2604195840
btrfs csum failed ino 9874460 off 2604167168 csum 2329941848 private 0
btrfs csum failed ino 9874460 off 2604163072 csum 318014017 private 0
btrfs csum failed ino 9874460 off 2604158976 csum 414044261 private 0
btrfs csum failed ino 9874460 off 2604195840 csum 3818597601 private 0
btrfs csum failed ino 9874460 off 2604191744 csum 315821168 private 0
btrfs csum failed ino 9874460 off 2604187648 csum 2401592681 private 0
btrfs csum failed ino 9874460 off 2604183552 csum 402930804 private 0
btrfs csum failed ino 9874460 off 2604179456 csum 2710516765 private 0
btrfs csum failed ino 9874460 off 2604175360 csum 3446408033 private 0
btrfs csum failed ino 9874460 off 2604171264 csum 3221630271 private 0


-- 
Tomasz Chmielewski
http://wpkg.org
