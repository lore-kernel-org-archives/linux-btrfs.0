Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:35647 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbcBCVRH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Feb 2016 16:17:07 -0500
Received: by mail-ig0-f170.google.com with SMTP id hb3so21449536igb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Feb 2016 13:17:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56B0A881.5080403@gmail.com>
References: <56AFB598.2020307@gmail.com>
	<20160201202112.GB8313@carfax.org.uk>
	<56B0A881.5080403@gmail.com>
Date: Wed, 3 Feb 2016 14:17:06 -0700
Message-ID: <CAJCQCtQ_c1-ck6=_XasvDVwEepXQjB7V4jfxJ9Fe_pPmExtG=A@mail.gmail.com>
Subject: Re: Question about a specific error.
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 2, 2016 at 6:00 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-02-01 15:21, Hugo Mills wrote:
>>
>> On Mon, Feb 01, 2016 at 02:44:24PM -0500, Austin S. Hemmelgarn wrote:
>>>
>>> In the process of trying to debug issues I'm having on one of my
>>> systems with a new kernel version, I decided to do a dry run check on
>>> the root filesystem.  'btrfs check' returned a bunch of lines like:
>>>
>>> root 257 inode XXXXXX errors 2000, link count wrong
>>>          unresolved ref dir YYYYY index 53 namelen 3 name LOG filetype 0
>>> errors 3, no dir item, no dir index
>>>
>>> I got about 20 messages like this with varying values for everything
>>> except the filetype and error counts.  Based on what I can tell, these
>>> look like orphaned inodex, but I'm not certain.
>>> Is it safe to tell BTRFS to try and fix these errors?
>>
>>
>>     Yes, those are errors I'd expect btrfs check --repair to handle
>> properly.
>>
> OK, it looks like things were fixed safely, but I'm not 100% certain that it
> fixed things the way it should have.  All of the files it reported got moved
> to /lost+found (which makes me think it thought they were orphaned items),
> but none of the files themselves showed any issues in regular usage (they
> were all perfectly visible beforehand in the regular directory structure,
> and there were no errors accessing them). On top of that, it pulled out two
> different versions of each one, one from more than a year ago, and one
> current version.  I think btrfs check may have gotten either confused or
> over-zealous and just decided it needed to pull out the current, perfectly
> fine versions of the files as well.

The problems look different. You're reporting errors 2000. I'm seeing
errors 2001. I'm not sure what the distinction is; but in my case,
cancelling btrfs check and just rerunning it gives different results.
https://bugzilla.kernel.org/show_bug.cgi?id=111841

-- 
Chris Murphy
