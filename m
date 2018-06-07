Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:34703 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752553AbeFGGGH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2018 02:06:07 -0400
MIME-Version: 1.0
In-Reply-To: <20180606204215.GD9445@wotan.suse.de>
References: <20180508180436.716-1-mfasheh@suse.de> <20180508233840.GM10363@dastard>
 <e6698201-a4a6-2146-d4c9-9e26c18ad828@suse.com> <20180509064103.GP10363@dastard>
 <5b2ae799-1595-c262-7b65-41b10c11906d@suse.com> <CAOQ4uxjUwi7dhTbNk1mK6_=rb_+L0JB1GG_mkGSDrudtocXScg@mail.gmail.com>
 <20180606204215.GD9445@wotan.suse.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 7 Jun 2018 09:06:04 +0300
Message-ID: <CAOQ4uxgiUu8Vv__uYP+g5Q+c1Ng=_v0mx4t0A6D8fNsA6usbMg@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/76] vfs: 'views' for filesystems with more than one root
To: Mark Fasheh <mfasheh@suse.de>
Cc: Jeff Mahoney <jeffm@suse.com>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 6, 2018 at 11:42 PM, Mark Fasheh <mfasheh@suse.de> wrote:
> Hi Amir, thanks for the comments!
>

Hi Mark,

[...]
>
> Btw, sorry that the name is confusing. I've never been good at picking them.

Didn't say that it was confusing. It might very well be the perfect name...
if I only knew what sort of thing we are trying to name...

> That said, if you have a minute to check out the first patch or two you'll
> see that the patches are basically putting a struct in between the super
> block and the inode.
>
>
> One thing I'd like to politely suggest is that anyone now following this
> conversation to please read the at least the first patch. It's an easy read
> and I feel like the conversation overall would be much more clear if
> everyone understood what we're going for. I worry that I didn't do a
> particularly good job explaining the actual code changes.
>
> https://www.spinics.net/lists/linux-fsdevel/msg125492.html
>


I did look at the patches. They look simple and clean and they solve A problem.
All I'm saying is that we should look at the set of problems that we know of
before we design an abstraction layer.

>
> Regarding a layout of the problems, I have a more complete e-mail coming
> soon which should describe in detail the issues I've seen with respect to
> how the kernel is exporting ino/dev pairs (outside of statx). fs_view alone
> is not enough to solve that problem. I'd be happy to CC you on that one if
> you'd like.
>

Sure.

[...]

>>
>> And what is the SUSE way?
>
> At SUSE, we carry a version of this patch:
>
> https://marc.info/?l=linux-btrfs&m=130532890824992&w=2
>
> Essentially a callback which was rejected for various reasons.
>

Don't see a patch here. Wrong link?

> The fs_view work was intended to replace that patch with an upstream
> solution.
>
>

[...]

>>
>> FYI, the Overlayfs file/inode mapping is about to change with many
>> VFS hacks queued for removal, so stay tuned.
>>
>> [...]
>
> Actually, would you mind giving me a pointer to this work? I'd be very
> interested to see what exactly might be changing.
>

Mostly, less VFS code is going to be exposed to underlying inode:

https://marc.info/?l=linux-fsdevel&m=152760014530531&w=2

[...]

>> I have an interest of solving another problem.
>> In VFS operations where only inode is available, I would like to be able to
>> report fsnotify events (e.g. fsnotify_move()) only in directories under a
>> certain subtree root. That could be achieved either by bind mount the subtree
>> root and passing vfsmount into vfs_rename() or by defining an fs_view on the
>> subtree and mounting that fs_view.
>
> I'm not sure whether fs_view works for this. Taking a quick look at
> fsnotify, the state is already on the inode? If there's a globabl fsnotify
> state that needs to be per subtree than yes we could move that to the
> fs_view and you'd simply deref it from the inode struct.
>

That was my thinking. I have patches to attach an fsnotify mark
to super block. If fs_view could have a root that is different than
super block's root and if file system can guaranty that objects
cannot be moved outside of fs_view root, then fsnotify mark
could be attached to fs_view.

Thanks,
Amir.
