From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: strange filefrag output on btrfs
Date: Tue, 14 Jun 2011 10:54:25 +0800
Message-ID: <4DF6CD61.6050102@cn.fujitsu.com>
References: <4DF38C23.7010603@gmail.com> <20110613115018.GT12709@twin.jikos.cz> <4DF629DA.4050300@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DF629DA.4050300@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Andreas Philipp wrote:
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>  
> On 13.06.2011 13:50, David Sterba wrote:
>> On Sat, Jun 11, 2011 at 05:39:15PM +0200, Andreas Philipp wrote:
>>> On one of my btrfs volumes I see a strange output from filefrag when
>>> run against a particular large (~8GB) file. filefrag and filefrag -v
>>> give me a different number of extents, see below.
>>>
>>> aph@thor /mnt/nutshell $ sudo filefrag -v funtoo.img | grep extents
>>> funtoo.img: 2624 extents found
>>> aph@thor /mnt/nutshell $ sudo filefrag funtoo.img | grep extents
>>> funtoo.img: 2653 extents found
>>
>> is the file open and being written to? did you run sync before the first
>> command?
> The file is not open. Yes, I have run sync before the first command.
> Now, I tested again with a copy of file but the results is more or
> less the same.
> 
> aph@thor /mnt/nutshell $ cp funtoo.img funtoo.1.img
> aph@thor /mnt/nutshell $ sync
> aph@thor /mnt/nutshell $ sudo filefrag -v funtoo.img funtoo.1.img |
> grep extents
> funtoo.img: 2624 extents found
> funtoo.1.img: 57 extents found
> aph@thor /mnt/nutshell $ sudo filefrag funtoo.img funtoo.1.img | grep
> extents
> funtoo.img: 2653 extents found
> funtoo.1.img: 311 extents found
> 

If you look into the source code of filefrag, you'll know why.

There are two ways to calc the extent number, depending on whether verbose
option is turned on or not.

In the verbose mode, it will check if the next extent is adjacent to the
prev extent in the physical position, and in this case they are considered
to be one extent.

That's why the number returned in verbose mode is smaller.
