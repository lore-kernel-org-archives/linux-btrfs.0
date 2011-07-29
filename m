From: cwillu <cwillu@cwillu.com>
Subject: Re: kernel BUG at /home/kernel-ppa/COD/linux/fs/btrfs/extent-tree.c:5502!
Date: Fri, 29 Jul 2011 11:40:27 -0600
Message-ID: <CAE5mzvjmwJXm+1XwmAJz_84G2HP7P3Gwuxsm_3DGAq0m3y68AQ@mail.gmail.com>
References: <CAE5mzvivm=0-=_r5ZbZ71T=_bZ=vfB-EbqbT-WwK8mSg7M-=_A@mail.gmail.com>
	<CAE5mzvjESOwkH+njtQ5YTq+504AOqmgT90J2QU5NAke-O-zWOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAE5mzvjESOwkH+njtQ5YTq+504AOqmgT90J2QU5NAke-O-zWOA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 29, 2011 at 10:57 AM, cwillu <cwillu@cwillu.com> wrote:
> On Fri, Jul 29, 2011 at 10:50 AM, cwillu <cwillu@cwillu.com> wrote:
>> Vanilla 3.0, mounted with compress=lzo, on a 40gb intel ssd.
>> Triggered while poking around with getting chromium windows to appear
>> where I wanted them (i.e., no heavy load).
>
> On reboot, I get a similar trace, posted at
> http://cwillu.com/files/timber.dmesg in order to get around gmail's
> breaking the lines.
>

Possibly a useful btrfs-image at http://cwillu.com/files/timber.btrfs
(13mb);  I patched around a transid error when making that, so it may
not actually mean anything, but on the off chance it does...
