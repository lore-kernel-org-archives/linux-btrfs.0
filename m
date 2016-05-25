Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:33406 "EHLO
	mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbcEYLsL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 07:48:11 -0400
Received: by mail-it0-f65.google.com with SMTP id l63so5075791ita.0
        for <linux-btrfs@vger.kernel.org>; Wed, 25 May 2016 04:48:10 -0700 (PDT)
Subject: Re: Copy on write of unmodified data
To: Hugo Mills <hugo@carfax.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-btrfs@vger.kernel.org
References: <ae68a6ae-8184-88b8-05e5-8bb369d906b5@zytor.com>
 <20160525092958.GH16712@carfax.org.uk>
 <dc2b10c2-24b4-0686-f382-c53cfce7a9df@zytor.com>
 <20160525110711.GJ16712@carfax.org.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <a0457fdb-345a-f8ae-5bcf-d9985c75312b@gmail.com>
Date: Wed, 25 May 2016 07:32:34 -0400
MIME-Version: 1.0
In-Reply-To: <20160525110711.GJ16712@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-25 07:07, Hugo Mills wrote:
> On Wed, May 25, 2016 at 04:00:00AM -0700, H. Peter Anvin wrote:
>> On 05/25/16 02:29, Hugo Mills wrote:
>>> On Wed, May 25, 2016 at 01:58:15AM -0700, H. Peter Anvin wrote:
>>>> Hi,
>>>>
>>>> I'm looking at using a btrfs with snapshots to implement a generational
>>>> backup capacity.  However, doing it the naïve way would have the side
>>>> effect that for a file that has been partially modified, after
>>>> snapshotting the file would be written with *mostly* the same data.  How
>>>> does btrfs' COW algorithm deal with that?  If necessary I might want to
>>>> write some smarter user space utilities for this.
>>>
>>>    Sounds like it might be a job for one of the dedup tools
>>> (deupremove, bedup), or, if you're writing your own, the safe
>>> deduplication ioctl which underlies those tools.
>>>
>>
>> I guess I would prefer if data wasn't first duplicated and then
>> deduplicated if possible.  It sounds like I ought to write a "smart
>> copy-overwrite" tool for this.
>
>    I _think_ rsync --in-place may help here. IIRC, it'll only
> overwrite the sections of files that have changed, rather than write
> and replace the whole file. (I may be wrong about that, though. I
> haven't tested it at that level).
This is absolutely correct, and I actually use rsync instead of cp on a 
regular basis partly for this reason.
