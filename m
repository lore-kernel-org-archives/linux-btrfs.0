From: David Nicol <davidnicol@gmail.com>
Subject: Re: how to know when all space from a snapshot delete is freed?
Date: Wed, 2 Mar 2011 15:42:11 -0600
Message-ID: <AANLkTikSmHsBRJ919CAbKv3aN0N0jc2cFyRiM_oL4gkz@mail.gmail.com>
References: <iklfnu$efc$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <iklfnu$efc$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 2, 2011 at 7:12 AM, Brian J. Murrell <brian@interlinx.bc.ca> wrote:

> Given that the return from the snapshot delete command is immediate and
> the space is freed asynchronously, how can I determine absolutely that
> the snapshot has been entirely removed and the space freeing operation
> is complete?
>
> Cheers,
> b.

since you just want to determine, and not wait, patch your kernel,
then invoke ioctl#21 with flags of 0x0000 and timeout of 0x0001. you
will have an answer in approximately one millisecond.


-- 
"Reasonable, civil, and intelligent people have not left much of a
mark on history." -- T. Herman Zweibel
