Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36489 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbbLNU1x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 15:27:53 -0500
Received: by iofo67 with SMTP id o67so56855824iof.3
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 12:27:53 -0800 (PST)
Subject: Re: btrfs: poor performance on deleting many large files
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
 <pan$eea04$e9596e27$78b44461$c5754723@cox.net>
 <1448488198.4717.4.camel@gmail.com>
 <pan$8ce6a$31af576$4416e55e$7b867388@cox.net>
 <1448562347.8809.16.camel@scientia.net>
 <pan$54542$5eb77bd3$8682bff8$82310de1@cox.net>
 <1448582805.11377.9.camel@scientia.net>
 <pan$34543$2ed1f043$2f803125$884b36c0@cox.net>
 <1448683025.6837.4.camel@scientia.net>
 <pan$46a28$81694e9d$c6d5f048$1c8bcdd8@cox.net>
 <1449958538.15961.3.camel@scientia.net> <566ED124.30803@gmail.com>
 <1450121957.6629.41.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <566F261F.4040705@gmail.com>
Date: Mon, 14 Dec 2015 15:27:11 -0500
MIME-Version: 1.0
In-Reply-To: <1450121957.6629.41.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-14 14:39, Christoph Anton Mitterer wrote:
> On Mon, 2015-12-14 at 09:24 -0500, Austin S. Hemmelgarn wrote:
>> Unless things have changed very recently, even many modern systems
>> update atime on read-only filesystems, unless the media itself is
>> read-only.
> Seriously? Oh... *sigh*...
> You mean as in Linux, ext*, xfs?
Possibly, I know that Windows 7 does it, and I think OS X and OpenBSD do 
it, but I'm not sure about Linux.
>
>> If you have software that actually depends on atimes, then that
>> software
>> is broken (and yes, I even feel this way about Mutt).
> I don't disagree here :D
>
>> The way atimes
>> are implemented on most systems breaks the semantics that almost
>> everyone expects from them, because they get updated for anything
>> that
>> even looks sideways at the inode from across the room.  Most software
>> that uses them expects them to answer the question 'When were the
>> contents of this file last read?', but they can get updated even for
>> stuff like calculating file sizes, listing directory contents, or
>> modifying the file's metadata.
> Sure... my point here again was, that I try to look every now and then
> at the whole thing from the pure-end-user side:
> For them, the default is relatime, and they likely may not want to
> change that because they have no clue on how much further effects this
> may have (or not).
> So as long as Linux doesn't change it's defaults to noatime, leaving
> things up to broken software (i.e. to get fixed), I think it would be
> nice for the end-user, to have e.g. snapshots be "save" (from the
> write-amplification on read) out of the box.
AFAIUI, the _only_ reason that that is still the default is because of 
Mutt, and that won't change as long as some of the kernel developers are 
using Mutt for e-mail and the Mutt developers don't realize that what 
they are doing is absolutely stupid.

FWIW, both Duncan and I have our own copy of the sources patched to 
default to noatime, and I know a number of embedded Linux developers who 
do likewise, and I've even heard talk in the past of some distributions 
possibly using such patches themselves (although it always ends up not 
happening, because of Mutt).
>
> My idea would be basically, that having a noatime btrfs-property, which
> is perhaps even set automatically, would be an elegant way of doing
> that.
> I just haven't had time to properly write that up and add is as a
> "feature request" to the projects idea wiki page.
I like this idea.
>
>
> Cheers,
> Chris.
>

