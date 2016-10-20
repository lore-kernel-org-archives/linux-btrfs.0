Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f175.google.com ([209.85.213.175]:34332 "EHLO
        mail-yb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933573AbcJTPt2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Oct 2016 11:49:28 -0400
Received: by mail-yb0-f175.google.com with SMTP id f97so22485300ybi.1
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Oct 2016 08:49:28 -0700 (PDT)
Subject: Re: Is it possible to speed up unlink()?
To: Roman Mamedov <rm@romanrm.net>
References: <CAGqmi779inZ8CcXpJ_uX1XXTGS_JrhKNagbL8ms6vA9eVZBFWQ@mail.gmail.com>
 <00101fd7-39e0-903c-5151-f2458259fd62@gmail.com>
 <20161020202635.57c8a72b@natsu>
Cc: Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <63eb8a0b-d664-1907-8ad1-7bec19ff80fa@gmail.com>
Date: Thu, 20 Oct 2016 11:49:20 -0400
MIME-Version: 1.0
In-Reply-To: <20161020202635.57c8a72b@natsu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-10-20 11:26, Roman Mamedov wrote:
> On Thu, 20 Oct 2016 08:09:14 -0400
> "Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:
>
>>> So, it's possible to return unlink() early? or this a bad idea(and why)?
>> I may be completely off about this, but I could have sworn that unlink()
>> returns when enough info is on the disk that both:
>> 1. The file isn't actually visible in the directory.
>> 2. If the system crashes, the filesystem will know to finish the cleanup.
>
> As I understand it there is no fundamental reason why rm of a heavily
> fragmented file couldn't be exactly as fast as deleting a subvolume with
> only that single file in it. Remove the directory reference and instantly
> return success to userspace, continuing to clean up extents in the background.
The tree cleanup is actually a bit easier for a subvolume since it's the 
root of it's own tree.  This in turn means that there is less that 
actually needs to be written for a subvolume with a single file in it to 
be deleted than for the file by itself to be deleted, since the write 
doesn't propagate up quite as many trees.

The thing is though that since the NFS export is set to async mode, the 
unlink should return almost immediately anyway.

The other issue is that the type file in question is a pathological case 
for any COW filesystem, not just BTRFS, and this behavior is pretty well 
understood.  Once you get past about 8G for a VM image on BTRFS, you 
either need to be looking at real block storage (LVM or something 
similar with the image exported using something like iSCSI or NBD), make 
absolutely certain the file is pre-allocated and marked NOCOW, or use a 
split file format.
>
> However for many uses that could be counter-productive, as scripts might
> expect the disk space to be freed up completely after the rm command returns
> (as they might need to start filling up the partition with new data).
'Might' is an understatement, scripts _do_ expect the disk space to free 
up immediately, and this has caused a number of issues with various 
tools on BTRFS.  It's also an issue because just about everything 
expects unlink() to be functionally synchronous (ie, unlink() shouldn't 
have an impact on other operations if it's already returned).
>
> In snapshot deletion there are various commit modes built in for that purpose,
> but I'm not sure if you can easily extend POSIX file deletion to implement
> synchronous and non-synchronous deletion modes.
There isn't.  In theory it could be implemented as a mount option, but 
even that gets risky for the same reason taht implementing it globally 
is potentially problematic.
>
> * Try the 'unlink' program instead of 'rm'; if "just remove the dir entry for
>   now" was implemented anywhere, I'd expect it to be via that.
'rm' just puts a nice UI on the unlink() call, 'unlink' just calls it 
directly, so I severely doubt that it will have any impact.
> * Try doing 'eatmydata rm', but that's more of a crazy idea than anything else,
>   as eatmydata only affects fsyncs, and I don't think rm is necessarily
>   invoking those.
It isn't, so this almost certainly won't help.

