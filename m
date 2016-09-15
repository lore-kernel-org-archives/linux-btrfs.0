Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:35426 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751754AbcIOSUw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 14:20:52 -0400
Received: by mail-io0-f178.google.com with SMTP id m186so129506ioa.2
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 11:20:51 -0700 (PDT)
Subject: Re: Is stability a joke? (wiki updated)
To: Chris Murphy <lists@colorremedies.com>
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz> <20160912162747.GF16983@twin.jikos.cz>
 <8df2691f-94c1-61de-881f-075682d4a28d@gmail.com>
 <CAJCQCtQUS-8F+pOtQ2VA9=j=-TGV=wOfj+3SnnMvY3HMTzd=9g@mail.gmail.com>
 <1ef8e6db-89a1-6639-cd9a-4e81590456c5@gmail.com>
 <CAJCQCtQq08bOpRbZq90wRLUGD62Rnqwx6vjJOv5hvPVwp=jz0w@mail.gmail.com>
Cc: David Sterba <dsterba@suse.cz>, Waxhead <waxhead@online.no>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <24d64f38-f036-3ae9-71fd-0c626cfbb52c@gmail.com>
Date: Thu, 15 Sep 2016 14:20:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQq08bOpRbZq90wRLUGD62Rnqwx6vjJOv5hvPVwp=jz0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-15 14:01, Chris Murphy wrote:
> On Tue, Sep 13, 2016 at 5:35 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2016-09-12 16:08, Chris Murphy wrote:
>>>
>>> - btrfsck status
>>> e.g. btrfs-progs 4.7.2 still warns against using --repair, and lists
>>> it under dangerous options also;  while that's true, Btrfs can't be
>>> considered stable or recommended by default
>>> e.g. There's still way too many separate repair tools for Btrfs.
>>> Depending on how you count there's at least 4, and more realistically
>>> 8 ways, scattered across multiple commands. This excludes btrfs
>>> check's -E, -r, and -s flags. And it ignores sequence in the success
>>> rate. The permutations are just excessive. It's definitely not easy to
>>> know how to fix a Btrfs volume should things go wrong.
>>
>> I assume you're counting balance and scrub in that, plus check gives 3, what
>> are you considering the 4th?
>
> - Self repair at mount time, similar to other fs's with a journal
> - fsck, similar to other fs's except the output is really unclear
> about what the prognosis is compared to ext4 or xfs
> - mount option usebackuproot/recovery
> - btrfs rescue zero-log
> - btrfs rescue super-recover
> - btrfs rescue chunk-recover
> - scrub
> - balance
>
> check --repair really needed to be fail safe a long time ago, it's
> what everyone's come to expect from fsck's, that they don't make
> things worse; and in particular on Btrfs it seems like its repairs
> should be reversible but the reality is the man page says do not use
> (except under advisement) and that it's dangerous (twice). And a user
> got a broken system in the bug that affects 4.7, 4.7.1, that 4.7.2
> apparently can't fix. So... life is hard, file systems are hard. But
> it's also hard to see how distros can possibly feel comfortable with
> Btrfs by default when the fsck tool is dangerous, even if in theory it
> shouldn't often be necessary.
>
For check specifically, I see four issues:
1. It spits out pretty low-level information about the internals in many 
cases when it returns an error.  xfs_repair does this too, but it's 
needed even less frequently than btrfs check, and it at least uses 
relatively simple jargon by comparison.  I've been using BTRFS for years 
and still can't tell what more than half the error messages check can 
return mean.  In contrast to that, deciphering an error message from 
e2fsck is pretty trivial if you have some basic understanding of VFS 
level filesystem abstractions (stuff like what inodes and dentries are), 
and I never needed to learn low level things about the internals of ext4 
to parse the fsck output (I did anyway, but that's beside the point).

2. We're developing new features without making sure that check can fix 
issues in any associated metadata.  Part of merging a new feature needs 
to be proving that fsck can handle fixing any issues in the metadata for 
that feature short of total data loss or complete corruption.

3. Fsck should be needed only for un-mountable filesystems.  Ideally, we 
should be handling things like Windows does.  Preform slightly better 
checking when reading data, and if we see an error, flag the filesystem 
for expensive repair on the next mount.

4. Btrfs check should know itself if it can fix something or not, and 
that should be reported.  I have an otherwise perfectly fine filesystem 
that throws some (apparently harmless) errors in check, and check can't 
repair them.  Despite this, it gives zero indication that it can't 
repair them, zero indication that it didn't repair them, and doesn't 
even seem to give a non-zero exit status for this filesystem.

As far as the other tools:
- Self-repair at mount time: This isn't a repair tool, if the FS mounts, 
it's not broken, it's just a messy and the kernel is tidying things up.
- btrfsck/btrfs check: I think I covered the issues here well.
- Mount options: These are mostly just for expensive checks during 
mount, and most people should never need them except in very unusual 
circumstances.
- btrfs rescue *: These are all fixes for very specific issues.  They 
should be folded into check with special aliases, and not be separate 
tools.  The first fixes an issue that's pretty much non-existent in any 
modern kernel, and the other two are for very low-level data recovery of 
horribly broken filesystems.
- scrub: This is a very purpose specific tool which is supposed to be 
part of regular maintainence, and only works to fix things as a side 
effect of what it does.
- balance: This is also a relatively purpose specific tool, and again 
only fixes things as a side effect of what it does.

