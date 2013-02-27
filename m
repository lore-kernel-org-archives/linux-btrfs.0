Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:39631 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab3B0K2H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 05:28:07 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs crash when low on memory.
Date: Wed, 27 Feb 2013 11:28:05 +0100
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130227052247.GA20213@redhat.com> (sfid-20130227_093819_089601_169F45B6)
In-Reply-To: <20130227052247.GA20213@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302271128.05815.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 27. Februar 2013 schrieb Dave Jones:
> Something I've yet to repeat managed to leak a whole bunch of memory
> while I was travelling, and locked up my workstation.
> 
> When I got home, this was the last thing printed out before it locked up
> (it did make it into the logs thankfully) after a bunch of instances of
> the oom-killers handywork.
> 
> 
> 
> SLUB: Unable to allocate memory on node -1 (gfp=0x50)
>   cache: btrfs_extent_state, object size: 176, buffer size: 504, default
> order: 1, min order: 0 node 0: slabs: 49, objs: 640, free: 0
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/extent_io.c:748!

Thank you for reporting this Dave.

I have lockups due to memory pressure conditions on my ThinkPad T520 as well 
when playing Planeshift for some time. (AFAIR since I switched my home 
directory to BTRFS (/ was BTRFS before), but I am not sure about this.) 
Planeshift goes from 2 GB to about 4 GB RSS and then the machine usually 
starts to swap to SSD. 

I did not get around to report this yet. The machine is basically locked (at 
least for long periods of times like minutes). I intend to collect some 
photos and upload them somewhere, cause I do not see anything in logs after 
reboot.

I think this happens *before* real OOM conditions are met (i.e. all of swap 
is being used up as well).

In backtraces btrfs related stuff appears.

Expected results of cause: System continues swapping and if OOM conditions 
are met calls the OOM killer (which might try to get rid of running 
Planeshift client).

Current workaround: Develop a good feeling on when to better restart the PS 
client. :)

So for now just a heads up that I have seen similar issues. (But I think my 
backtraces might have been different, difficult to say since some of it 
scrolls by quite quickly.)

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
