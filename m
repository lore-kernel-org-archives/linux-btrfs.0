Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab3HRDuz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Aug 2013 23:50:55 -0400
Message-ID: <5210449B.7000302@redhat.com>
Date: Sat, 17 Aug 2013 22:50:51 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Tom Gundersen <teg@jklm.no>
CC: Chris Mason <chris.mason@fusionio.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Question: btrfs-progs releases?
References: <pan$926b0$b4061d31$38c7ab48$19af94f0@cox.net> <20130817115901.17880.38963@localhost.localdomain> <CAG-2HqWDqjS2Er8FvwwgTkfMjoouwvjQeipHy_+ia7iTTfT==w@mail.gmail.com>
In-Reply-To: <CAG-2HqWDqjS2Er8FvwwgTkfMjoouwvjQeipHy_+ia7iTTfT==w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/17/13 10:25 PM, Tom Gundersen wrote:
> On Sat, Aug 17, 2013 at 7:59 PM, Chris Mason <chris.mason@fusionio.com> wrote:
>> The problem with the progs release is I keep finding more things I want
>> to add.  My local git tree has about a dozen commits that I feel are
>> important enough for v1.0.  I just have to cut it, the distros and
>> others are completely correct in asking for an official release.
> 
> I know this feeling too well.
> 
> In order to just "get something out", it might make sense to just do
> some time-based releases every now and again (and maybe call them 0.X,
> rather than 1.0 until you are happy). Even the occasional (maybe after
> each kernel release) git tag (without actually creating tarballs etc)
> would be very helpful, as at least we would have a common reference
> point for bug reports and similar (and after all, numbers are cheap
> ;-)).
> 
> From your point of view, having frequent releases will also (I
> suppose) be helpful as it will make sure your users/testers are using
> the most recent version (at least in Arch, whatever you tag we will
> ship within a few days) and hence you won't have to ask them to
> rebuild from git to make sure the bug hasn't already been fixed.
> 
>> In terms of the quality of the commits, I only put things into the
>> master branch of the git tree that I have fully confidence in.
> 
> Thanks for the info Chris, this is useful to know. I'll keep pushing
> git snapshots then (but as I said, tags would be better).

>From my perspective, I don't want to push git snapshots; I'll fix one bug
and add another.

We desperately need btrfs-progs stabilization and release.

-Eric
