Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:34522 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbbHDE6K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Aug 2015 00:58:10 -0400
Received: by qgeu79 with SMTP id u79so104229745qge.1
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Aug 2015 21:58:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55C02AF9.3070600@cn.fujitsu.com>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
	<55BADEC4.3020409@cn.fujitsu.com>
	<CAJ3TwYRN+1tJY+paz=qZT0_XP=r9CcTKbBgX_kZRFOWj8vSK=w@mail.gmail.com>
	<55BAFEF9.1070107@cn.fujitsu.com>
	<CAJ3TwYR5g-JhjmGnZUXqLXc7qV1_=AN5_6sj54JQODbtgG9Aag@mail.gmail.com>
	<55BB0A39.1050208@cn.fujitsu.com>
	<CAJ3TwYS+yL8Tk8d3uigpXrfD+dcn2G4tWwbF7jcB=BCDZqs6+g@mail.gmail.com>
	<CAJ3TwYQc3d5R6r+tjY9mxUzptWA_MktUbZeaQebmNRBuqB7zYA@mail.gmail.com>
	<55C017E7.40704@cn.fujitsu.com>
	<CAJ3TwYTd_8-uwn-osNsf6UAuxGvoJCeWmxWYNHmzXoF_+yrABA@mail.gmail.com>
	<55C02AF9.3070600@cn.fujitsu.com>
Date: Mon, 3 Aug 2015 21:58:09 -0700
Message-ID: <CAJ3TwYQUX-CgqSXMxxU+6tcb0_0tuJbwKqHHPufCnsDBYuXycw@mail.gmail.com>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
From: John Ettedgui <john.ettedgui@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 3, 2015 at 8:01 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Oh, converted...
> That's too bad. :(
>
> [[What's wrong with convert]]
> Although btrfs is flex enough in theory to fit itself into the free space of
> ext* and works fine,
> But in practice, ext* is too fragmental in the standard of btrfs, not to
> mention it also enables mixed-blockgroup.
>
Oh oh :/
>
> [[Recommendations]]
> I'd recommend to delete the ext*_img subvolume and rebalance all chunks in
> the fs if you're stick to the converted filesystem.
>
Already done (well the rebalance crashed towards the end both time
with the read only error, but someone on #btrfs looked at my partition
stats and said it was probably good enough)
> Although the best practice is staying away from such converted fs, either
> using pure, newly created btrfs, or convert back to ext* before any balance.
>
Unfortunately I don't have enough hard drive space to do a clean
btrfs, so my only way to use btrfs for that partition was a
conversion.
> [[But before that, just try something]]
> But you have already provided some interesting facts. As the filesystem is
> high fragmented, I'd like to recommend to do some little test:
> (BTW I assume you don't use some special mount options)
Current mount options in fstab:
btrfs   defaults,noatime,compress=lzo,space_cache,autodefrag    0       0
It's the same as my other btrfs partitions, apart from the fact that
they are on a SSD and way smaller.
> To test if it's the space cache causing the mount speed drop.
>
> 1) clear page cache
>    # echo 3 > /proc/sys/vm/drop_caches
> 2) Do a normal mount
>    Just as what you do as usual, with your normal mount options
>    Record the mount time
0.01s user 0.42s system 0% cpu 1:01.70 total
> 3) umount it.
not asked but might as well:
0.00s user 0.65s system 1% cpu 35.536 total
> 4) clear page cache
>    # echo 3 > /proc/sys/vm/drop_caches
> 5) mount it with "clear_cache" mount option
>    It may takes sometime to clear the existing cache.
>    It's just used to clear space cache.
>    Don't compare mount time!
Yes I know it's supposed to be slower :)
although... it was pretty much the same actually:
0.01s user 0.44s system 0% cpu 1:02.07 total
> 6) umount it

> 7) clear page cache
>    # echo 3 > /proc/sys/vm/drop_caches
Is it ok if that value never changed since 1) ?
> 8) mount with "nospace_cache" mount option
>    To see if there is obvious mount time change.
>
0.00s user 0.44s system 0% cpu 1:01.86 total
> Hopes that's the space cache thing causing the slow mount.
> But don't expect it too much anyway, it's just one personal guess.
>
Unfortunately it is about the same :/
> After the test, I'd recommend to follow the [[Recommendations]] if you just
> want a stable filesystem.
>
I am already within these recommendations I think.

Thanks!
