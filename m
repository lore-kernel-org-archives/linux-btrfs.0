From: Maik Zumstrull <maik@zumstrull.net>
Subject: Re: Bug#624131: linux-image-2.6.39-rc4-686-pae: Can somewhat reliably
 produce kernel panic in btrfs code
Date: Mon, 25 Apr 2011 22:18:41 +0200
Message-ID: <BANLkTikyqs0Zx-V+0+431fEAA-XWsGo73g@mail.gmail.com>
References: <BANLkTikiVMbH0BU4xTZirNDUu=GhG0ooyg@mail.gmail.com>
	<1303762526.3032.296.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: 624131@bugs.debian.org, linux-btrfs@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1303762526.3032.296.camel@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 25, 2011 at 22:15, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Mon, 2011-04-25 at 22:05 +0200, Maik Zumstrull wrote:

>> By simply stressing the system with some I/O, I can make it crash within
>> seconds. I'm not setting a higher severity because the bug is in an
>> experimental file system in an experimental kernel.
>
> I assume this doesn't happen in 2.6.38?

Not that I've noticed. I don't use that netbook much, but given how
quickly it happens with .39, I say I would have noticed.

>> Here's the important bits (by my guess) I have on screen from the kernel panic:
>>
>> Bug at fs/btrfs/free-space-cache.c:1246
>> Bug type: invalid opcode: 0000
>> Kernel not tainted, running on an ASUSTek 1005HAG
>> EIP is at btrfs_add_free_space+0x285/0x39a [btrfs]
>
> You will probably need to provide a more complete copy of the panic
> message.

I thought as much, but other than taking a picture of the screen, I
don't know how. I am prepared to cooperate fully in the debugging
effort, though. :-) You or they can tell me what is required.
