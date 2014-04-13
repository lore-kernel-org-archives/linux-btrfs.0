Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:53975 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbaDMQ7I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Apr 2014 12:59:08 -0400
Date: Sun, 13 Apr 2014 09:59:07 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Duncan <1i5t5.duncan@cox.net>
Cc: Josef Bacik <jbacik@fb.com>
Subject: Re: what does your btrfsck look like?
Message-ID: <20140413165907.GC7322@merlins.org>
References: <20140407160506.GG10789@merlins.org> <5342CE0C.3070707@fb.com> <20140407185121.GI10222@merlins.org> <5342FD3D.3090905@fb.com> <20140407200002.GL1809@merlins.org> <20140409173842.GT10789@merlins.org> <20140325014956.GG11533@merlins.org> <20140412202542.GW7322@merlins.org> <20140413145700.GY7322@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140413145700.GY7322@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 13, 2014 at 07:57:00AM -0700, Marc MERLIN wrote:
> On Sat, Apr 12, 2014 at 01:25:42PM -0700, Marc MERLIN wrote:
> > (I have a btrfsck running, looks like it may take over an hour, so I'll post
> > that after it's finished)
> 
> I ran out of patience after 18 hours of waiting since it seemed to have not
> progressed after 12 hours (it was still doing stuff, but no more output on
> the screen).
> 
> Let's look at the output:
> 1794407 lines of lines similar to:
> Extent back ref already exists for 2148837945344 parent 0 root 257 
> 
> 61 lines of 
> leaf parent key incorrect 504993210368
> 
> 67 lines of
> bad block 504993210368
> => just curious, what is this one supposed to mean? Is the data checksum
> bad, or something else?

We had a chat about btrfsck running clean in some cases.
Sure enough, it did for me on a filesystem I had just created.

But on existing filesystems I've been using for a while, it never has for me
has per the example above.

I've added some info to:
https://btrfs.wiki.kernel.org/index.php/Btrfsck

Two questions:
1) are others seeing errors like these:
Extent back ref already exists for 2148837945344 parent 0 root 257
leaf parent key incorrect 504993210368
bad block 504993210368

2) do you know how bad each one is, and should they all be picked up by a
scrub? (I'm under the impression that they were not for me)

I'm happy to further update the wiki on btrfsck with info you can
contribute.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
