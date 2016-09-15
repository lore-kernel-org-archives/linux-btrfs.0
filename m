Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36756 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750794AbcIOSBl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 14:01:41 -0400
Received: by mail-oi0-f54.google.com with SMTP id q188so81056165oia.3
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 11:01:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1ef8e6db-89a1-6639-cd9a-4e81590456c5@gmail.com>
References: <57D51BF9.2010907@online.no> <20160912142714.GE16983@twin.jikos.cz>
 <20160912162747.GF16983@twin.jikos.cz> <8df2691f-94c1-61de-881f-075682d4a28d@gmail.com>
 <CAJCQCtQUS-8F+pOtQ2VA9=j=-TGV=wOfj+3SnnMvY3HMTzd=9g@mail.gmail.com> <1ef8e6db-89a1-6639-cd9a-4e81590456c5@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 15 Sep 2016 12:01:38 -0600
Message-ID: <CAJCQCtQq08bOpRbZq90wRLUGD62Rnqwx6vjJOv5hvPVwp=jz0w@mail.gmail.com>
Subject: Re: Is stability a joke? (wiki updated)
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Waxhead <waxhead@online.no>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 13, 2016 at 5:35 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-09-12 16:08, Chris Murphy wrote:
>>
>> - btrfsck status
>> e.g. btrfs-progs 4.7.2 still warns against using --repair, and lists
>> it under dangerous options also;  while that's true, Btrfs can't be
>> considered stable or recommended by default
>> e.g. There's still way too many separate repair tools for Btrfs.
>> Depending on how you count there's at least 4, and more realistically
>> 8 ways, scattered across multiple commands. This excludes btrfs
>> check's -E, -r, and -s flags. And it ignores sequence in the success
>> rate. The permutations are just excessive. It's definitely not easy to
>> know how to fix a Btrfs volume should things go wrong.
>
> I assume you're counting balance and scrub in that, plus check gives 3, what
> are you considering the 4th?

- Self repair at mount time, similar to other fs's with a journal
- fsck, similar to other fs's except the output is really unclear
about what the prognosis is compared to ext4 or xfs
- mount option usebackuproot/recovery
- btrfs rescue zero-log
- btrfs rescue super-recover
- btrfs rescue chunk-recover
- scrub
- balance

check --repair really needed to be fail safe a long time ago, it's
what everyone's come to expect from fsck's, that they don't make
things worse; and in particular on Btrfs it seems like its repairs
should be reversible but the reality is the man page says do not use
(except under advisement) and that it's dangerous (twice). And a user
got a broken system in the bug that affects 4.7, 4.7.1, that 4.7.2
apparently can't fix. So... life is hard, file systems are hard. But
it's also hard to see how distros can possibly feel comfortable with
Btrfs by default when the fsck tool is dangerous, even if in theory it
shouldn't often be necessary.


-- 
Chris Murphy
