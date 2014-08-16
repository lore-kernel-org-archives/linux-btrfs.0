Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50544 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751516AbaHPQqr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Aug 2014 12:46:47 -0400
Message-ID: <53EF8AF2.2070605@fb.com>
Date: Sat, 16 Aug 2014 12:46:42 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Smaller btrfs pull
References: <53EE42A9.7000607@fb.com> <CA+55aFz-aSbmLoZv=CGY1bXpQ1zE935-FjTLMZF5=5hteyf9kg@mail.gmail.com>
In-Reply-To: <CA+55aFz-aSbmLoZv=CGY1bXpQ1zE935-FjTLMZF5=5hteyf9kg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/16/2014 11:11 AM, Linus Torvalds wrote:
> On Fri, Aug 15, 2014 at 11:26 AM, Chris Mason <clm@fb.com> wrote:
>>
>> I've been running xfstests with these against your current git
>> overnight, but I'm queueing up longer tests as well.  I understand
>> you may want to wait until rc2, but either way I'll get a sane queue
>> into my linux-next branch for the rest of the rcs.
> 
> You completely mis-understand.
> 
> If something isn't appropriate for the merge window, then it sure as
> HELL isn't appropriate for later rc's either.
> 
> So I'm not going to pull some "stragglers" later and just pull some
> initial stuff now. That's not how this works.

Hi Linus,

Sorry that I wasn't clear.  I had already pushed 1/2 of the commits off
to the 3.18 merge window.  Of the remaining commits, my plan was to send
the fixes that would qualify for rc2 or rc3 during those rcs.

I was trying to say that I fully expected these patches to be closely
inspected.  I'll bring my white gloves.

-chris
