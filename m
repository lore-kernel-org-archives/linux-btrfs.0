Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:43367 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622Ab2LIJOO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Dec 2012 04:14:14 -0500
Received: by mail-ie0-f175.google.com with SMTP id qd14so5417327ieb.20
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Dec 2012 01:14:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANTVtNqzGmK2fb3EEXtjAanNBGxBCN2T44wnMw9xLTYSyPV3vA@mail.gmail.com>
References: <CAFhuFEdxHxdiAutfxxsQ9i0OJj_CfRwWD-0LuhvoJYGHkTsG4A@mail.gmail.com>
	<CAOcd+r1LnMP=CU37mUSxZGuksTY4kYo+Y5vg9n3BV-E=ye=-Yg@mail.gmail.com>
	<CANTVtNqzGmK2fb3EEXtjAanNBGxBCN2T44wnMw9xLTYSyPV3vA@mail.gmail.com>
Date: Sun, 9 Dec 2012 11:14:13 +0200
Message-ID: <CAOcd+r2fS-=dCU-v8ZLUNGrS3ojfhLXYAtBek-JGvvOJLOar3Q@mail.gmail.com>
Subject: Re: Snapper snapshot comparison algorithm
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Mohit Bhadade <mohitbhadade@gmail.com>
Cc: nafisa mandliwala <nafisa.mandliwala@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mohit, Nafisa,
you should start reading from "changed_cb" function, which is the one
that notifies the send code about a particular change that needs to be
addressed.

The lowest-level instruction generation happens in functions like
"send_rename", "send_link", "send_unlink", "send_truncate" etc.

The best way to understand what is in between, is to stuff the code
with printk's and see what is happening (do a small change to the
file, observe the prints). This is how I learned:)

For starter, for example, create some file, do send, then grow the
file and see how the send code detects and reacts to this change. The
trickiest part is handling the changes in file name/hardlinks. So try
to rename the file and see what the code does.

You may also read through discussions with Alexander Block on the
list, on the link that I posted and others.

Alex.


On Thu, Dec 6, 2012 at 11:16 AM, Mohit Bhadade <mohitbhadade@gmail.com> wrote:
> Hello,
> Could oomeone please tell me how the instruction generation based on
> differences in snapshots takes place in the send receive code. ? I am going
> through the code but cant understand the hierarchy of structures declared in
> it. Some one please direct me to the function where the instructions are
> generated.
>
> Thanks
>
>
> On Sat, Dec 1, 2012 at 2:00 PM, Alex Lyakas <alex.btrfs@zadarastorage.com>
> wrote:
>>
>> Hi nafisa,
>> in order to understand how btrfs send code compares two btrfs file
>> trees, you may read this:
>> http://www.spinics.net/lists/linux-btrfs/msg17731.html (where I am
>> trying to understand it) and further down the thread. It's a very nice
>> algorithm, actually.
>>
>> Thanks,
>> Alex.
>>
>>
>>
>> On Sat, Dec 1, 2012 at 9:54 AM, nafisa mandliwala
>> <nafisa.mandliwala@gmail.com> wrote:
>> > I needed help with understanding the snapshot comparison algorithm
>> > that snapper uses and its shortcomings. From reading the code, what I
>> > understood is that it does a block by block compare. I'm not very sure
>> > if that's the best way to go about it. Also, since the send receive
>> > code is still in development stages, is there a scope to add more
>> > functionality to it?
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>> > in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
