Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50866 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3ARFXE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jan 2013 00:23:04 -0500
Received: by mail-ob0-f174.google.com with SMTP id ta14so3363136obb.5
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2013 21:23:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130118005355.GB6768@liubo>
References: <1358339768-2314-1-git-send-email-bo.li.liu@oracle.com>
	<CAKcLGm8QDNEs3nF=VDGtRWVV9MNg9SZr0ZBH1fiqTRgJyJgOvg@mail.gmail.com>
	<20130118005355.GB6768@liubo>
Date: Thu, 17 Jan 2013 23:23:03 -0600
Message-ID: <CAKcLGm91VV1TtMCNP0jmgyE9VzYy=wZacrppGEYK=S7N+qbU2w@mail.gmail.com>
Subject: Re: [PATCH V5] Btrfs: snapshot-aware defrag
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com, JBacik@fusionio.com,
        dave@jikos.cz, kitayama@cl.bb4u.ne.jp, miaox@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 17, 2013 at 6:53 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Thu, Jan 17, 2013 at 08:42:46AM -0600, Mitch Harder wrote:
>> On Wed, Jan 16, 2013 at 6:36 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> > This comes from one of btrfs's project ideas,
>> > As we defragment files, we break any sharing from other snapshots.
>> > The balancing code will preserve the sharing, and defrag needs to grow this
>> > as well.
>> >
>> > Now we're able to fill the blank with this patch, in which we make full use of
>> > backref walking stuff.
>> >
>> > Here is the basic idea,
>> > o  set the writeback ranges started by defragment with flag EXTENT_DEFRAG
>> > o  at endio, after we finish updating fs tree, we use backref walking to find
>> >    all parents of the ranges and re-link them with the new COWed file layout by
>> >    adding corresponding backrefs.
>> >
>> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>> > ---
>> > v4->v5:
>> >       - Clarify the comments for duplicated refs.
>> >       - Clear defrag flag after we're ready to defrag.
>> >       - Fix a bug on HOLE extent.
>> > v3->v4:
>> >       - Fix duplicated refs bugs detected by mounting with autodefrag, thanks
>> >         for the bug report from Mitch and Chris.
>> > v2->v3:
>> >       - Rebase
>> > v1->v2:
>> >       - Address comments from David.
>> >
>>
>> I've been testing this patch on a 3.7.2 kernel merged with the
>> for-linus branch for the 3.8_rc kernels, and I'm seeing the following
>> error:
>
> Hi Mitch,
>
> Insteresting!  I don't even change the snapshot code ever.

Yes, this patch series has been excellent at tickling unrelated issues.

> Is it reproducable stably from your side?  Still with the
> snapshot-test-pub scripts?

I'm still using the same snapshot-test scripts, but they don't
reproduce reliably.  I have to run for a while after my script reaches
the point where it starts deleting snapshots to make space.

But, I've been able to hit this error four times with this script.

I'll try to keep playing with this to make a better reproducer, and to
isolate the problem with the parameter supplied to list_del.
