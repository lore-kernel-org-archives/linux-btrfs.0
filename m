Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f67.google.com ([209.85.192.67]:35718 "EHLO
	mail-qg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737AbcCRP3N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 11:29:13 -0400
Received: by mail-qg0-f67.google.com with SMTP id 51so1052141qgy.2
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 08:29:12 -0700 (PDT)
Subject: Re: [PATCH v2] btrfs-progs: add stat check in open_ctree_fs_info
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1458309822-5550-1-git-send-email-ahferroin7@gmail.com>
 <20160318151714.GA21722@twin.jikos.cz>
Cc: clm@fb.com
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56EC1EBC.6010008@gmail.com>
Date: Fri, 18 Mar 2016 11:29:00 -0400
MIME-Version: 1.0
In-Reply-To: <20160318151714.GA21722@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-18 11:17, David Sterba wrote:
> On Fri, Mar 18, 2016 at 10:03:42AM -0400, Austin S. Hemmelgarn wrote:
>> This has been both build and runtime tested on an x86-64 system with
>> glibc.  It has been build but not runtime tested with uClibc on x86-64
>> and ARMv7.  It has not been tested on Android or with musl, although it
>> should work there also.
>
> I would not expect any difference among the other arches and libc, it's
> using a common interface.
The only one I would think might possibly be an issue is Android (bionic 
has some serious oddities in some places), but I don't think it's likely 
that they deviated from POSIX semantics here (I would check the 
documentation, but I don't have it readily available).  Mention of the 
arch was more for the sake of completeness in specifying what I tested 
than anything else.
>
>> There are other tools that have similarly poor error behavior when
>> called incorrectly (btrfs rescue immediately comes to mind), but they
>> don't use open_ctree_fs_info, so this doesn't affect them.  I may do
>> followup patches to fix those too if I have the time.
>
> Yeah, it would be good to fix all.
I should have time to take a closer look at btrfs rescue early next 
week, so I may have a patch for that relatively soon.  I can't readily 
think of anything else that might be doing similar things without 
calling open_ctree_fs_info though, so it may be a bit longer before I 
actually post a patch (ideally, I'd like to get all the other things 
that parse unmounted filesystems at the same time).
