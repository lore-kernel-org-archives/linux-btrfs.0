From: Timo Nentwig <btrfs@nentwig.biz>
Subject: Re: can't read superblock (but could mount)
Date: Thu, 16 Feb 2012 18:04:47 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1202161856220.1579@localhost>
References: <20120210203051.Horde.q5KnHsL8999PNXBrH5AlxdA@webmail.df.eu> <20120210221842.GU8384@shiny> <20120210233959.GV8384@shiny> <20120211072725.Horde.8iYhMlNNcXdPNgpNS2yG-PA@webmail.df.eu> <20120213130943.GA1573@shiny> <alpine.LNX.2.00.1202141832420.11051@localhost>
 <20120214184131.GZ1573@shiny> <alpine.LNX.2.00.1202141950420.18337@localhost> <20120214211422.GE1573@shiny> <alpine.LNX.2.00.1202150701150.24133@localhost> <20120215132322.GR1573@shiny>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120215132322.GR1573@shiny>
List-ID: <linux-btrfs.vger.kernel.org>



On Wed, 15 Feb 2012, Chris Mason wrote:

> Date: Wed, 15 Feb 2012 08:23:22 -0500
> From: Chris Mason <chris.mason@oracle.com>
> To: Timo Nentwig <btrfs@nentwig.biz>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: can't read superblock (but could mount)
> 
> On Wed, Feb 15, 2012 at 07:03:49AM +0100, Timo Nentwig wrote:
>> On Tue, 14 Feb 2012, Chris Mason wrote:
>>
>>> Ok, 3.2 shouldn't have done this.  Was this an external drive?  What
>>> else do you have on the system?
>>
>> Nothing special actually. Standard arch linux with virtualbox kernel modules.
>> It's a SSD if this should matter. Mounted with ssd,compress=lzo,noatime.
>
> Ok, it sounds like we've got some memory corruption problems in here.
> Hopefully not from virtualbox, but I'd start with an memtest.

Wow, now I'm really impressed! :) You are probably right. I overclocked memory
and ran memtest for like 1-2h without errors and had a rock solid system for 
quite a while when I recently started to witness all kinds of random and 
reoccuring crashes. Actually blamed the broken FS rather than to run memtest 
again. Mea culpa.

So, I hit 1 error after a while, somewhat lowered clock freq and no error in 
17h straight. I'll recreate the FS on that box.

Thanks a lot for your support!

>>> Is this the same FS that was corrupted or a different one?
>>
>> Different one. Created from an old 3.2.1 gentoo install (btrfs 0.19-dirty).
>
> Different FS, same machine?  Please include all the kernel messages.

Yes, same machine, same SSD drive, new mkfs.btrfs.
