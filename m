Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:36020 "EHLO
	mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbcFJRjR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 13:39:17 -0400
Received: by mail-it0-f41.google.com with SMTP id a5so1308052ita.1
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jun 2016 10:39:16 -0700 (PDT)
Subject: Re: fsck: to repair or not to repair
To: Adam Borowski <kilobyte@angband.pl>
References: <87y47g1esh.fsf@thinkpad.rath.org>
 <87fuslg19q.fsf@vostro.rath.org>
 <ec929c7d-079d-8ea5-87d7-fce0ed1c45b7@gmail.com>
 <87twh1t4xv.fsf@thinkpad.rath.org> <20160610165046.GA18657@angband.pl>
 <271297eb-f557-4b9b-e236-81dd3f70c1be@gmail.com>
 <20160610172203.GB18657@angband.pl>
Cc: Nikolaus Rath <Nikolaus@rath.org>, linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <612e8ab9-833c-3792-a89e-cb4fa02ae84a@gmail.com>
Date: Fri, 10 Jun 2016 13:39:10 -0400
MIME-Version: 1.0
In-Reply-To: <20160610172203.GB18657@angband.pl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-10 13:22, Adam Borowski wrote:
> On Fri, Jun 10, 2016 at 01:12:42PM -0400, Austin S. Hemmelgarn wrote:
>> On 2016-06-10 12:50, Adam Borowski wrote:
>>> And, as of coreutils 8.25, the default is no reflink, with "never" not being
>>> recognized even as a way to avoid an alias.  As far as I remember, this
>>> applies to every past version with support for reflinks too.
>>>
>> Odd, I could have sworn that was an option...
>>
>> And I do know there was talk at least at one point of adding it and
>> switching to reflink=auto by default.
>
> Yes please!
>
> It's hard to come with a good reason for not reflinking when it's possible
> -- the only one I see is if you have a nocow VM and want to slightly improve
> speed at a cost of lots of disk space.  And even then, there's cat a >b for
> that.
There are other arguments, the most common one being not changing user 
visible behavior.  There are (misguided) people who expect copying a 
file to mean you have two distinct copies of that file.

OTOH, it's not too hard to set up a system to do this, you just put:
alias cp='cp --reflink=auto'
into your bashrc (or something similar into whatever other shell you 
use).  I've been doing this since cp added support for it.
>
> And the cost on non-btrfs non-unmerged-xfs is a single syscall per file,
> that's utterly negligible compared to actually copying the data.
Actually, IIRC, it's an ioctl, not a syscall, which can be kind of 
expensive (I don't know how much more expensive, but ioctls are usually 
more expensive than syscalls).

Other things to keep in mind though that may impact this (either way):
1. There are other filesystems that support reflinks (OCFS2 and ZFS come 
immediately to mind).
2. Most of the filesystems that support reflinks are used more in 
enterprise situations, where the bit about not changing user visible 
behavior is a much stronger argument.
3. Even in enterprise situations, reflink capable filesystems are still 
unusual outside of petabyte scale data storage.
4. Last I checked, the most widely used filesystem that supports 
reflinks (ZFS) uses a different ioctl interface for them than most other 
Linux filesystems, which means more checking is needed than just calling 
one ioctl.
