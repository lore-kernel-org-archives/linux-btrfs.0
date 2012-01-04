From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: btrfs-tools in Debian squeeze-backports?
Date: Wed, 04 Jan 2012 19:05:04 +0100
Message-ID: <4F0494D0.2060607@jan-o-sch.net>
References: <4F01BF5D.2070801@pocock.com.au> <CAE5mzviX5kJ70nG3bLPwE7E3ZjmdQvsKNUbs6XXqVhs+MEeSXw@mail.gmail.com> <4F01C6DC.3040609@pocock.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F01C6DC.3040609@pocock.com.au>
List-ID: <linux-btrfs.vger.kernel.org>

On 02.01.2012 16:01, Daniel Pocock wrote:
> One thing I've already noticed in 2.6.39 (and both versions of the
> tools) is that df results are misleading.  E.g. if I run regular df (not
> btrfs fi df), I am seeing the same amount of available space for all
> filesystems.  Is there currently a way to see space used by each
> subvolume and snapshot and which kernel and tools versions might be needed?

If you're interested (and brave), you might give the subvolume quota
patches a try. Arne sent them last October, subject

   [PATCH v0 00/18] btfs: Subvolume Quota Groups

Be warned that this is a v0 patch, it's not been tested too much and
will very likely be reworked in the future. But that kind of
functionality will hopefully be added to btrfs, consequently.

-Jan
