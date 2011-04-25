From: Peter Stuge <peter@stuge.se>
Subject: Re: Bug#624131: linux-image-2.6.39-rc4-686-pae: Can somewhat
	reliably produce kernel panic in btrfs code
Date: Mon, 25 Apr 2011 22:50:08 +0200
Message-ID: <20110425205008.11135.qmail@stuge.se>
References: <BANLkTikiVMbH0BU4xTZirNDUu=GhG0ooyg@mail.gmail.com> <1303762526.3032.296.camel@localhost> <BANLkTikyqs0Zx-V+0+431fEAA-XWsGo73g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ben Hutchings <ben@decadent.org.uk>, 624131@bugs.debian.org,
	linux-btrfs@vger.kernel.org
To: Maik Zumstrull <maik@zumstrull.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTikyqs0Zx-V+0+431fEAA-XWsGo73g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Maik Zumstrull wrote:
> >> Bug at fs/btrfs/free-space-cache.c:1246
> >> Bug type: invalid opcode: 0000
> >> Kernel not tainted, running on an ASUSTek 1005HAG
> >> EIP is at btrfs_add_free_space+0x285/0x39a [btrfs]
> >
> > You will probably need to provide a more complete copy of the panic
> > message.
> 
> I thought as much, but other than taking a picture of the screen, I
> don't know how.

Take a picture and ideally transcribe it after reboot.


//Peter
