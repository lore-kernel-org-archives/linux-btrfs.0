Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45549 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab2JHPG3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 11:06:29 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so3934320oag.19
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Oct 2012 08:06:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121008131912.GA4132@shiny>
References: <1347875936-14165-1-git-send-email-bo.li.liu@oracle.com>
	<1347875936-14165-2-git-send-email-bo.li.liu@oracle.com>
	<CAKcLGm_4iUB1B8DPOx1D7i8eMa7po9fWFUYVOqp1N9nmZ1ExHQ@mail.gmail.com>
	<50625569.9040102@oracle.com>
	<20121003140259.GA4458@shiny>
	<5072C492.8040205@oracle.com>
	<20121008131912.GA4132@shiny>
Date: Mon, 8 Oct 2012 10:06:28 -0500
Message-ID: <CAKcLGm9u5XSWK09YNd1+ZhoEmFq+oY4GwppWeSEoUbZ6juYc=Q@mail.gmail.com>
Subject: Re: [PATCH 2/2 v3] Btrfs: snapshot-aware defrag
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Chris Mason <chris.mason@fusionio.com>, Liu Bo <bo.li.liu@oracle.com>,
        Chris Mason <clmason@fusionio.com>,
        Mitch Harder <mitch.harder@sabayonlinux.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dave@jikos.cz" <dave@jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 8, 2012 at 8:19 AM, Chris Mason <chris.mason@fusionio.com> wrote:
> On Mon, Oct 08, 2012 at 06:18:26AM -0600, Liu Bo wrote:
>> On 10/03/2012 10:02 PM, Chris Mason wrote:
>> > On Tue, Sep 25, 2012 at 07:07:53PM -0600, Liu Bo wrote:
>> >> On 09/26/2012 01:39 AM, Mitch Harder wrote:
>> >>> On Mon, Sep 17, 2012 at 4:58 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> >>>> This comes from one of btrfs's project ideas,
>> >>>> As we defragment files, we break any sharing from other snapshots.
>> >>>> The balancing code will preserve the sharing, and defrag needs to grow this
>> >>>> as well.
>> >>>>
>> >>>> Now we're able to fill the blank with this patch, in which we make full use of
>> >>>> backref walking stuff.
>> >>>>
>> >>>> Here is the basic idea,
>> >>>> o  set the writeback ranges started by defragment with flag EXTENT_DEFRAG
>> >>>> o  at endio, after we finish updating fs tree, we use backref walking to find
>> >>>>    all parents of the ranges and re-link them with the new COWed file layout by
>> >>>>    adding corresponding backrefs.
>> >>>>
>> >>>> Originally patch by Li Zefan <lizf@cn.fujitsu.com>
>> >>>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>> >>>
>> >>> I'm hitting the WARN_ON in record_extent_backrefs() indicating a
>> >>> problem with the return value from iterate_inodes_from_logical().
>> >
>> > Me too.  It triggers reliably with mount -o autodefrag, and then crashes
>> > a in the next function ;)
>> >
>> > -chris
>> >
>>
>> Hi Chris, Mitch,
>>
>> I'm afraid that I may need a little more time to fix all bugs in it because there seems to be
>> some backref walking bugs mixed in, and at least 4 different crashes make it harder to address bugs.
>>
>> I use an 1G random write fio job running in background, following by creating 20 snapshots in background,
>> and mount -o autodefrag.
>>
>> So if your crash is quite stable in one place, please let me know the steps.
>
> I have a notmuch mail database.  I just receive mail with auto defrag on
> and it crashes.  Chrome databases may do it as well.
>
> If it helps, I have compression too.
>
> -chris
>

I can usually reproduce fairly quickly, but I don't have a test that
fails in exactly the same spot every time.

My tests usually involve manipulating kernel git sources with
autodefrag (and usually lzo compression).  I have also hit a similar
error when balancing a partition with multiple snapshots.

I'll go back and review my methods for replicating, and see if any of
them can reproduce predictably.
