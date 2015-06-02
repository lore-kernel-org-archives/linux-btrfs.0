Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:36370 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbbFBOCu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jun 2015 10:02:50 -0400
MIME-Version: 1.0
In-Reply-To: <55646D1F.6000506@fb.com>
References: <20150523000905.GA16230@ret.masoncoding.com>
	<CA+5PVA7yA-q3V_KHp-zL+4G_bO9Fp4i0jH_UXdez0r+4D4KqYQ@mail.gmail.com>
	<55646D1F.6000506@fb.com>
Date: Tue, 2 Jun 2015 10:02:49 -0400
Message-ID: <CA+5PVA4b5N-xcnDUd3ECNw5TM7Am+jjyq6nwjG+Wnme+FQWbqQ@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Chris Mason <clm@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 26, 2015 at 8:54 AM, Chris Mason <clm@fb.com> wrote:
> On 05/26/2015 08:33 AM, Josh Boyer wrote:
>> On Fri, May 22, 2015 at 9:14 PM, Chris Mason <clm@fb.com> wrote:
>>> Hi Linus,
>>>
>>> My for-linus-4.1 branch has three more fixes:
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.1
>>>
>>> I fixed up a regression from 4.0 where conversion between different raid
>>> levels would sometimes bail out without converting.
>>>
>>> Filipe tracked down a race where it was possible to double allocate
>>> chunks on the drive.
>>>
>>> Mark has a fix for fiemap.  All three will get bundled off for stable as
>>> well.
>>>
>>> Chris Mason (1) commits (+18/-0):
>>>     Btrfs: fix regression in raid level conversion
>>
>> Shouldn't this be CC'd to stable since it fixes a broken commit in 4.0?
>
> Yes, I'm retesting two of these against 4.0

Did you finish up testing the two commits?  I might have missed it,
but I haven't seen anything being requested to the 4.0.y stable tree
yet.

josh
