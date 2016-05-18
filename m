Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36361 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbcERDyP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 23:54:15 -0400
Received: by mail-oi0-f67.google.com with SMTP id i2so7350119oib.3
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 20:54:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJVJNe6wp-dhDKB2u6x73fk3OQ0KOVozkOEJ-feZn8RT5wOecw@mail.gmail.com>
References: <CABt16=EDFKFj4duaWJ0qCS_SO9TE2jn8UMCx5e_u+X+M328yeA@mail.gmail.com>
	<4218ab2f-def8-6541-427d-49091f70e342@gmail.com>
	<CAJCQCtRCFTEHoGxDMccJx7CLSPwLqSiqhd6--niCzrQ1FtJ+Bg@mail.gmail.com>
	<CAJVJNe4Ek8UR3Qq+p9fAu3bU-2dCdDcothgR=S6CsQKOo6zKFg@mail.gmail.com>
	<CAJCQCtTKDoZEKovqm4k=pPNDenDVAiFDGZDMvns4T9DD4tJsZw@mail.gmail.com>
	<CAJVJNe6wp-dhDKB2u6x73fk3OQ0KOVozkOEJ-feZn8RT5wOecw@mail.gmail.com>
Date: Tue, 17 May 2016 21:54:13 -0600
Message-ID: <CAJCQCtT2UxsP+DWbpOyiedFu-GJt0B7Raosjn-oapzagm9MxuA@mail.gmail.com>
Subject: Re: Corrupted system due to imbalanced metadata chunks
From: Chris Murphy <lists@colorremedies.com>
To: Goni Zahavy <goni1993@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Peter Kese <peter.kese@viidea.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 17, 2016 at 3:58 PM, Goni Zahavy <goni1993@gmail.com> wrote:
> On 5/18/16, Chris Murphy <lists@colorremedies.com> wrote:
>> On Tue, May 17, 2016 at 2:27 PM, Goni Zahavy <goni1993@gmail.com> wrote:
>>> Guys, just remember that this crappy-installer behavior works
>>> "as-expected"
>>> on every other filesystem.
>>
>> It also fails as expected on every other file system if the upgrade is
>> interrupted for reasons that have nothing to do with the file system;
>> what's in common is the lack of a fail safe upgrade design. And this
>> is not a ding on Ubuntu, it's a widespread and well recognized risk.
>> All that's happening here is Btrfs has one more vector to expose that
>> deficiency.
>
> I fully agree, but I talked about the "many small files unpacked to
> temp on disk location then copied.." which is just plain badness

I think the idea is that if it's overwriting in the live tree as it
unpacks, there's a long time where it can be interrupted and any
interruption puts the system in an ambiguous state with a mix of old
and new binaries.

Where if the unpacking happens elsewhere and is then moved, it's not
committed until fsync of files and containing directory. While it can
still be interrupted the time frame for this is much smaller so
there's a better chance you get all old files or all updated files,
and not some in between state.

It might be a case of necessity rather than preferred design.


> It's great that we have workarounds for the user/distribution to
> apply. And If this is a known issue, I would expect that Peter Kese
> would be answered here with "it's a known issue, here is how you can
> work around it the next time. And it was written in underlined bold
> warning on this wiki page. Stay tuned.".

Known issue yes.

https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_Btrfs_claims_I.27m_out_of_space.2C_but_it_looks_like_I_should_have_lots_left.21

But it can be triggered by different workloads and it may not always
be that the fs can't allocate a new metadata chunk. It's a tricky
problem. And it doesn't always happen.


> In addition, I would expect bugs like this one that hit even simple
> single-mode setups to be prioritized way way higher then any new
> feature or even some existing advanced feature enhancements.

Well I know at least one of the three upstream maintainers has been
working on the enospc problem since at least 2009, until at least
March of this year when his "Enospc rework" patches for review popped
up on the list. That work is in linux-next right now, so it looks like
it appears in kernel 4.7.

But that's maybe orthogonal to the trickiness of getting df to report
something both semi-sane and consistently so, for the inevitable and
enduring apps that'll remain naive, as Austin aptly puts it, about the
actual space available on the file system. The problem there is that
there are in effect two free spaces on Btrfs depending on what and how
much is going to get written.


-- 
Chris Murphy
