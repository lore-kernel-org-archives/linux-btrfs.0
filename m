Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:46920 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720AbaBYRvD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 12:51:03 -0500
Message-ID: <530CD898.6090401@jrs-s.net>
Date: Tue, 25 Feb 2014 12:53:28 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: VM nocow, should VM software set +C by default?
References: <A2EE3F12-97D9-46CD-8360-ACCFF71F149B@colorremedies.com> <530C5F65.6020607@internetionals.nl> <4C05BCCD-ED77-4D8D-B9C7-47CB6D1B4ACC@colorremedies.com>
In-Reply-To: <4C05BCCD-ED77-4D8D-B9C7-47CB6D1B4ACC@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Put me in on Team Justin on this particular issue.  I get and grant that 
in some use cases you might get pathological behavior out of DB or VM 
binaries which aren't set NODATACOW, but in my own use - including 
several near-terabyte-size VM images being used by ten+ people all day 
long for their primary work - I haven't personally observed any 
pathological behavior, and I *don't* have NODATACOW set.

I would prefer to have the benefits of COW being turned on unless and 
until I categorically NEED to disable it in order to avoid pathological 
performance issues.

Also note that ZFS doesn't even *have* a NODATACOW option, is generally 
less performant than btrfs in general in my experience, and yet I've 
been running 100-ish VMs - not toys, actual 
depended-on-by-lots-of-people-daily-workhorses - in .qcow2-on-ZFS format 
for years now without issue.

IME, IMO, the potential performance problems with COW and db/vm do 
/exist/ but they're way, WAY overstated, and unlikely to rear their 
heads at all in the majority of use-cases.


On 02/25/2014 12:44 PM, Chris Murphy wrote:
> On Feb 25, 2014, at 2:16 AM, Justin Ossevoort <justin@internetionals.nl> wrote:
>
>> I think in principle: No.
>>
>> It is something that should be documented as advise in the VM software documentation. But things like storage management is the domain of the distribution or systems administrator.
> No, that's a recipe for users having a chaotic experience. Either the VM managing application needs to set +C on image files, or the file system needs to be optimized for this use case. Consider the Gnome Boxes user. They're not in a good position to do this themselves, and each distro doing this causes fragmented experience. It's better if the application developer (Gnome Boxes, VMM) or possibly libvirt to set +C on VM images; or as a general purpose file system for it to be optimized for this use case.
>
> Either way it leaves the end user out of what amounts to esoteric configuration.
>

