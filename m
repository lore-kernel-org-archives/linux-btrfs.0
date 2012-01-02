From: Daniel Pocock <daniel@pocock.com.au>
Subject: Re: btrfs-tools in Debian squeeze-backports?
Date: Mon, 02 Jan 2012 16:01:48 +0100
Message-ID: <4F01C6DC.3040609@pocock.com.au>
References: <4F01BF5D.2070801@pocock.com.au> <CAE5mzviX5kJ70nG3bLPwE7E3ZjmdQvsKNUbs6XXqVhs+MEeSXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAE5mzviX5kJ70nG3bLPwE7E3ZjmdQvsKNUbs6XXqVhs+MEeSXw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


> 
> Note that you really want to be running the latest kernel possible if
> using btrfs;  since 2.6.39 there have been several major performance
> fixes, stability fixes, crash-corruption fixes, which users did hit on
> a somewhat regular basis.  Btrfs is not yet stable for the typical
> user who just wants things to work, even when things don't.  I don't
> know of any major distros that offer support services for btrfs
> filesystems, for instance.


I'm not planning to run my whole system on btrfs just yet - but I was
keen to start running one or two test filesystems on a server that I
currently have running Debian squeeze.  Everything else on the server
has to remain as-is if possible.

Thanks for the feedback - I will start looking into the newer kernels
and see if I can use one of them with squeeze, or maybe I will just set
up a VM for btrfs

One thing I've already noticed in 2.6.39 (and both versions of the
tools) is that df results are misleading.  E.g. if I run regular df (not
btrfs fi df), I am seeing the same amount of available space for all
filesystems.  Is there currently a way to see space used by each
subvolume and snapshot and which kernel and tools versions might be needed?

