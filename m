Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:60366 "EHLO
	cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757986AbcHDLmV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Aug 2016 07:42:21 -0400
Subject: Re: memory overflow or undeflow in free space tree / space_info?
To: Josef Bacik <jbacik@fb.com>, Omar Sandoval <osandov@osandov.com>
References: <229a1d13-32f1-cd4c-975f-2db6796eb6c7@profihost.ag>
 <20160729191153.GA28505@vader> <20160729191459.GB28505@vader>
 <40a46d57-fe32-e745-9897-8f5c6ca2b33e@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <6c131d33-af2e-61ae-00ed-f65ac35607c2@profihost.ag>
Date: Thu, 4 Aug 2016 13:40:16 +0200
MIME-Version: 1.0
In-Reply-To: <40a46d57-fe32-e745-9897-8f5c6ca2b33e@fb.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 29.07.2016 um 23:03 schrieb Josef Bacik:
> On 07/29/2016 03:14 PM, Omar Sandoval wrote:
>> On Fri, Jul 29, 2016 at 12:11:53PM -0700, Omar Sandoval wrote:
>>> On Fri, Jul 29, 2016 at 08:40:26PM +0200, Stefan Priebe - Profihost
>>> AG wrote:
>>>> Dear list,
>>>>
>>>> i'm seeing btrfs no space messages frequently on big filesystems (>
>>>> 30TB).
>>>>
>>>> In all cases i'm getting a trace like this one a space_info warning.
>>>> (since commit [1]). Could someone please be so kind and help me
>>>> debugging / fixing this bug? I'm using space_cache=v2 on all those
>>>> systems.
>>>
>>> Hm, so I think this indicates a bug in space accounting somewhere else
>>> rather than the free space tree itself. I haven't debugged one of these
>>> issues before, I'll see if I can reproduce it. Cc'ing Josef, too.
>>
>> I should've asked, what sort of filesystem activity triggers this?
>>
> 
> Chris just fixed this I think, try his next branch from his git tree
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git

Thanks now running a 4.4 with those patches backported. If that still
shows an error i will try that vanilla tree.

Thanks!

Stefan

> and see if it still happens.  Thanks,
> 
> Josef
