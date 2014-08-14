Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48851 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753758AbaHNSRu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 14:17:50 -0400
Message-ID: <53ECFD4A.9030704@fb.com>
Date: Thu, 14 Aug 2014 14:17:46 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs
References: <53ECF8FB.1070106@fb.com> <CA+55aFwx1uPDngB5cASUQsfazt0Ry6yxd5aUuSRMawozj26vVA@mail.gmail.com>
In-Reply-To: <CA+55aFwx1uPDngB5cASUQsfazt0Ry6yxd5aUuSRMawozj26vVA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/14/2014 02:10 PM, Linus Torvalds wrote:
> On Thu, Aug 14, 2014 at 11:59 AM, Chris Mason <clm@fb.com> wrote:
>> Hi Linus,
>>
>> Please pull my for-linus branch:
> 
> Yeah, I think this will be for the next merge window.
> 
> This clearly got rebased today. At the end of the merge window. After
> I told people that I was traveling, and asked people to send big
> things early.
> 

[ resend with full cc ]

Hi Linus,

This did get rebased this week (two days ago), but I've been running it
through tests for some time.  It was delayed by my own schedule problems
(vacation and others) that made it very difficult for me to have it
ready early in the window.

Aside from a small number of cleanup patches, these are all fixes.  I'm
happy to pull out the cleanups and focus on the fixes.

-chris
