Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:36480 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbcDFMDC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Apr 2016 08:03:02 -0400
Received: by mail-io0-f181.google.com with SMTP id q128so52990351iof.3
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Apr 2016 05:03:01 -0700 (PDT)
Subject: Re: dstat shows unexpected result for two disk RAID1
To: Nicholas D Steeves <nsteeves@gmail.com>
References: <CAD=QJKi-3PJQViAaRmGoz3_w6RQbRehDL9vXs14+CSHsG3ipTg@mail.gmail.com>
 <CAD=QJKg6xFSFjJdDyD+v0Rd2afeB-ZRRy2SncC1Db5fyT3cf9A@mail.gmail.com>
 <20160310023627.2e915667@natsu> <pan$9dde$acf9ba51$bb837cb8$8c954a04@cox.net>
 <CAD=QJKjkzh4U5Gmp=PJMiR8w3by12BVCDZ+MN2S+Ekk_EksjAg@mail.gmail.com>
 <CAD=QJKi7=R92UP4PKH4UAYH1HUB0Pr8DwO+MsyLNamKryYuZVA@mail.gmail.com>
 <CAJCQCtR60t=XN1vXaRoMA_YBAy=jje6ns9EoUO1wG_+Zk02LZw@mail.gmail.com>
 <CAD=QJKgrBXCXjP4vEzsGtO9oYN7LQ1titFatCYhmLbZea8_W0w@mail.gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5704FACD.9040304@gmail.com>
Date: Wed, 6 Apr 2016 08:02:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=QJKgrBXCXjP4vEzsGtO9oYN7LQ1titFatCYhmLbZea8_W0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-05 23:58, Nicholas D Steeves wrote:
> On 11 March 2016 at 20:20, Chris Murphy <lists@colorremedies.com> wrote:
>> On Fri, Mar 11, 2016 at 5:10 PM, Nicholas D Steeves <nsteeves@gmail.com> wrote:
>>> P.S. Rather than parity, I mean instead of distributing into stripes, do a copy!
>>
>> raid56 by definition are parity based, so I'd say no that's confusing
>> to turn it into something it's not.
>
> I just found the Multiple Device Support diagram.  I'm trying to
> figure out how hard it's going for me to get up to speed, because I've
> only ever casually and informally read about filesystems.  I worry
> that because I didn't study filesystem design in school, and because
> everything I worked on was in C++...well, the level of sophistication
> and design might be beyond what I can learn.  What do you think?  Can
> you recommend any books on file system design that will provide what
> is necessary to understand btrfs?
While I can't personally recommend any books on filesystem design, I can 
give some more general advice:
1. Make sure you have at least a basic understanding of how things work 
at a high level from the user perspective.  It's a lot easier to 
understand the low-level stuff if you know how it all ends up fitting 
together.  Back when I started looking at the internals of BTRFS I was 
pretty lost myself.  I still am to a certain extent when it comes to the 
kernel code (most of my background is in Python, Lua, or Bourne Shell, 
not C, and I don't normally deal with data structures at such a low 
level), but as I've used it more on my systems, a lot of stuff that 
seemed cryptic at first is making a lot more sense.
2. Keep in mind that there are a number of things in BTRFS that have no 
equivalent in other filesystems, or are not typical filesystem design 
topics.  The multi-device support for example is pretty much 
non-existent as a filesystem design topic because it's traditionally 
handled by lower levels like LVM.
3. The Linux VFS layer is worth taking a look at, as it handles the 
translation between the low-level ABI provided by each filesystem and 
the user-level API.  Most of the stuff that BTRFS provides through it is 
rather consistent with the user level API, but understanding what 
translation goes on there can be helpful to understanding some of the 
higher-level internals in BTRFS.
