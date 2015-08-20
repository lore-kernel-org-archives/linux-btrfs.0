Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:33913 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbbHTSHZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 14:07:25 -0400
Received: by qgeg42 with SMTP id g42so33099539qge.1
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2015 11:07:24 -0700 (PDT)
From: Tyler Bletsch <tyler.bletsch@gmail.com>
Subject: Re: Btrfs is amazing! (a lack-of-bug report)
To: Donald Pearson <donaldwhpearson@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
References: <55D1567B.3030809@gmail.com> <55D1CA1E.1060103@gmail.com>
 <55D23397.6090404@gmail.com> <55D31A3C.3080208@gmail.com>
 <55D4BBBB.9000008@gmail.com> <55D5BF80.500@gmail.com>
 <55D5C1BC.2080507@gmail.com>
 <CAC=t97CFWn-mVzyhL4vj6SEMZBgLwFYfszfu55neG=_+NQta=w@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <55D61759.4060005@gmail.com>
Date: Thu, 20 Aug 2015 14:07:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAC=t97CFWn-mVzyhL4vj6SEMZBgLwFYfszfu55neG=_+NQta=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(Resending to list as plaintext (*correctly* this time))

I see. I'll probably make the backup array a raid10 then.

If/when I do see a disk failure on the raid5, are there any specific 
steps it would be helpful for me to take to capture the state so you 
folks can have a useful bug report?

I plan to run the latest stock kernel from the mainline kernel ppa on 
Ubuntu, with btrfs-progs coming from the git.

- Tyler

On 8/20/2015 8:16 AM, Donald Pearson wrote:
>
> Raid56 works fine until you have a drive with problems which really 
> means it doesn't work because you only use parity to handle the case 
> of a drive with problems.
>
> Maintenance procedures such as scrubs are also a magnitude of order 
> slower than the other raid profiles.
>
> I would use the raid10 profile on at least one of your pools.
>
> On Aug 20, 2015 7:03 AM, "Austin S Hemmelgarn" <ahferroin7@gmail.com 
> <mailto:ahferroin7@gmail.com>> wrote:
>
>     On 2015-08-20 07:52, Austin S Hemmelgarn wrote:
>
>         On 2015-08-19 13:24, Tyler Bletsch wrote:
>
>             Thanks.  I'd consider raid6, but since I'll be backing up
>             to a second
>             btrfs raid5 array, I think I have sufficient redundancy, since
>             equivalent to raid 5+1 on paper. I'm doing that rather
>             than something
>             like raid10 in a single box because I want the redundancy
>             of a second
>             physical server so I can failover in the event of a
>             system-level
>             component failure.
>
>             (And of course, "failover" means "continue being able to
>             watch TV shows
>             and stuff")
>
>             A question about what you said -- when you say people have
>             hit bugs in
>             the raid56 code, which flavor do these bugs tend to be?
>             Are they
>             "minding my own business and suddenly it falls over" bugs
>             or "I tried to
>             do something weird with btrfs and it screwed up" bugs?
>
>         More along the lines of 'I tried to do something that works
>         fine with
>         the other raid profiles and it kind of messed up the
>         filesystem'.  In
>         general, you should be safe as long as you are using at least
>         Linux 4.0
>         and the most recent version of btrfs-progs.  It's been a while
>         since I
>         saw any raid56 related bugs that caused actual data loss. If
>         you are
>         using this on SSD's though, I would wait, there are known
>         issues with
>         DISCARD/TRIM not working correctly on btrfs right now (nothing
>         involving
>         data loss, just problems with it not properly trimming free
>         space and
>         therefore causing issues with wear-leveling), and it looks
>         like the fix
>         won't be in 4.2 as of right now.
>
>
>     On second thought, you might want to wait until 4.3, I just saw
>     this thread:
>     http://thread.gmane.org/gmane.comp.file-systems.btrfs/47321/focus=47325
>

