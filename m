Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:51269 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbaDDO2r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Apr 2014 10:28:47 -0400
Received: by mail-lb0-f173.google.com with SMTP id p9so2557423lbv.32
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Apr 2014 07:28:45 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140331163531.GH2972@merlins.org>
References: <CAL3q7H5mxvN+TxtK3_Oeef=S3rVGu2QywD6d8Zd6ABUj1B44Nw@mail.gmail.com>
	<20140330002123.GP22552@merlins.org>
	<20140331163531.GH2972@merlins.org>
Date: Fri, 4 Apr 2014 15:28:44 +0100
Message-ID: <CAL3q7H5BJmKNDxXyFoMfKYkAg1F+Wt3B5tR1UHzfZgi5oz7C5g@mail.gmail.com>
Subject: Re: determining snapshot size -> adding "work to do" info to btrfs send
From: Filipe David Manana <fdmanana@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 31, 2014 at 5:35 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Sat, Mar 29, 2014 at 05:21:23PM -0700, Marc MERLIN wrote:
>> I had a look at
>> http://bj0z.wordpress.com/2011/04/27/determining-snapshot-size-in-btrfs/#comment-35
>> but it's quite old and does not work anymore since userland became
>> incompatible with it.
>>
>> Has anyone seen something newer or have a newer fixed version of this?
>
> While watching a btrfs send|receive going for hours, keeping the
> backup disk array spinning in my living room, and my wondering "how far
> is it from being done", I was thinking:
>
> Would it be reasonably simple for btrfs send -p to have a few more
> features?
> 1) don't read all the data from disk, just read the metadata and tell me
> how many megabytes it will take to send.
> I can do this with
> btrfs send | wc -c
> I believe, but it would be better if it could do this without reading all
> the data blocks to send when I'm only caring about the byte output
>
> In turn this could be used to easily compute snapshot size diffs at
> least from one another.

Totally agree.
A progress indicator makes the feature much more user friendly.
In fact this is something I had been thinking for a while, but didn't
start implementation until a couple days ago after your mail. Here's a
couple RFC patches (kernel and btrfs-progs) with a prototype:

https://patchwork.kernel.org/patch/3938801/
https://patchwork.kernel.org/patch/3938811/

>
>
> 2) output a list of files added/changed/removed, maybe with how much
> data is related to each.
> Arguably this would supersede 1) above even if it would be a little bit
> more work to do

That would be cool I think. Most of what is needed is already
implemented in the send code.
You can get it somehow, in a not very user friendly way by passing the
flag BTRFS_SEND_FLAG_NO_FILE_DATA to the send ioctl, which doesn't
send any data back, only information about new/modified extent's
offset and length and passing -vvv to btrfs receive.

>
>
> 3) when a real btrfs send is running, just like dd, I could send it a
> USR1 signal and it would output some kind of progress report.
> The Ted T'so motto (used for e2fsck) is "everything with a progress bar
> is faster" :)
> Note, the progress wouldn't have to be perfect, it could be by number of
> blocks, number of files, anything reasonably easy to implement it on.
>
> Does that sound reasonable?

It does.

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
