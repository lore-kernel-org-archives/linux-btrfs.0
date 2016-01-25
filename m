Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36167 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbcAYUYH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jan 2016 15:24:07 -0500
Received: by mail-io0-f172.google.com with SMTP id g73so167773377ioe.3
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 12:24:07 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20160125195608.GJ23751@merlins.org>
References: <20160123170354.GA10113@merlins.org>
	<56A57C59.1040203@cn.fujitsu.com>
	<20160125155541.GD23751@merlins.org>
	<CAL3q7H63tfdYgDppk9WUO6S8GQXk7F9d_MSE+DkVmjDP7oAtXg@mail.gmail.com>
	<20160125195608.GJ23751@merlins.org>
Date: Mon, 25 Jan 2016 20:24:06 +0000
Message-ID: <CAL3q7H5rj4j10d34Wm_RxVf1yj4kg0tabCEHQdJrL2LyWUorCQ@mail.gmail.com>
Subject: Re: 4.4.0: btrfs-send BUG_ON(sctx->cur_ino != sctx->cmp_key->objectid);
From: Filipe Manana <fdmanana@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 25, 2016 at 7:56 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Mon, Jan 25, 2016 at 07:46:52PM +0000, Filipe Manana wrote:
>> On Mon, Jan 25, 2016 at 3:55 PM, Marc MERLIN <marc@merlins.org> wrote:
>> > I still have 2 more days before I can rebuild my broken filesystem.
>> > In the meantime, I just got this new error with 4.4
>>
>> Nop, not new in 4.4. I have seen 1 report of someone hitting this with
>> a 4.0 kernel in the past. Not a problem with send afaics but some
>> inconsistent state achieved likely after adding/modifying/deleting a
>> xattr.
>>
>> Nothing new, just send the output of btrfs-debug-tree -t <parent
>> snapshot id> and for the send snapshot too. Also in the function that
>> triggered the BUG_ON(), add a printk like the following right before
>> the BUG_ON() line:
>>
>> if (sctx->cur_ino != sctx->cmp_key->objectid)
>>     printk(KERN_ERR "sctx->cur_ino = %llu, sctx->cmp_key->objectid =
>> %llu\n", sctx->cmp_key->objectid, sctx->cmp_key->objectid);
>>
>> And see the result in dmesg/syslog.
>
> Thanks for the reply.
> I may not be able to reproduce this soon or at all because I'm about to
> rebuild the damaged filesystem this happened on.
>
> The point is that my filesystem is damaged, but this is not a reason to
> crash the kernel and the machine.

I've seen that happen on a non-damaged filesystem, for which I didn't
get an image nor debug-tree's output before it got recreated. That's
what I want to figure out, how/why it happened.

> Can this be changed to an abort and remount read only instead?

Like many other bug_on's yes.

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
