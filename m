From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Kernel error during btrfs balance
Date: Tue, 18 Jan 2011 08:54:11 +0800
Message-ID: <AANLkTikhU0N+zTWmZ-og43fDGEsaxsAV7fAeAqutyF_t@mail.gmail.com>
References: <4D344EBB.6030903@logtenberg.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Erik Logtenberg <erik@logtenberg.eu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D344EBB.6030903@logtenberg.eu>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 17, 2011 at 10:14 PM, Erik Logtenberg <erik@logtenberg.eu> wrote:
> Hi,
>
> btrfs balance results in:
>
> http://pastebin.com/v5j0809M
>
> My system: fully up-to-date Fedora 14 with rawhide kernel to make btrfs
> balance do useful stuff to my free space:
>
> kernel-2.6.37-2.fc15.x86_64
> btrfs-progs-0.19-12.fc14.x86_64
>
> Filesystem had 0 bytes free, should be 45G, so on darklings advice I ran
> btrfs balance on the fs, while doing heavy I/O (re-running 5 backup jobs
> that had failed due to ENOSP).
> Up until the crash, btrfs balance did retrieve a couple of Gigs free
> space though, so that part of the plan worked just fine.
>

Please try 2.6.36 kernel.
