From: cwillu <cwillu@cwillu.com>
Subject: Re: Bug#624131: linux-image-2.6.39-rc4-686-pae: Can somewhat reliably
 produce kernel panic in btrfs code
Date: Mon, 25 Apr 2011 15:05:02 -0600
Message-ID: <BANLkTi=VMW1bsOduH2Xn27NUQkpHiHngqw@mail.gmail.com>
References: <BANLkTikiVMbH0BU4xTZirNDUu=GhG0ooyg@mail.gmail.com>
	<1303762526.3032.296.camel@localhost>
	<BANLkTikyqs0Zx-V+0+431fEAA-XWsGo73g@mail.gmail.com>
	<20110425205008.11135.qmail@stuge.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Maik Zumstrull <maik@zumstrull.net>,
	Ben Hutchings <ben@decadent.org.uk>, 624131@bugs.debian.org,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110425205008.11135.qmail@stuge.se>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 25, 2011 at 2:50 PM, Peter Stuge <peter@stuge.se> wrote:
> Maik Zumstrull wrote:
>> >> Bug at fs/btrfs/free-space-cache.c:1246
>> >> Bug type: invalid opcode: 0000
>> >> Kernel not tainted, running on an ASUSTek 1005HAG
>> >> EIP is at btrfs_add_free_space+0x285/0x39a [btrfs]
>> >
>> > You will probably need to provide a more complete copy of the panic
>> > message.
>>
>> I thought as much, but other than taking a picture of the screen, I
>> don't know how.
>
> Take a picture and ideally transcribe it after reboot.

Known issue;  josef sent a patch
(http://permalink.gmane.org/gmane.comp.file-systems.btrfs/10261) that
should fix it, or you can mount with clear_cache on each boot as a
workaround.
