Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:34512 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbcBDMU1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Feb 2016 07:20:27 -0500
Received: by mail-io0-f174.google.com with SMTP id 9so90826864iom.1
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Feb 2016 04:20:27 -0800 (PST)
Subject: Re: Question about a specific error.
To: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <56AFB598.2020307@gmail.com> <20160201202112.GB8313@carfax.org.uk>
 <56B0A881.5080403@gmail.com>
 <CAJCQCtQ_c1-ck6=_XasvDVwEepXQjB7V4jfxJ9Fe_pPmExtG=A@mail.gmail.com>
 <20160203212740.GC30635@carfax.org.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56B341AE.1010601@gmail.com>
Date: Thu, 4 Feb 2016 07:18:54 -0500
MIME-Version: 1.0
In-Reply-To: <20160203212740.GC30635@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-03 16:27, Hugo Mills wrote:
> On Wed, Feb 03, 2016 at 02:17:06PM -0700, Chris Murphy wrote:
>> On Tue, Feb 2, 2016 at 6:00 AM, Austin S. Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>> On 2016-02-01 15:21, Hugo Mills wrote:
>>>>
>>>> On Mon, Feb 01, 2016 at 02:44:24PM -0500, Austin S. Hemmelgarn wrote:
>>>>>
>>>>> In the process of trying to debug issues I'm having on one of my
>>>>> systems with a new kernel version, I decided to do a dry run check on
>>>>> the root filesystem.  'btrfs check' returned a bunch of lines like:
>>>>>
>>>>> root 257 inode XXXXXX errors 2000, link count wrong
>>>>>           unresolved ref dir YYYYY index 53 namelen 3 name LOG filetype 0
>>>>> errors 3, no dir item, no dir index
>>>>>
>>>>> I got about 20 messages like this with varying values for everything
>>>>> except the filetype and error counts.  Based on what I can tell, these
>>>>> look like orphaned inodex, but I'm not certain.
>>>>> Is it safe to tell BTRFS to try and fix these errors?
>>>>
>>>>
>>>>      Yes, those are errors I'd expect btrfs check --repair to handle
>>>> properly.
>>>>
>>> OK, it looks like things were fixed safely, but I'm not 100% certain that it
>>> fixed things the way it should have.  All of the files it reported got moved
>>> to /lost+found (which makes me think it thought they were orphaned items),
>>> but none of the files themselves showed any issues in regular usage (they
>>> were all perfectly visible beforehand in the regular directory structure,
>>> and there were no errors accessing them). On top of that, it pulled out two
>>> different versions of each one, one from more than a year ago, and one
>>> current version.  I think btrfs check may have gotten either confused or
>>> over-zealous and just decided it needed to pull out the current, perfectly
>>> fine versions of the files as well.
>>
>> The problems look different. You're reporting errors 2000. I'm seeing
>> errors 2001. I'm not sure what the distinction is; but in my case,
>> cancelling btrfs check and just rerunning it gives different results.
>> https://bugzilla.kernel.org/show_bug.cgi?id=111841
>
>     The "errors" field in the output of btrfs check is a hex
> (strange... I thought it was octal...) bit-field indicating the set of
> error types encountered. They're defined in #defines at the top of
> cmds-check.c. 2000 is I_ERR_SOME_CSUM_MISSING, 1 is I_ERR_NO_INODE_ITEM.

OK, that makes some sense.  Although I'm still curious why a file with 
some of the checksums missing would:
1) Not have any apparent errors during regular usage (no errors in dmesg 
or syslog, and access worked just fine) when it's not set to nodatasum 
or nocow.
2) Be reported in a manner that seems to imply it's orphaned (which I 
would expect for Chris' case, as I_ERR_NO_INODE_ITEM sounds like a type 
of orphan to me).
