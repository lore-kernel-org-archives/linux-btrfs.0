Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60549 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758074Ab3HINRh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Aug 2013 09:17:37 -0400
Received: by mail-bk0-f46.google.com with SMTP id 6so1383749bkj.5
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Aug 2013 06:17:35 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20130809000109.GH5284@twin.jikos.cz>
References: <1375813640-14063-1-git-send-email-fdmanana@gmail.com>
	<20130807104041.GN5284@twin.jikos.cz>
	<CAL3q7H7j1Hfx6p-dxP=+C_6uVa7gG22KTQr2_PphMLy3sPeLyw@mail.gmail.com>
	<20130809000109.GH5284@twin.jikos.cz>
Date: Fri, 9 Aug 2013 14:17:35 +0100
Message-ID: <CAL3q7H5vjxjwJjOzUo4ZkHdHNqfTf3BnsPT+KWBn8vPd1gzisg@mail.gmail.com>
Subject: Re: [PATCH RFC] Btrfs: add support for persistent mount options
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 9, 2013 at 1:01 AM, David Sterba <dsterba@suse.cz> wrote:
> On Wed, Aug 07, 2013 at 12:33:09PM +0100, Filipe David Manana wrote:
>> Thanks, I missed to find that before.
>> The implementation is very different from the one I proposed.
>
> That's one of the fundaental questions how to store the information:
> inside existing structures, via xattrs, under new tree items. Each one
> has pros and cons.
>
>> > Designing and merging the properties feature takes time, but we want to tune
>> > simple things now. The wiki project mentions ‘tune2fs’ as an example, but the
>> > project details are not always accurate about how to do the things, it’s more
>> > like ideas what to do. If you’re going to work on that, please claim the
>> > project on the wiki, and possibly write more details abou the design.
>>
>> I will.
>
> The project is titled as persistent mount options, are you willing to
> take the more general "per-object properties" task? IMHO there's not
> much difference, the UI should be the same, just that it implements
> per-fs or per-subvolume properties like mount options. The rest of the
> object properties has to be collected and agreed on. I'm sure there's
> community knowledge of what's desired, so it's a matter of writing it
> down and bikeshe^Wagreement on the naming syntax.

Yes, I will.
I'll get back to this soon and update the wiki page.

thanks

>
> david



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
