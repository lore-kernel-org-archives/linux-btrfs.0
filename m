Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37289 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbeH1OYg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 10:24:36 -0400
Date: Tue, 28 Aug 2018 19:33:33 +0900
From: Naohiro Aota <naota@elisp.net>
To: dsterba@suse.cz
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>
Subject: Re: [RFC PATCH 00/17] btrfs zoned block device support
Message-ID: <20180828103333.uuywsztisyirwgir@zazie>
References: <20180809180450.5091-1-naota@elisp.net>
 <20180813184251.GC24025@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180813184251.GC24025@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for your review!

On Mon, Aug 13, 2018 at 08:42:52PM +0200, David Sterba wrote:
> On Fri, Aug 10, 2018 at 03:04:33AM +0900, Naohiro Aota wrote:
> > This series adds zoned block device support to btrfs.
> 
> Yay, thanks!
> 
> As this a RFC, I'll give you some. The code looks ok for what it claims
> to do, I'll skip style and unimportant implementation details for now as
> there are bigger questions.
> 
> The zoned devices bring some constraints so not all filesystem features
> cannot be expected to work, so this rules out any form of in-place
> updates like NODATACOW.
> 
> Then there's list of 'how will zoned device work with feature X'?

Here is the current HMZONED status list based on https://btrfs.wiki.kernel.org/index.php/Status

Performance
Trim       | OK
Autodefrag | OK
Defrag     | OK
fallocate  | Disabled. cannot reserve region in sequential zones
direct IO  | Disabled. falling back to buffered IO

Compression | OK

Reliability
Auto-repair    | not working. need to rewrite the corrupted extent
Scrub          | not working. need to rewrite the corrupted extent
Scrub + RAID56 | not working (RAID56)
nodatacow      | should be disabled. (noticed it's not disabled now)
Device replace | disabled for now (need to handle write pointer issues, WIP patch)
Degraded mount | OK

Block group profile
Single   | OK
DUP      | OK
RAID0    | OK
RAID1    | OK
RAID10   | OK
RAID56   | Disabled for now. need to avoid partial parity write.
Mixed BG | OK

Administration | OK

Misc
Free space tree | Disabled. not necessary for sequential allocator
no-holes        | OK
skinny-metadata | OK
extended-refs   | OK

> You disable fallocate and DIO. I haven't looked closer at the fallocate
> case, but DIO could work in the sense that open() will open the file but
> any write will fallback to buffered writes. This is implemented so it
> would need to be wired together.

Actually, it's working like that. When check_direct_IO() returns
-EINVAL, btrfs_direct_IO() still returns 0. As a result, the callers
fall back to buffered IO.

I will reword the commit subject and log to reflect the actual
behavior. Also I will relax the condition to disable only direct write
IOs.

> Mixed device types are not allowed, and I tend to agree with that,
> though this could work in principle.  Just that the chunk allocator
> would have to be aware of the device types and tweaked to allocate from
> the same group. The btrfs code is not ready for that in terms of the
> allocator capabilities and configuration options.

Yes it will work if the allocator is improved to notice device type,
zone type and zone size.

> Device replace is disabled, but the changlog suggests there's a way to
> make it work, so it's a matter of implementation. And this should be
> implemented at the time of merge.

I have a WIP patch to support device replace. But it fails after
device replacing due to write pointer mismatch. I'm debugging the
code, so the following version may enable the feature.

> RAID5/6 + zoned support is highly desired and lack of it could be
> considered a NAK for the whole series. The drive sizes are expected to
> be several terabytes, that sounds be too risky to lack the redundancy
> options (RAID1 is not sufficient here).
> 
> The changelog does not explain why this does not or cannot work, so I
> cannot reason about that or possibly suggest workarounds or solutions.
> But I think it should work in principle.
> 
> As this is first post and RFC I don't expect that everything is
> implemented, but at least the known missing points should be documented.
> You've implemented lots of the low-level zoned support and extent
> allocation, so even if the raid56 might be difficult, it should be the
> smaller part.

I was leaving RAID56 for the future, since I'm not get used to raid56
code and the its write path (raid56_parity_write) seems to be
separated from the other's (submit_stripe_bio).

I quick checked if RAID5 is working on current HMZONED patch. But even
with simple sequential workload using dd, it made IO failures because
partial parity writes introduced overwrite IOs, which violate the
sequential write rule. At a quick glance at the raid56 code, I'm
currently not sure how we can avoid partial parity write while
dispatching necessary IOs on transaction commit.

Regards,
Naohiro
