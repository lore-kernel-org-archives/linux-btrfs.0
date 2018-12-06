Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66B82C04EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 07:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3120520878
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 07:40:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3120520878
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=pobox.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728964AbeLFHkq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 02:40:46 -0500
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:35598 "EHLO
        resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728294AbeLFHkq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 02:40:46 -0500
Received: from resomta-po-15v.sys.comcast.net ([96.114.154.239])
        by resqmta-po-09v.sys.comcast.net with ESMTP
        id UoH7gEVJjVFMTUoH7g2PDP; Thu, 06 Dec 2018 07:40:45 +0000
Received: from touchy.whiterc.com ([IPv6:2601:601:1400:69b4:35fb:69c0:6cd9:337d])
        by resomta-po-15v.sys.comcast.net with ESMTPSA
        id UoH5giZiNS0fxUoH6gud6k; Thu, 06 Dec 2018 07:40:44 +0000
Subject: Re: [PATCH 00/10] btrfs: Support for DAX devices
To:     Jeff Mahoney <jeffm@suse.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-btrfs@vger.kernel.org
References: <20181205122835.19290-1-rgoldwyn@suse.de>
 <6a5b4bb8-896f-14c8-fc71-71b7122dd836@suse.com>
From:   Robert White <rwhite@pobox.com>
Message-ID: <27107fd9-a8c8-9b3a-6d9f-3f020523f4ea@pobox.com>
Date:   Thu, 6 Dec 2018 07:40:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <6a5b4bb8-896f-14c8-fc71-71b7122dd836@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfHTaKKwmAdBQEIkTLoIH//OqZuB6gXxO2APM0RfEYj04e78nexHUD/moe4lAtIb6V0XBr+bSi3rVsIlpd4qIqTeOMT5Fqcb3MXEwjHYnbGFUX3odzZJj
 8sUHjP1e+Neoe6qCKgzklWjuS22hNbs/aIiSBoV8LcDbdfdat1ZkclzvDi9bn5DiYEo48VYgvTaz+FdsVTXM5jKV699OcwHJ8G8WNlqzMOLxMeemQhBqlbAM
 6BWOkz7gkrI7Mvrb70HP8TpbW3j/Sa8RQE6Q5h6T+pbo8DzIDMp6FtGAF0BuI/cu
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 12/5/18 9:37 PM, Jeff Mahoney wrote:
> The high level idea that Jan Kara and I came up with in our conversation 
> at Labs conf is pretty expensive.  We'd need to set a flag that pauses 
> new page faults, set the WP bit on affected ranges, do the snapshot, 
> commit, clear the flag, and wake up the waiting threads.  Neither of us 
> had any concrete idea of how well that would perform and it still 
> depends on finding a good way to resolve all open mmap ranges on a 
> subvolume.  Perhaps using the address_space->private_list anchored on 
> each root would work.

This is a potentially wild idea, so "grain of salt" and all that. I may 
misuse the exact wording.

So the essential problem of DAX is basically the opposite of 
data-deduplication. Instead of merging two duplicate data regions, you 
want to mark regions as at-risk while keeping the original content 
intact if there are snapshots in conflict.

So suppose you _require_ data checksums and data mode of "dup" or mirror 
or one of the other fault tolerant layouts.

By definition any block that gets written with content that it didn't 
have before will now have a bad checksum.

If the inode is flagged for direct IO that's an indication that the 
block has been updated.

At this point you really just need to do the opposite of deduplication, 
as in find/recover the original contents and assign/leave assigned those 
to the old/other snapshots, then compute the new checksum on the 
"original block" and assign it to the active subvolume.

So when a region is mapped for direct IO, and it's refcount is greater 
than one, and you get to a sync or close event, you "recover" the old 
contents into a new location and assign those to "all the other users". 
Now that original storage region has only one user, so on sync or close 
you fix its checksums on the cheap.

Instead of the new data being a small rock sitting over a large rug to 
make a lump, the new data is like a rock being slid under the rug to 
make a lump.

So the first write to an extent creates a burdensome copy to retain the 
old contents, but second and subsequent writes to the same extent only 
have the cost of an _eventual_ checksum of the original block list.

Maybe If the data isn't already duplicated then the write mapping or the 
DAX open or the setting of the S_DUP flag could force the file into an 
extent block that _is_ duplicated.

The mental leap required is that the new blocks don't need to belong to 
the new state being created. The new blocks can be associated to the 
snapshots since data copy is idempotent.

The side note is that it only ever matters if the usage count is greater 
than one, so at worst taking a snapshot, which is already a _little_ 
racy anyway, would/could trigger a semi-lightweight copy of any S_DAX files:

If S_DAX :
   If checksum invalid :
     copy data as-is and checksum, store in snapshot
   else : look for duplicate checksum
     if duplicate found :
       assign that extent to the snapshot
     else :
       If file opened for writing and has any mmaps for write :
         copy extent and assign to new snapshot.
       else :
         increment usage count and assign current block to snapshot

Anyway, I only know enough of the internals to be dangerous.

Since the real goal of mmap is speed during actual update, this idea is 
basically about amortizing the copy costs into the task of maintaining 
the snapshots instead of leaving them in the immediate hands of the 
time-critical updater.

The flush, unmmap, or close by the user, or a system-wide sync event, 
are also good points to expense the bookeeping time.
