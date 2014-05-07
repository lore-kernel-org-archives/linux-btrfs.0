Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:57258 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaEGWjT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 18:39:19 -0400
Received: by mail-ob0-f170.google.com with SMTP id uy5so2055478obc.15
        for <linux-btrfs@vger.kernel.org>; Wed, 07 May 2014 15:39:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140507085240.GN10159@merlins.org>
References: <pan$43f87$1b04f612$26876f7$5d505a6d@cox.net>
	<pan$31100$5edd829$14fe1b2f$4e1f4bd7@cox.net>
	<pan$a6ac4$b6e79aa$56ddd950$5b7b75c2@cox.net>
	<20140507081840.GM10159@merlins.org>
	<20140507082941.GA19199@carfax.org.uk>
	<20140507085240.GN10159@merlins.org>
Date: Wed, 7 May 2014 17:39:18 -0500
Message-ID: <CAKcLGm9gJ0ZRwp_h=AtP8ArdC7Yuq_Cspxg=23FS4reazO6R+g@mail.gmail.com>
Subject: Re: raid0 vs single, and should we allow -mdup by default on SSDs?
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Marc MERLIN <marc@merlins.org>
Cc: Hugo Mills <hugo@carfax.org.uk>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 7, 2014 at 3:52 AM, Marc MERLIN <marc@merlins.org> wrote:
> On Wed, May 07, 2014 at 09:29:41AM +0100, Hugo Mills wrote:
>> On Wed, May 07, 2014 at 01:18:40AM -0700, Marc MERLIN wrote:
>> > On Tue, May 06, 2014 at 07:39:12PM +0000, Duncan wrote:
>> > > That appears to be a very good use of either -d raid0 or -d single, yes.
>> > > And since you're apparently not streaming such high resolution video that
>> > > you NEED the raid0, single does indeed give you a somewhat better chance
>> > > at recovery.
>> >
>> > zoneminder saves 'video' as a stream of independent small jpegs, so I'm
>> > good. Actually come to think of it they're so small that they probably
>> > all ended up in the raid1 metadata. That also means that I'm not getting
>> > twice the storage space like I planned to. Oh well...
>>
>>    There's a mount option to change the threshold at which files are
>> inlined in metadata: maxinline=<bytes>. You could play with that for
>> this particular use-case.
>
> Oh cool, thank you.
>

Since each non-inlined file will occupy a minimum of 4k, you may find
that inlining will still save space even if it is duplicated.

Even if they are duplicated in the metadata under RAID1, inlining a
bunch of 256 byte files will still be more space efficient than
storing them as regular files.

But if most of the files are in the 2k-3k range, you may be more
efficient to store them as files.
