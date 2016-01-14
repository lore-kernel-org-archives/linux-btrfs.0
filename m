Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:37358 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbcANTmA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 14:42:00 -0500
Received: by mail-ig0-f169.google.com with SMTP id h5so134256739igh.0
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Jan 2016 11:41:59 -0800 (PST)
Subject: Re: Query about proposed dedup patches and behaviours
To: bo.li.liu@oracle.com
References: <CAGkb5vfzcOmj1Js=pBR6=-Uad7jY2bJy5ht3F-m-1TEOBjwCYA@mail.gmail.com>
 <5697D0E9.3080007@gmail.com> <20160114192647.GB24567@localhost.localdomain>
Cc: James Hogarth <james.hogarth@gmail.com>, linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5697F9E7.1020004@gmail.com>
Date: Thu, 14 Jan 2016 14:41:27 -0500
MIME-Version: 1.0
In-Reply-To: <20160114192647.GB24567@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-14 14:26, Liu Bo wrote:
> On Thu, Jan 14, 2016 at 11:46:33AM -0500, Austin S. Hemmelgarn wrote:
>> On 2016-01-14 11:13, James Hogarth wrote:
>>> Hi,
>>>
>>> The duperemove[1] tool is in the process for packaging for Fedora at
>>> present but I was wondering what future this may have with the 4.5
>>> dedup patches being proposed.
>>>
>>> WIll the btrfs command have the ability to out-of-line dedup files
>>> similar to duperemove (thus negating the need for it) or will this
>>> only control in-line dedup with a tool like duperemove still being
>>> required for periodic only (or restricted path) dedup?
>> Unless I'm horribly misreading the code, the regular btrfs-progs will not be
>> adding the ability to do out-of-band deduplication.  It may at some point
>> add a shortcut for the required ioctl to be used from scripts, but that's
>> probably unlikely.
>>>
>>> To avoid memory usage bloat if the btrfs command can order dedup  of X
>>> files on the path correctly can it be passed a path to carry the hash
>>> map in some form (similar to how dupeemeove can use sqlite for this)
>>> or is this another use case for the external tool?
>> This shouldn't be an issue for in-line deduplication, as that's handled in
>> the kernel.
>>>
>>> Finally what's the present situation with regards to defragmentation
>>> and deduplication? Is it safe to turn on autodefrag now when using
>>> snapshots and duperemove? What should the behaviour be with the
>>> proposed 4.5 dedup patches if both inline dedup and autodefrag are
>>> enabled as mount options?
>> I'm not entirely certain how deduplication would interact with any form of
>> defragmentation.  I'm pretty certain though that autodefrag does properly
>> handle snapshots, such that the reflinks aren't broken, and it's the
>> original copy that gets any shared extents defragmented into it.
>
> If it refers to snapshot-aware defrag, it's been disabled, so now btrfs
> will not maintain reflinks between snapshots.
>
I was under the impression that autodefrag had been done separately from 
the snapshot-aware manually triggered defrag, and that it's always been 
snapshot aware.

