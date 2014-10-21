Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aratiri.netvision.com.py ([200.1.203.34]:57005 "EHLO
	aratiri.netvision.com.py" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046AbaJURgK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 13:36:10 -0400
Message-ID: <54468BA0.20405@netvision.com.py>
Date: Tue, 21 Oct 2014 13:36:48 -0300
From: "Julio E. Gonzalez P." <jegp@netvision.com.py>
MIME-Version: 1.0
To: Cristian Falcas <cristi.falcas@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: downgrade from kernel 3.17 to 3.10
References: <CAMo7R_e9=wdGhEm9P+DZgXrKQ+qrKqdELzwwi-OMTCp6Mk8aTg@mail.gmail.com> <pan$e55c6$e7985780$d6580cb2$76eb6d4@cox.net> <CAMo7R_egQMGXs4nJBPkp86QkF9owpUhAh6P_Vn65wN84J7B95w@mail.gmail.com> <544679BE.9080901@pobox.com> <CAMo7R_eZo=s1Rfw6H095c9vR0Nq3NuEaNMJjRD+DF2G-cVVs=Q@mail.gmail.com>
In-Reply-To: <CAMo7R_eZo=s1Rfw6H095c9vR0Nq3NuEaNMJjRD+DF2G-cVVs=Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When you say "el6" you mean "el7" right? The last kernel for el7 is 
3.10.xxxxx
But Redhat lie a little with kernel version numbers. They say you have a 
3.10 kernel, but I think they backport a lot from newers kernels.
Probably the btrfs of redhat el7 is not really a btrfs from 3.10, maybe 
is btrfs from 3.12 or 3.14....how knows...  (I want to know better about 
this too...also using btfrs in rhel7)



On 10/21/2014 12:34 PM, Cristian Falcas wrote:
> I will start investigating how can we build our own rpms from the 3.16
> sources. Until then we are stuck with the ones from the official repos
> or elrepo. Which means 3.10 is the latest for el6. We used this until
> now and seems we where lucky enough to not hit anything bad.
>
> We upgraded to 3.17 because we use ceph on the machine with openstack
> and on the ceph site they recommended >3.14. And because we need
> writable snapshots, we are forced to use btrfs under ceph.
>
> Thank you all for your advice.
>
>

