Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:48416 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932453AbaJUQ0d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 12:26:33 -0400
Received: from 65-183-131-85-dhcp.burlingtontelecom.net ([65.183.131.85]:60812 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XgcGT-000mXn-9g
	for linux-btrfs@vger.kernel.org; Tue, 21 Oct 2014 10:26:30 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: downgrade from kernel 3.17 to 3.10
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <51E5B5F2-16FE-4A96-948C-9C0D3020972B@colorremedies.com>
Date: Tue, 21 Oct 2014 12:26:27 -0400
Message-Id: <46E892E7-BC01-4CC3-8ED5-A8B636AE9BC4@colorremedies.com>
References: <CAMo7R_e9=wdGhEm9P+DZgXrKQ+qrKqdELzwwi-OMTCp6Mk8aTg@mail.gmail.com> <pan$e55c6$e7985780$d6580cb2$76eb6d4@cox.net> <CAMo7R_egQMGXs4nJBPkp86QkF9owpUhAh6P_Vn65wN84J7B95w@mail.gmail.com> <544679BE.9080901@pobox.com> <CAMo7R_eZo=s1Rfw6H095c9vR0Nq3NuEaNMJjRD+DF2G-cVVs=Q@mail.gmail.com> <51E5B5F2-16FE-4A96-948C-9C0D3020972B@colorremedies.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 21, 2014, at 12:19 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> On Oct 21, 2014, at 11:34 AM, Cristian Falcas <cristi.falcas@gmail.com> wrote:
> 
>> I will start investigating how can we build our own rpms from the 3.16
>> sources. Until then we are stuck with the ones from the official repos
>> or elrepo. Which means 3.10 is the latest for el6. We used this until
>> now and seems we where lucky enough to not hit anything bad.
>> 
>> We upgraded to 3.17 because we use ceph on the machine with openstack
>> and on the ceph site they recommended >3.14. And because we need
>> writable snapshots, we are forced to use btrfs under ceph.
> 
> Hmm, well you could use a Fedora kernel, at least it's approximately the same family. The 3.14.22 kernel RPMs are in koji. Scroll down for x86_64. Chances are you only need kernel-3.14.22-100.fc19.x86_64.rpm.
> 
> http://koji.fedoraproject.org/koji/buildinfo?buildID=585577

And 3.16.6 is here:
http://koji.fedoraproject.org/koji/buildinfo?buildID=585583

I guess I'm wondering why elrepo offers 3.10 and 3.17 yet nothing in between? Huge gap.

Chris Murphy