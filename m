Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:48458 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbaEMULf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 May 2014 16:11:35 -0400
Received: by mail-lb0-f177.google.com with SMTP id s7so679481lbd.22
        for <linux-btrfs@vger.kernel.org>; Tue, 13 May 2014 13:11:34 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140512232609.GI14174@merlins.org>
References: <E1WiphR-0003MN-50@legolas.merlins.org>
	<20140510224249.GA15909@merlins.org>
	<20140512232609.GI14174@merlins.org>
Date: Tue, 13 May 2014 21:11:34 +0100
Message-ID: <CAL3q7H6K6b_oZKYZDtHCBCieL_Ya9DHSkN3Rug5azqR6gzDVAQ@mail.gmail.com>
Subject: Re: 3.15-rc5 btrfs send/receive corruption errors? Does scrub warn of
 silent corruption?
From: Filipe David Manana <fdmanana@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 13, 2014 at 12:26 AM, Marc MERLIN <marc@merlins.org> wrote:
> On Sat, May 10, 2014 at 04:57:18PM -0700, Marc MERLIN wrote:
>> On Sat, May 10, 2014 at 03:42:49PM -0700, Marc MERLIN wrote:
>> > I tried with 3.14.3 and it went further, however it died with
>> > legolas:/mnt/btrfs_pool2# btrfs send  home_ro.20140507_10:00:01 | btrfs receive /mnt/btrfs_pool1/
>> > At subvol home_ro.20140507_10:00:01
>> > At subvol home_ro.20140507_10:00:01
>> > ERROR: send ioctl failed with -5: Input/output error
>> > ERROR: unexpected EOF in stream.
>> >
>> > I'll look up -5 later when I have time, but I guess there is a problem
>> > on the source that is causing copies to fail with both kernels?
>>
>> This brings me back to the earlier question:
>>
>> When my other FS died, scrub ran ok just earlier.
>>
>> Now, having 2 btrfs sends (not incremental, full) fail with 2 kernels
>> would indicate that something might be wrong on the source filesystem.
>
> So I copied the entire FS back to the SSD using rsync instead of btrfs
> send/receive and as far as I can tell all the data got over fine.
>
> Is there anything you'd like from the subvolumes on the source that
> btrfs cannot process and that I'm going to delete so that I can start
> syncing back from the SSD to the HDD?

For the issue you had with send sending weird path names, I just found
a case that leads to it (or a crash or some other weird stuff):

https://patchwork.kernel.org/patch/4170401/

But you really need to be using a lot of hard links and deleting them,
so maybe it's caused by something else.

thanks

>
> Thanks,
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
