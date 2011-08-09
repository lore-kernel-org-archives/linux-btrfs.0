From: Andrew Guertin <andrew.guertin@uvm.edu>
Subject: Re: Applications using fsync cause hangs for several seconds every
 few minutes
Date: Tue, 09 Aug 2011 17:29:08 -0400
Message-ID: <4E41A6A4.9070702@uvm.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/21/2011 01:15 PM, Jan Stilow wrote:
> Hello,
> 
> Nirbheek Chauhan <nirbheek <at> gentoo.org> writes:
>> [...]
>>
>> Every few minutes, (I guess) when applications do fsync (firefox,
>> xchat, vim, etc), all applications that use fsync() hang for several
>> seconds, and applications that use general IO suffer extreme
>> slowdowns. iotop shows various combinations of the processes listed
>> below doing writes, and the total write as 2-3MB/s.
>>
>> [btrfs-dealloc-]
>> [btrfs-submit-0]
>> [btrfs-transacti]
>> [btrfs-endio-wri]
>> [flush-btrfs-1]
> 
> I'm using btrfs under a 2.6.39-ARCH kernel and run into the same issue.
> 
> In my case the [btrfs-submit-0] and [btrfs-transacti] shows up in iotop
> and produce 99% of IO at the time a application is frozen. For something
> like 10 to 30 seconds.
> 
> [...]

I see the same issue. I have bisected it to

4e69b598f6cfb0940b75abf7e179d6020e94ad1e is the first bad commit
commit 4e69b598f6cfb0940b75abf7e179d6020e94ad1e
Author: Josef Bacik <josef@redhat.com>
Date:   Mon Mar 21 10:11:24 2011 -0400

Btrfs: cleanup how we setup free space clusters

...which came in between 2.6.38 and 2.6.39.

The newest kernel I have tried was 3.0-rc7, which still had the bug. I
have not tried 3.1-rc1, but plan to soon.

--Andrew
