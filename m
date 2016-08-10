Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:39716 "EHLO
	cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752411AbcHJVcT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Aug 2016 17:32:19 -0400
Subject: Re: memory overflow or undeflow in free space tree / space_info?
To: Josef Bacik <jbacik@fb.com>, Omar Sandoval <osandov@osandov.com>
References: <229a1d13-32f1-cd4c-975f-2db6796eb6c7@profihost.ag>
 <20160729191153.GA28505@vader> <20160729191459.GB28505@vader>
 <40a46d57-fe32-e745-9897-8f5c6ca2b33e@fb.com>
 <6c131d33-af2e-61ae-00ed-f65ac35607c2@profihost.ag>
 <265340a5-12d5-f8a0-974f-b0de69b3b243@profihost.ag>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <5353cc8a-4cdc-165f-2c86-f810148661f1@profihost.ag>
Date: Wed, 10 Aug 2016 23:31:15 +0200
MIME-Version: 1.0
In-Reply-To: <265340a5-12d5-f8a0-974f-b0de69b3b243@profihost.ag>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

same again with chris next branch:

ERROR: error during balancing '/vmbackup/': No space left on device
There may be more info in syslog - try dmesg | tail
Dumping filters: flags 0x7, state 0x0, force is off
  DATA (flags 0x2): balancing, usage=5
  METADATA (flags 0x2): balancing, usage=5
  SYSTEM (flags 0x2): balancing, usage=5

dmesg:
[203784.411189] BTRFS info (device dm-0): 114 enospc errors during balance

uname -r 4.7.0-rc6-29043-g8b8b08c

Greets,
Stefan

Am 08.08.2016 um 08:17 schrieb Stefan Priebe - Profihost AG:
> Am 04.08.2016 um 13:40 schrieb Stefan Priebe - Profihost AG:
>> Am 29.07.2016 um 23:03 schrieb Josef Bacik:
>>> On 07/29/2016 03:14 PM, Omar Sandoval wrote:
>>>> On Fri, Jul 29, 2016 at 12:11:53PM -0700, Omar Sandoval wrote:
>>>>> On Fri, Jul 29, 2016 at 08:40:26PM +0200, Stefan Priebe - Profihost
>>>>> AG wrote:
>>>>>> Dear list,
>>>>>>
>>>>>> i'm seeing btrfs no space messages frequently on big filesystems (>
>>>>>> 30TB).
>>>>>>
>>>>>> In all cases i'm getting a trace like this one a space_info warning.
>>>>>> (since commit [1]). Could someone please be so kind and help me
>>>>>> debugging / fixing this bug? I'm using space_cache=v2 on all those
>>>>>> systems.
>>>>>
>>>>> Hm, so I think this indicates a bug in space accounting somewhere else
>>>>> rather than the free space tree itself. I haven't debugged one of these
>>>>> issues before, I'll see if I can reproduce it. Cc'ing Josef, too.
>>>>
>>>> I should've asked, what sort of filesystem activity triggers this?
>>>>
>>>
>>> Chris just fixed this I think, try his next branch from his git tree
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
>>
>> Thanks now running a 4.4 with those patches backported. If that still
>> shows an error i will try that vanilla tree.
> 
> OK this didn't work. I'll start / try using the linux-btrfs next branch
> and look if this helps.
> 
> Greets,
> Stefan
> 
>>
>> Thanks!
>>
>> Stefan
>>
>>> and see if it still happens.  Thanks,
>>>
>>> Josef
