Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:33925 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbbLNUVe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 15:21:34 -0500
Received: by mail-ig0-f178.google.com with SMTP id m11so6942121igk.1
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 12:21:33 -0800 (PST)
Subject: Re: [PATCH v3] btrfs: Introduce new mount option to disable tree log
 replay
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <1449714846-18174-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151214173200.GO4227@twin.jikos.cz> <566F016D.8050403@gmail.com>
 <1450120614.6629.34.camel@scientia.net> <566F199A.5030704@gmail.com>
 <1450122242.6629.45.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <566F24A6.8040605@gmail.com>
Date: Mon, 14 Dec 2015 15:20:54 -0500
MIME-Version: 1.0
In-Reply-To: <1450122242.6629.45.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-14 14:44, Christoph Anton Mitterer wrote:
> On Mon, 2015-12-14 at 14:33 -0500, Austin S. Hemmelgarn wrote:
>> The traditional reasoning was that read-only meant that users
>> couldn't
>> change anything
> Where I'd however count the atime changes to.
> The atimes wouldn't change magically, but only because the user stared
> some program, configured some daemon, etc. ... which reads/writes/etc.
> the file.
But reading the file is allowed, which is where this starts to get 
ambiguous.  Reading a file updates the atime (and in fact, this is the 
way that most stuff that uses them cares about them), but even a ro 
mount allows reading the file.  The traditional meaning of ro on UNIX 
was (AFAIUI) that directory structure couldn't change, new files 
couldn't be created, existing files couldn't be deleted, flags on the 
inodes couldn't be changed, and file data couldn't be changed.  TBH, I'm 
not even certain that atime updates on ro filesystems was even an 
intentional thing in the first place, it really sounds to me like the 
type of thing that somebody forgot to put in a permissions check for, 
and then people thought it was a feature.
>
>
>> , not that the actual data on disk wouldn't change.
>> That, and there's been some really brain-dead software over the years
>> that depended on atimes being right (now, the only remaining software
>> I
>> know of that even uses them at all is Mutt).
> Wasn't tmpwatcher anoterh candidate?
Most such software can use it, but doesn't depend on it.  TBH, many 
people these days run /tmp (and even /var/tmp) on an in memory 
filesystem, so atime updates aren't as much of an issue there.  Also, 
even with noatime, I'm pretty sure the VFS updates the atime every time 
the mtime changes (because not doing so would be somewhat stupid, and 
you're writing the inode anyway), which technically means that stuff 
could work around this by opening the file, truncating it to the size it 
already is, and then closing it.
>
>
>> This should be 'Nothing on the backing device may change as a result
>> of
>> the FS', nitpicking I know, but we should be specific so that we
>> hopefully avoid ending up in the same situation again.
> Of course, you're right! :-)
>
> (especially when btrfs should ever be formalised in a standards
> document, this should read like:
>> hard-ro: Nothing on the backing device may change as a result of the
>> FS, however, e.g. maleware, may directly destroy the data on the
>> blockdevice ;-)
>
>
> Chris.
>

