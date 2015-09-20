Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:59495 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbbITBbm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Sep 2015 21:31:42 -0400
Subject: Re: BTRFS as image store for KVM?
To: Gert Menke <gert@menke.ac>, linux-btrfs@vger.kernel.org
References: <55F88ECC.1040604@menke.ac>
From: Jim Salter <jim@jrs-s.net>
Message-ID: <55FE0B42.50300@jrs-s.net>
Date: Sat, 19 Sep 2015 21:26:26 -0400
MIME-Version: 1.0
In-Reply-To: <55F88ECC.1040604@menke.ac>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I can't recommend btrfs+KVM, and I speak from experience.

Performance will be fantastic... except when it's completely abysmal.  
When I tried it, I also ended up with a completely borked (btrfs-raid1) 
filesystem that would only mount read-only and read at hideously reduced 
speeds after about a year of usage in a small office environment.  Did 
*not* make me happy.

ZFS, by contrast, works like absolute gangbusters for KVM image 
storage.  Just create a dataset, drop a .qcow2 file in it, and off to 
the races.  I don't recommend messing about with zvols, it's a PITA and 
isn't necessary.

HTH.



On 09/15/2015 05:34 PM, Gert Menke wrote:
> Hi everybody,
>
> first off, I'm not 100% sure if this is the right place to ask, so if 
> it's not, I apologize and I'd appreciate a pointer in the right 
> direction.
>
> I want to build a virtualization server to replace my current home 
> server. I'm thinking about a Debian system with libvirt/KVM. The 
> system will have one or two SSDs and five harddisks with some kind of 
> software RAID5 for storage. I'd like to have a filesystem with data 
> checksums, so BTRFS seems like the right way to go. However, I read 
> that BTRFS does not perform well as storage for KVM disk images.
> (See here: http://www.linux-kvm.org/page/Tuning_KVM )
>
> Is this still true?
>
> I would appreciate any comments and/or tips you might have on this topic.
>
> Is anyone using BTRFS as an image store? Are there any special 
> settings I should be aware of to make it work well?
>
> Thanks,
> Gert
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

