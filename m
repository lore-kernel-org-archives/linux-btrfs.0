Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23331 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2JaNcJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 09:32:09 -0400
Message-ID: <50912846.6020503@oracle.com>
Date: Wed, 31 Oct 2012 21:31:50 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: David Sterba <dave@jikos.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: make snapshot-aware defrag as a mount option
References: <1351333721-3220-1-git-send-email-bo.li.liu@oracle.com> <1351333721-3220-2-git-send-email-bo.li.liu@oracle.com> <20121030233146.GB3102@twin.jikos.cz> <5090721E.2090806@oracle.com> <20121031004426.GF3102@twin.jikos.cz>
In-Reply-To: <20121031004426.GF3102@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/31/2012 08:44 AM, David Sterba wrote:
> On Wed, Oct 31, 2012 at 08:34:38AM +0800, Liu Bo wrote:
>> Besides 'btrfs fi defrag', mounting with autodefrag may also do the same thing.
> 
> Ok, autodefrag, good point. Then I suggest to make the snapshot-aware a
> mode of autodefrag, not a separate option (because it would make no
> sense other than an alias for "autodefrag=snapshotaware")
> 

Hmm, you might be right.

But I have to say 'snapshot-aware defrag' is kind of trade-off.

1. The good case:
Say a file is full of fragments and make a snapshot based on file's root

        fs root, snapshot
       /        |        \
      /         |         \
| - - | ... | - - - | ... | - - - |
   p1           p2            p3

then we do a snapshot-aware defrag, it will be

fs root      snapshot
   \          /
    \        /
| - - - - - - - - |
 a whole new extent

We achieve the goal!


2. The bad case:
Say we have a file with an whole extent and a snapshot on it at the very first:

fs root      snapshot
   \          /
    \        /
| - - - - - - - - |

then, we write into part of the file, with COW it will be:

         
| - - || - - - || - - - |  ...  | - - - |
   p1      p2       p3            p2_new

(file in snapshot -> p1 + p2 + p3)
(file in fs root -> p1 + p2_new + p3)

then, we do a snapshot-aware defrag, it will be

| - - || - - - || - - - |  ...  | - - - |
   p1      p2      p3            p2_new

                  ||
                  VV

| - - |           | - - - |  ...            ... | - - | - - - | - - - |
   p1                 p3                             new extent

(file in snapshot -> p1 + p3 + middle of new extent)
(file in fs root -> new extent)

So we're making file in snapshot worse than before, although we get a good one for file in fs root.


thanks,
liubo

> 
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

