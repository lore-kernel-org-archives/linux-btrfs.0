Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:53049 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaDMO5C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Apr 2014 10:57:02 -0400
Date: Sun, 13 Apr 2014 07:57:00 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Subject: Re: very slow btrfs filesystem: any data needed before I wipe it?
Message-ID: <20140413145700.GY7322@merlins.org>
References: <20140407160506.GG10789@merlins.org> <5342CE0C.3070707@fb.com> <20140407185121.GI10222@merlins.org> <5342FD3D.3090905@fb.com> <20140407200002.GL1809@merlins.org> <20140409173842.GT10789@merlins.org> <20140325014956.GG11533@merlins.org> <20140412202542.GW7322@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140412202542.GW7322@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 12, 2014 at 01:25:42PM -0700, Marc MERLIN wrote:
> (I have a btrfsck running, looks like it may take over an hour, so I'll post
> that after it's finished)

I ran out of patience after 18 hours of waiting since it seemed to have not
progressed after 12 hours (it was still doing stuff, but no more output on
the screen).

Let's look at the output:
1794407 lines of lines similar to:
Extent back ref already exists for 2148837945344 parent 0 root 257 

61 lines of 
leaf parent key incorrect 504993210368

67 lines of
bad block 504993210368
=> just curious, what is this one supposed to mean? Is the data checksum
bad, or something else?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
