Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:41973 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab3JHP3L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Oct 2013 11:29:11 -0400
Received: by mail-we0-f180.google.com with SMTP id q59so8898534wes.11
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Oct 2013 08:29:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131008022005.GC16461@localhost.localdomain>
References: <CACe732uTQrbVTV_Ov-0U4hLtdx8==2+9uXtzoVxFhteF3rr1ag@mail.gmail.com>
	<20131008022005.GC16461@localhost.localdomain>
Date: Tue, 8 Oct 2013 17:29:10 +0200
Message-ID: <CACe732vdsR-bSi3=wEu3Wd4owp4XSCkt4+7DczfZVEXi=_GZiw@mail.gmail.com>
Subject: Re: kernel BUG at mm/page-writeback.c:2317!
From: Jan Killius <tmpnerd@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef,
your patch fixed the issue.

Greetings,

Jan

On Tue, Oct 8, 2013 at 4:20 AM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Tue, Oct 08, 2013 at 12:36:11AM +0200, Jan Killius wrote:
>> Hello,
>> I'm hitting similar bug with the patch from Lui Bo.
>> But If I revert: 573aecafca1cf7a974231b759197a1aebcf39c2a,
>> Btrfs: actually limit the size of delalloc range) everything works fine.
>>
>> Here are the 2 backtraces from my machines with 3.12-rc4:
>> http://imgur.com/sVkjGK6,mWUtzMV#0
>> http://imgur.com/sVkjGK6,mWUtzMV#1
>>
>> Sorry for the screenshots but It was the only way to capture the backtraces.
>> I get the bug at the end of a 2GB scp transfer almost everytime.
>
> So I thought about it and I came up with this patch but as I was writing out the
> explanation I realized I was wrong in some of my assumptions.  However I'd still
> like you to give it a whirl and see if it fixes the problem and I'll take a
> fresh look at it tomorrow
>
> http://paste.fedoraproject.org/44986/38119874/
>
> Thanks,
>
> Josef
