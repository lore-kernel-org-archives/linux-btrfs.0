From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: Memory leak?
Date: Tue, 12 Jul 2011 12:40:43 +0100
Message-ID: <chaz20110712114043.GA4992@seebyte.com>
References: <CAE5mzvhZc4afuBTT0GrDvPXKaSwYeyPdyiQaYPjCTmvzBahr7g@mail.gmail.com> <20110706081111.GA6931@yahoo.fr> <20110708124429.GB4284@yahoo.fr> <1310137241-sup-8158@shiny> <20110709170959.GC4294@yahoo.fr> <CAE5mzvhZwrtEZ8FUfcYzoMsRwuPjNDn=iCZ6_-CKaifEPZWAKA@mail.gmail.com> <20110709203649.GE4294@yahoo.fr> <1310301809-sup-9903@shiny> <20110710183728.GB4277@yahoo.fr> <20110711090121.GA2537@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cwillu <cwillu@cwillu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110711090121.GA2537@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-11 10:01:21 +0100, Stephane Chazelas:
[...]
> Same without dmcrypt. So to sum up, BUG() reached in btrfs-fixup
> thread when doing an 
> 
> - rsync (though I also got (back when on ubuntu and 2.6.38) at
>   least one occurrence using bsdtar | bsdtar)
> - of a large amount of data (with a large number of files),
>   though the bug occurs quite early probably after having
>   transfered about 50-100GB
> - the source FS being btrfs with compress-force on 3 devices
>   (one of which slightly shorter than the others) and a lot of
>   subvolumes and snapshots (I'm now copying from read-only
>   snapshots but that happened with RW ones as well).
> - to a newly created btrfs fs
> - on one device (/dev/sdd or dmcrypt)
> - mounted with compress or compress-force.
> 
> - noatime on either source or dest doesn't make a difference
>   (wrt the occurrence of fixup BUG())
> - can't reproduce it when dest is not mounted with compress
> - beside that BUG(),
> - kernel memory is being used up (mostly in
>   btrfs_inode_cache) and can't be reclaimed (leading to crash
>   with oom killing everybody)
> - the target FS can be unmounted but that does not reclaim
>   memory. However the *source* FS (that is not the one we tried
>   with and without compress) cannot be unmounted (umount hangs,
>   see another email for its stack trace).
> - Only way to get out of there is reboot with sysrq-b
> - happens with 2.6.38, 2.6.39, 3.0.0rc6
> - CONFIG_SLAB_DEBUG, CONFIG_DEBUG_PAGEALLOC,
>   CONFIG_DEBUG_SLAB_LEAK, slub_debug don't tell us anything
>   useful (there's more info in /proc/slabinfo when
>   CONFIG_SLAB_DEBUG is on, see below)
> - happens with CONFIG_SLUB as well.
[...]

I don't know which of CONFIG_SLUB or noatime made it, but in
that setup with both enabled, I do get the BUG(), but the system
memory is not exhausted even after rsync goes over the section
with millions of files where it used to cause the oom crash.

The only issue remaining then is that I can't umount the source
FS (and thus causing reboot issues). We could still have 2 or 3
different issues here for all we know.

The situation is a lot more comfortable for me now though.

-- 
Stephane
