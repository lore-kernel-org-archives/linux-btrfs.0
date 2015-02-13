Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55569 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbbBMTLB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Feb 2015 14:11:01 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YMLdh-0005pw-TY
	for linux-btrfs@vger.kernel.org; Fri, 13 Feb 2015 20:10:57 +0100
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Feb 2015 20:10:57 +0100
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Feb 2015 20:10:57 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs performance, sudden drop to 0 IOPs
Date: Fri, 13 Feb 2015 19:26:41 +0100
Message-ID: <18s1rb-cmv.ln1@hurikhan77.spdns.de>
References: <CABdHLQ7QPjUbzqNdzCfR0QxC-0coYs0dofuFvsROYXy-M9u4ig@mail.gmail.com> <pan$321bc$90037b7$6ca4e371$e54e1a3b@cox.net> <CABdHLQ6La7BO-TJ3cYEx_NnOUhAYJ69uv3tGnVRYsWkiUrqCsQ@mail.gmail.com> <pan$9532$65b1220e$320184ed$94bcf659@cox.net> <62ntqb-o2r.ln1@hurikhan77.spdns.de> <54DC9AB9.7030505@gmail.com> <gacvqb-mpa.ln1@hurikhan77.spdns.de> <CABdHLQ7=Xr5BV+adP00w6_vgnmQhx_eH2BzK6ALK3FzBXhsaFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

P. Remek <p.remek1@googlemail.com> schrieb:

>> Yes, it was implemented for the purpose of allowing an application to
>> implement its own caching - probably for the sole purpose of doing it
>> "better" or more efficient. But it simply does not work out that well, at
>> least with COW fs. The original idea "performance" is more or less eaten
>> away in a COW scenario - or worse. And that in turn is why Linus said
>> O_DIRECT is broken and should go away, use cache hinting instead.
> 
> Linus is saying to use things like madvise but the fact is that in
> reality people are using O_DIRECT instead of it, so it is important to
> get it right.

Yeah, quite true - apparently... But as you already found, the O_DIRECT 
implementation of btrfs is probably not the culprit.

> The case which I am interested is KVM. Virtual machine
> disk file is opened with O_DIRECT so that when Virtual machine is
> doing IO, it is not cached twice - first time on guest operating
> system level, and second time on hypervisor host operating system
> level. With O_DIRECT it is only cached in guest.

In VirtualBox I enabled host-side caching on purpose and instead lowered the 
RAM. I don't know if VirtualBox does something like memory ballooning, but 
usually I'd expect ballooning to push cache out of RAM - so host-side 
caching may make sense.

I never measured it but it feels a bit snappier to work inside the 
VirtualBox machine. Of course, recommendation depends on if you are using 
ballooning and VM density.

In VirtualBox, this setting probably just turns off O_DIRECT. And my VM 
images are set to nocow.

-- 
Replies to list only preferred.

