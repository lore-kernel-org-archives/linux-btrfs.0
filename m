Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34692 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933957AbcKWRsq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Nov 2016 12:48:46 -0500
Received: by mail-io0-f194.google.com with SMTP id r94so2430090ioe.1
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Nov 2016 09:48:46 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAL3q7H5ngp02fS8LyL-DDYGW9Y9CTakqZ=1c3bYTUZHi6OobzA@mail.gmail.com>
References: <fe9b1bde-9069-b75f-eb53-83b729cde711@suse.com>
 <1472844934-32343-1-git-send-email-bo.li.liu@oracle.com> <CAL3q7H5oCqgd9im-2AZA=zsOv+SCObon2f5wECA7hr58MNXTGw@mail.gmail.com>
 <20160906215151.GB31641@localhost.localdomain> <CAL3q7H7GEDy-NfPgWE7BN_+M8-hRPJ77BKgbrhbkhTcnjAQ7nQ@mail.gmail.com>
 <20161013003725.GA21350@localhost.localdomain> <CAL3q7H4XtHdr+PmCO-ExqJrpYrf6Zuh=jCWL_5jZV06kCtx_KA@mail.gmail.com>
 <20161017130025.GI11398@twin.jikos.cz> <20161017154443.GA13942@localhost.localdomain>
 <CAL3q7H5ngp02fS8LyL-DDYGW9Y9CTakqZ=1c3bYTUZHi6OobzA@mail.gmail.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 23 Nov 2016 17:48:45 +0000
Message-ID: <CAL3q7H7MrcPCN64eWNtLm1=podB1o-hJm5=24qQ5bA6-L9iJwQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix BUG_ON in btrfs_mark_buffer_dirty
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>, Chris Mason <clm@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 23, 2016 at 1:15 PM, Filipe Manana <fdmanana@gmail.com> wrote:
> On Mon, Oct 17, 2016 at 4:44 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> On Mon, Oct 17, 2016 at 03:00:25PM +0200, David Sterba wrote:
>>> On Thu, Oct 13, 2016 at 09:47:11AM +0100, Filipe Manana wrote:
>>> > > Since the crash is similar to the call chains from Jeff's report,
>>> > > ie.
>>> > > btrfs_del_csums
>>> > >   -> btrfs_search_slot
>>> > >      -> btrfs_cow_block
>>> > >         -> btrfs_mark_buffer_dirty
>>> > >
>>> > > I just wonder that whether 4.8.0-rc8-btrfs-next-35+ has
>>> > >
>>> > > "[PATCH] Btrfs: fix BUG_ON in btrfs_mark_buffer_dirty" ?
>>> >
>>> > It isn't there, this 4.8.0-rc8-btrfs-next-35+ is a checkout of Chris'
>>> > for-linus-4.9 branch.
>>> > That patch should have been there, I was convinced that all these
>>> > related patches were already there, as it's impossible to run xfstests
>>> > with the integrity checker enabled.
>>>
>>> The referenced patch is the one in this thread, no? You've reported that
>>> even with that applied you can still reproduce a crash with integrity
>>> checker enabled. I haven't queued it as it seems it's an incomplete fix,
>>> thus waiting for another version.
>>
>> Yes, it's one of three patches in this thread, and they fixed different
>> problems,
>>
>> - the original patch and its v2 are to make check_leaf check non-root
>> leaf with zero-item,
>> - "[PATCH] Btrfs: fix BUG_ON in btrfs_mark_buffer_dirty" is to fix
>> check_leaf, which fixes the crash from Jeff's.
>> - "[PATCH] Btrfs: remove unnecessary btrfs_mark_buffer_dirty in split_leaf"
>>  is targeting a different crash with check integrity enabled, which
>> comes from Filipe's report.
>>
>> So to make sure I understand the whole thing, Filipe, can you reproduce the
>> crash around btrfs_del_csums() after applying this patch
>>  "[PATCH] Btrfs: fix BUG_ON in btrfs_mark_buffer_dirty"?
>
> So indeed, what is missing is patch from this thread, subject "Btrfs:
> fix BUG_ON in btrfs_mark_buffer_dirty".
> That is clearly missing in Linus' tree:
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/log/?id=refs%2Ftags%2Fv4.9-rc6&qt=author&q=liu+bo
>
> On the other hand, the other patch attached later to this thread, that
> removes the unnecessary btrfs_mark_buffer_dirty() was sent to Linus:
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=196e02490c934398f894e5cb0ee1ac8ad13ca576
>
> It seems I'm the only one running xfstests with the integrity checker
> enabled... Because it fails right away at btrfs/001 either with
> 4.9-rcs or Chris' for-linus-4.9.
> Applying "Btrfs: fix BUG_ON in btrfs_mark_buffer_dirty" fixes it.

Can you please resend the patch with a cc stable tag? Like:

    Fixes: 1ba98d086fe3 (Btrfs: detect corruption when non-root leaf
has zero item)
    Cc: stable@vger.kernel.org  # 4.8+

Since the offending patch is in 4.8 already.

Also I spoke too early before. Even with that patch we still one more
issue: https://patchwork.kernel.org/patch/9444045/


Thanks Bo.

>
> thanks
>
>
>
>>
>> Thanks,
>>
>> -liubo
>
>
>
> --
> Filipe David Manana,
>
> "People will forget what you said,
>  people will forget what you did,
>  but people will never forget how you made them feel."



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
