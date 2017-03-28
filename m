Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:34440 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754664AbdC1IQr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 04:16:47 -0400
Received: by mail-qt0-f177.google.com with SMTP id n21so57758785qta.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Mar 2017 01:16:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170327171817.GN4781@twin.jikos.cz>
References: <CABxMtgcGod=FvgHagua07bzPjc7cy_+v0hkbTvwH_7GggOh9Ow@mail.gmail.com>
 <a43bf7e1-36fe-cb49-d0ba-697ddaf1a14e@suse.com> <CABxMtgdx_aC53bL0XAZaTCX=8P6=J_+Z5jyUSS1GyES_5zw_qA@mail.gmail.com>
 <20170327171817.GN4781@twin.jikos.cz>
From: Denis Kirjanov <dkirjanov@cloudlinux.com>
Date: Tue, 28 Mar 2017 11:16:35 +0300
Message-ID: <CABxMtgeihqoUWA=aqEXU9GYrydUufgpbZ6v5+BRYCdj9kiSUwQ@mail.gmail.com>
Subject: Re: __link_block_group uses GFP_KERNEL
To: dsterba@suse.cz, Denis Kirjanov <dkirjanov@cloudlinux.com>,
        Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, chris.mason@fusionio.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/27/17, David Sterba <dsterba@suse.cz> wrote:
> On Sat, Mar 25, 2017 at 09:48:28AM +0300, Denis Kirjanov wrote:
>> On 3/25/17, Jeff Mahoney <jeffm@suse.com> wrote:
>> > On 3/24/17 5:02 AM, Denis Kirjanov wrote:
>> >> Hi guys,
>> >>
>> >> Looks like that current code does GFP_KERNEL allocation inside
>> >> __link_block_group.
>> >> the function invokes kobject_add and internally creates sysfs files
>> >> with the GFP_KERNEL flag set.
>> >
>> > Yep, that's a bug.
>> >
>> >> But since do_chunk_alloc executes insides the btrfs transaction it's
>> >> not allowed to sleep.
>> >
>> > It's allowed to sleep but isn't allowed to do reclaim that involves
>> > file
>> > system writeback.  Michal Hocko's allocation context idea would fix
>> > this, but it's not there yet, so we'll need to defer the kobject_add
>> > until we can use GFP_KERNEL.
>>
>> Ok, I see. Can you point out to the initial patchset?
>
> https://lwn.net/Articles/716323/
>
> Fixing this properly is a lot of work so we might need to add a
> temporary workaround, as Jeff suggests, to move calling into sysfs to a
> later time.
>

Care to send a patch?
Or I can dig a bit.

Thanks!
