Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:37332 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753493AbdHNPx6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 11:53:58 -0400
Received: by mail-it0-f52.google.com with SMTP id 76so20029859ith.0
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Aug 2017 08:53:58 -0700 (PDT)
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Graham Cobb <g.btrfs@cobb.uk.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
 <4c094049-f8c8-a0ea-674b-33c6905d744a@gmx.com>
 <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
 <1502496618.6092.6.camel@scientia.net> <20170812074248.GA3352@infradead.org>
 <e560ba2d-ad11-abe6-bb3a-788d7b5a7562@gmx.com>
 <1502713484.3608.1.camel@scientia.net>
 <b0e0e9e4-5b7f-ac84-b05c-8724762b16ea@gmail.com>
 <49ebcfb9-b0c8-0feb-3570-a5b19c3e3b33@cobb.uk.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <53633949-b04b-ec5c-f300-c0b702d22374@gmail.com>
Date: Mon, 14 Aug 2017 11:53:51 -0400
MIME-Version: 1.0
In-Reply-To: <49ebcfb9-b0c8-0feb-3570-a5b19c3e3b33@cobb.uk.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-14 11:13, Graham Cobb wrote:
> On 14/08/17 15:23, Austin S. Hemmelgarn wrote:
>> Assume you have higher level verification.
> 
> But almost no applications do. In real life, the decision
> making/correction process will be manual and labour-intensive (for
> example, running fsck on a virtual disk or restoring a file from backup).
Quite a few applications actually _do_ have some degree of secondary 
verification or protection from a crash.  Go look at almost any database 
software.  It usually will not have checksumming, but it will almost 
always have support for a journal, which is enough to cover the 
particular data loss scenario we're talking about (unexpected unclean 
shutdown).
> 
>> Would you rather not be able
>> to read the data regardless of if it's correct or not, or be able to
>> read it and determine yourself if it's correct or not?
> 
> It must be controllable on a per-file basis, of course. For the tiny
> number of files where the app can both spot the problem and correct it
> (for example if it has a journal) the current behaviour could be used.
In my own experience, the things that use nodatacow fall into one of 4 
categories:
1. Cases where the data is non-critical, and data loss will be 
inconvenient but not fatal.  Systemd journal files are a good example of 
this, as are web browser profiles when you're using profile sync.
2. Cases where the upper level can reasonably be expected to have some 
degree of handling, even if it's not correction.  VM disk images and 
most database applications fall into this category.
3. Cases where data corruption will take out the application anyway. 
Poorly written database software is the primary example of this.
4. Things that shouldn't be using nodatacow because data safety is the 
most important aspect of the system.

The first two cases work perfectly fine with the current behavior and 
are arguably no better off either way.  The third is functionally fine 
with the current behavior provided that the crash doesn't change state 
(which isn't a guarantee), but could theoretically benefit from the 
determinism of knowing the app will die if the data is bad.  The fourth 
is what most people seem to want this for, and don't realize that even 
if this is implemented, they will be no better off on average.
> 
> But, on MY system, I absolutely would **always** select the first option
> (-EIO). I need to know that a potential problem may have occurred and
> will take manual action to decide what to do. Of course, this also needs
> a special utility (as Christoph proposed) to be able to force the read
> (to allow me to examine the data) and to be able to reset the checksum
> (although that is presumably as simple as rewriting the data).
And I and most other sysadmins I know would prefer the opposite with the 
addition of a secondary notification method.  You can still hook the 
notification to stop the application, but you don't have to if you don't 
want to (and in cases 1 and 2 I listed above, you probably don't want to).
> 
> This is what happens normally with any filesystem when a disk block goes
> bad, but with the additional benefit of being able to examine a
> "possibly valid" version of the data block before overwriting it.
> 
>> Looking at this from a different angle: Without background, what would
>> you assume the behavior to be for this?  For most people, the assumption
>> would be that this provides the same degree of data safety that the
>> checksums do when the data is CoW.
> 
> Exactly. The naive expectation is that turning off datacow does not
> prevent the bitrot checking from working. Also, the naive expectation
> (for any filesystem operation) is that if there is any doubt about the
> reliability of the data, the error is reported for the user to deal with.
The problem is that the naive expectation about data safety appears to 
be that adding checksumming support for nodatacow will improve safety, 
which it WILL NOT do.  All it will do is add some reporting that will 
have a 50%+ rate of false positives (there is the very real possibility 
that the unexpected power loss will corrupt the checksum or the data if 
you're on anything but a traditional hard drive).  If you have something 
that you need data safety for and can't be arsed to pay attention to 
whether or not your system had an unclean shutdwon, then you have two 
practical options:
1. Don't use nodatacow.
2. Do some form of higher level verification.
Nothing about that is going to magically change because you suddenly 
have checksums telling you the data might be bad.

Now, you _might_ be better off in a situation where the data got 
corrupted for some other reason (say, a media error for example), but 
even then you should have higher level verification, and it won't 
provide much benefit unless you're using replication or parity in BTRFS.
