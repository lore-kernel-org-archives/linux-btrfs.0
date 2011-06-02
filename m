From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: btrfs error after using kernel 3.0-rc1
Date: Thu, 02 Jun 2011 08:35:15 +0800
Message-ID: <4DE6DAC3.4070405@cn.fujitsu.com>
References: <BANLkTimGPgn9CERxCNQPqJLTiRkFUc03OA@mail.gmail.com> <BANLkTinP-Rit3tc2HRDx4d2WArkxqUBuug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTinP-Rit3tc2HRDx4d2WArkxqUBuug@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/01/2011 08:22 PM, Fajar A. Nugraha wrote:
> On Wed, Jun 1, 2011 at 6:06 AM, Fajar A. Nugraha <list@fajar.net> wrote:
>> While using btrfs as root on kernel 3.0-rc1, there was some errors (I
>> wasn't able to capture the error) that forced me to do hard reset.
>>
>> Now during startup system drops to busybox shell because it's unable
>> to mount root partition.
>> Is there a way to recover the data, as at least grub2 was still happy
>> enough to load kernel and initrd (both of which located on the same
>> btrfs partition)?
>>
>> This is what dmesg says
>>
>> [    4.536798] device label SSD-ROOT devid 1 transid 38245 /dev/sda2
>> [    9.552086] device label SSD-ROOT devid 1 transid 38245
>> /dev/disk/by-label/SSD-ROOT
>> [    9.554563] btrfs: disk space caching is enabled
>> [    9.564301] parent transid verify failed on 44040192 wanted 38240 found 32526
>> [    9.564535] parent transid verify failed on 44040192 wanted 38240 found 32526
>> [    9.564778] parent transid verify failed on 44040192 wanted 38240 found 32526
>> [    9.575679] parent transid verify failed on 44052480 wanted 38240 found 31547
>> [    9.575904] parent transid verify failed on 44052480 wanted 38240 found 31547
>> [    9.576176] parent transid verify failed on 44052480 wanted 38240 found 31547
>> [    9.586121] parent transid verify failed on 44064768 wanted 38240 found 34145
>> [    9.586319] parent transid verify failed on 44064768 wanted 38240 found 34145
>> [    9.586515] parent transid verify failed on 44064768 wanted 38240 found 34145
>> [    9.587027] parent transid verify failed on 44068864 wanted 38240 found 34476
>> [    9.589732] Btrfs detected SSD devices, enabling SSD mode
>> [    9.592923] block group 29360128 has an wrong amount of free space
>> [    9.592959] btrfs: failed to load free space cache for block group 29360128
> 
> 
> For anyone who got the same problem,
> 
> I was finally able to mount the fs using Ubuntu Natty's
> 2.6.38-8-generic (the one on live CD).
> Previously I tried using 2.6.38-9-generic and and 3.0-rc1, none works.
> Now I'm copying the files somewhere else before reinstalling this
> system.
> 
> On another note, does anybody know how btrfs allocates ID for subvols?
> It doesn't seem to reuse deleted subvol's ID. What happens when the
> last subvol ID is 999?
> 

Yes, no reuse.

a new subvol will be 1000, one large than 999.

thanks,
liubo
