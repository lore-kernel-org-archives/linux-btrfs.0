Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:45961 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbaEaUUN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 May 2014 16:20:13 -0400
Received: by mail-we0-f182.google.com with SMTP id t60so3480996wes.13
        for <linux-btrfs@vger.kernel.org>; Sat, 31 May 2014 13:20:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87bnvxasiu.fsf@maru2.md5i.com>
References: <87bnvxasiu.fsf@maru2.md5i.com>
Date: Sat, 31 May 2014 23:20:11 +0300
Message-ID: <CAOcd+r3bNPbfTpVeHCcCBqcpFDQ2Y70qZL7PzyHt=xcZqb8Zqw@mail.gmail.com>
Subject: Re: snapshot send with parent question
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: mwd@md5i.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Michael,
btrfs-send doesn't really know or care how did you manage to get from
a to c. It is able to compare any two RO subvolumes (not necessarily
related by snapshot operations), and produce a stream of commands that
transfer a-content into c-content.

Send assumes that at a receive side, you have a snapshot identical to
"a". Then receive side locates the a-snapshot (by a "received_UUID"
field) and creates a RW snapshot out of it. This snapshot would be
identical to "c", after applying the stream of commands. Then receive
side applies the stream of commands (in strict order), and at the end
sets the RW snapshot to be RO. At this point, this snapshot should be
identical to c.

The stream of commands most probably will not be identical to
operations that you did in order to get from "a" into "c". But it will
transfer "a"-content into "c"-content (leave alone possible bugs),
which is what's important.

Of course, if a and c are related via snapshot operations, then
btrfs-send will be much more efficient, in terms that it will be able
to skip entire btrfs subtrees (look at "btrfs_compare_trees"), thus
avoiding many additional comparisons that some other tool like rsync
would have done.

Thanks,
Alex.



On Sun, Apr 20, 2014 at 1:00 AM, Michael Welsh Duggan <mwd@md5i.com> wrote:
> Assume the following scenario:
> There exists a read-only snapshot called a.
> A read-write snapshot called b is created from a, and is then modified.
> A read-only snapshot of b is created, called c.
> A btrfs send is done for c, with a marked as its parent.
>
> Will the send data only contain the differences between a and c?  My
> experiments seem to indicate no, but I have no confidence that I am not
> doing something else correctly.
>
> Also, when a btrfs receive gets a stream containing the differences
> between a (parent) and c, does it only look at the relative pathname
> differences between a and c in order to determine the matching parent on
> the receiving side?
>
> --
> Michael Welsh Duggan
> (md5i@md5i.com)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
