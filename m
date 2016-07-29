Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:22469 "EHLO
	cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993AbcG2Tkz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 15:40:55 -0400
Subject: Re: memory overflow or undeflow in free space tree / space_info?
To: Omar Sandoval <osandov@osandov.com>
References: <229a1d13-32f1-cd4c-975f-2db6796eb6c7@profihost.ag>
 <20160729191153.GA28505@vader> <20160729191459.GB28505@vader>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <5d62de30-24a8-c73f-d164-b61cb86691bd@profihost.ag>
Date: Fri, 29 Jul 2016 21:40:52 +0200
MIME-Version: 1.0
In-Reply-To: <20160729191459.GB28505@vader>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Am 29.07.2016 um 21:14 schrieb Omar Sandoval:
> On Fri, Jul 29, 2016 at 12:11:53PM -0700, Omar Sandoval wrote:
>> On Fri, Jul 29, 2016 at 08:40:26PM +0200, Stefan Priebe - Profihost AG wrote:
>>> Dear list,
>>>
>>> i'm seeing btrfs no space messages frequently on big filesystems (> 30TB).
>>>
>>> In all cases i'm getting a trace like this one a space_info warning.
>>> (since commit [1]). Could someone please be so kind and help me
>>> debugging / fixing this bug? I'm using space_cache=v2 on all those systems.
>>
>> Hm, so I think this indicates a bug in space accounting somewhere else
>> rather than the free space tree itself. I haven't debugged one of these
>> issues before, I'll see if I can reproduce it. Cc'ing Josef, too.
> 
> I should've asked, what sort of filesystem activity triggers this?
> 

Sure.


The workload on the FS is basically:
- Write file1 (50GB - 500GB)

- cp --reflink=always file1 to file2
- apply changes to file2 (100MB - 5GB)

- cp --reflink=always file2 to file3
- apply changes to file3 (100MB - 5GB)

...

- delete file1

- cp --reflink=always file3 to file4
- apply changes to file4 (100MB - 5GB)

- delete file2

...

And this for around 300 files a day. btrfs balance with dusage=5 and
musage=5 is running daily sometimes in parallel to the workload above.

Greets,
Stefan
