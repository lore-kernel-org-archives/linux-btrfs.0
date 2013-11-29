Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:54902 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab3K2Tzj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Nov 2013 14:55:39 -0500
Received: by mail-bk0-f41.google.com with SMTP id v15so4451507bkz.14
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Nov 2013 11:55:38 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20131129154525.GN25312@twin.jikos.cz>
References: <20131129154525.GN25312@twin.jikos.cz>
Date: Fri, 29 Nov 2013 19:55:37 +0000
Message-ID: <CAL3q7H7CmaKsnQQacpZck3zGV35ikhTwqX=Xg9eAiM97kb5TwA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: optimize btrfs_lookup_extent_info() - extent
 refcount mismatches?
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        clm@fb.com, jbacik@fb.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 29, 2013 at 3:45 PM, David Sterba <dsterba@suse.cz> wrote:
> Hi,
>
> On Fri, Jul 05, 2013 at 09:32:05PM +0100, Filipe David Borba Manana wrote:
>> If we're looking for a metadata item in the tree and the
>> search fails with return value of 1, and the slot doesn't
>> point to the first item in the leaf, check if the previous
>> item in the leaf corresponds to an extent item for the same
>> object id - if it does, then don't do another tree search
>> to get it.
>
> I'm suspecting this patch to cause some trouble, see
> https://bugzilla.kernel.org/show_bug.cgi?id=64961

Hi David,

What makes you believe the problem is exactly in this function?

I read it again, and I can't see how it can miss an extent item that
it couldn't before, specially without skinny metadata enabled.  Did
the fs had skinny metadata enabled?

thanks


>
> but there were more reports similar to this one:
> http://www.spinics.net/lists/linux-btrfs/msg29243.html
> http://www.spinics.net/lists/linux-btrfs/msg29478.html
>
> I did a quick analysis in comment 3, the warning pops when there are 0
> references, there's no other evidence that the extent should have none.
> This happens during balance, so far the working hypothesis is that the
> refcount changes during relocation (eg. subvolume deletion) but is not
> fixed up in the late reloc phase.
>
> fsck finds lots of wrong refcounts, off by one. The kernel warning fires
> only if the refcount is 0 though there are > 0 expected. So this could
> mean that the refcount is silently wrong all the time.
>
>
> david



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
