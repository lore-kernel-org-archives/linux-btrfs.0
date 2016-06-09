Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34387 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbcFITTr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jun 2016 15:19:47 -0400
Received: by mail-oi0-f65.google.com with SMTP id r4so9266698oib.1
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jun 2016 12:19:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160606150031.GI24492@carfax.org.uk>
References: <1464918615-6458-1-git-send-email-andrew@asquaredlabs.com>
 <20160606091729.GX29147@twin.jikos.cz> <CA+jCKRUtDqwVppYSv3jCODZW+U-AV5v1421x4TRHjp36aftw8A@mail.gmail.com>
 <20160606150031.GI24492@carfax.org.uk>
From: Andrew Armenia <andrew@asquaredlabs.com>
Date: Thu, 9 Jun 2016 15:19:07 -0400
Message-ID: <CA+jCKRV2-Lo22W+KT=OfZ+Go_y86rptR5xjCbL2Qyda0Kj717w@mail.gmail.com>
Subject: Re: [PATCH] btrfs: chunk_width_limit mount option
To: Hugo Mills <hugo@carfax.org.uk>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 6, 2016 at 11:00 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Mon, Jun 06, 2016 at 09:43:19AM -0400, Andrew Armenia wrote:
>> On Mon, Jun 6, 2016 at 5:17 AM, David Sterba <dsterba@suse.cz> wrote:
>> > On Thu, Jun 02, 2016 at 09:50:15PM -0400, Andrew Armenia wrote:
>> >> This patch adds mount option 'chunk_width_limit=X', which when set forces
>> >> the chunk allocator to use only up to X devices when allocating a chunk.
>> >> This may help reduce the seek penalties seen in filesystems with large
>> >> numbers of devices.
>> >
>> > There is a use for such limit but passing it as a mount is not the right
>> > way to do it. Changing the value requires remount, different raid levels
>> > might need different values, it's not persistent etc.
>>
>> Thanks for the feedback. I agree that it's less than an ideal way to
>> do it. I guess I was a bit quick to release proof-of-concept code.
>> I'll try to do some more work on the configuration side of things and
>> resubmit.
>
>    Last time something like this came up in discussion, the consensus
> was to put the configuration in xattrs in the btrfs namespace. There
> should be one with a name to indicate "global" configuration, applied
> to the top of subvol 5. If the feature allows configuration on a
> per-subvol or per-object basis, then there should also be a name for
> the relevant xattr (also in the btrfs namespace) that can be created
> on each object as required.
>
>    Hugo.
>
> --
> Hugo Mills             | Klytus, I'm bored. What plaything can you offer me
> hugo@... carfax.org.uk | today?
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |                      Ming the Merciless, Flash Gordon

OK, since I'm new here I'll throw my thoughts out before writing and
submitting another patch. I wouldn't want to have to read the xattrs
from disk every time a chunk needs to be allocated. That means the
allocator configuration will need to be cached in the fs_info
structure. My current line of thinking is to create a
btrfs_allocator_config structure containing all of the allocator
parameters - for now a user-set devs_max for each RAID level. I'd add
a couple ioctls to allow the userspace tools to get and set these
parameters. The "set" ioctl would also persist this configuration to
one or more xattrs on the root of subvol 5 per Hugo's suggestion.

I'm still a bit hung up on the proper way to read the config back at
mount time. Patching the mount routines doesn't seem like a good way
to do it. Perhaps just doing it at the first invocation of
__btrfs_alloc_chunk is best? Any other thoughts?

-Andrew
