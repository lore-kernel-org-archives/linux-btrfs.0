From: Andrew Guertin <andrew.guertin@uvm.edu>
Subject: Re: Applications using fsync cause hangs for several seconds every
 few minutes
Date: Thu, 18 Aug 2011 03:41:58 -0400
Message-ID: <4E4CC246.8030209@uvm.edu>
References: <4E41A6A4.9070702@uvm.edu> <4E4BCF0C.7060109@uvm.edu> <4E4BD05B.9070501@cchtml.com> <4E4BD272.8000704@uvm.edu> <20110817145509.GA23804@hendrix.borisch.local> <4E4C7BCD.6090004@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Anand Jain <Anand.Jain@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4C7BCD.6090004@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/17/2011 10:41 PM, Anand Jain wrote:
> Dave,
>
> good to have a test case on the 3.0 kernel. do you have btrfs as
> root fs ? and
> can you show how are you using the btrfs mainly I would need
> 'btrfs fi show' let me try if I can reproduce.
>
> Thanks, Anand

Personally, I find that large compiles are very "useful" in making the issue 
occur sooner. I'm on gentoo, so when I was bisecting, I'd often just emerge 
openoffice and let it run for a while.

For observing, the best way I found was to run JOSM (Java OpenStreetMap editor). 
Browsing around a map is very interactive, so it's immediately noticeable when 
it hangs, and downloading map tiles all the time uses a lot of IO. In-browser 
map applications would probably work too.

My filesystem is partitioned with a small ext2 /boot as sda1, a 2GB swap as 
sda2, and the remaining space as btrfs / on sda3.
btrfs fi show gives:
Label: none  uuid: 28559ad8-7db8-402b-a93d-27ec9c5e943b
	Total devices 1 FS bytes used 102.83GB
	devid    1 size 144.90GB used 144.90GB path /dev/sda3

Btrfs v0.19-35-g1b444cd-dirty

--Andrew
