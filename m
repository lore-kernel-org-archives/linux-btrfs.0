Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f196.google.com ([209.85.213.196]:34778 "EHLO
	mail-ig0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531AbcDDQCo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Apr 2016 12:02:44 -0400
Received: by mail-ig0-f196.google.com with SMTP id qu10so9078928igc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 09:02:39 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <57028E42.1090901@googlemail.com>
References: <56F550DD.1030200@googlemail.com>
	<20160404135641.GB3412@twin.jikos.cz>
	<57028E42.1090901@googlemail.com>
Date: Mon, 4 Apr 2016 17:02:38 +0100
Message-ID: <CAL3q7H5XDU2sNEVmYYsc7L72zCbN7Dpdx-nsSETwdJQd529z0A@mail.gmail.com>
Subject: Re: [PATCH] delete obsolete function btrfs_print_tree()
From: Filipe Manana <fdmanana@gmail.com>
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 4, 2016 at 4:54 PM, Holger Hoffstätte
<holger.hoffstaette@googlemail.com> wrote:
> On 04/04/16 15:56, David Sterba wrote:
>> On Fri, Mar 25, 2016 at 03:53:17PM +0100, Holger Hoffstätte wrote:
>>> Dan Carpenter's static checker recently found missing IS_ERR handling
>>> in print-tree.c:btrfs_print_tree(). While looking into this I found that
>>> this function is no longer called anywhere and was moved to btrfs-progs
>>> long ago. It can simply be removed.
>>
>> I'm not sure, the function could be used for debugging, and it's hard to
>
> ..but is it? So far nobody has complained.

I will complain.
I use this function frequently during development, and there's a good
reason to use it
instead of the user space tool btrfs-debug-tree.

>
>> say if we'll ever need it.  Printing the whole tree to the system log
>> would produce a lot of text so some manual filtering would be required,
>> the function could serve as a template.
>
> The original problem of missing error handling from btrfs_read_tree_block()
> remains as well. I don't remember if that also was true for the btrfs-progs
> counterpart, but in in any case I didn't really know what to do there.
> Print an error? silently ignore the stripe? abort? When I realized that the
> function was not called anywhere, deleting it seemed more effective.
>
> Under what circumstances would the in-kernel function be more
> practical or useful than the userland tool?

The user land tool requires the btree nodes to be on disk. With the in
kernel function we can print nodes
that are not yet on disk, very useful during development.

So no, we should not delete it in my opinion. It's not serious if it
doesn't have all the proper error handling
and etc, it's just something for debugging purposes.

 It does the same, won't disturb
> or wedge the kernel further, is up-to-date and can be scripted.
> I agree that in-place filtering (while iterating) would be nice to have,
> but that's also a whole different problem and would IMHO also be better
> suited for userland.
>
> When in doubt cut it out.

When in doubt leave it alone.

>
> Holger
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
