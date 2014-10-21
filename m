Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35136 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933430AbaJURzl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 13:55:41 -0400
Received: by mail-lb0-f175.google.com with SMTP id u10so1467525lbd.20
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 10:55:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54468BA0.20405@netvision.com.py>
References: <CAMo7R_e9=wdGhEm9P+DZgXrKQ+qrKqdELzwwi-OMTCp6Mk8aTg@mail.gmail.com>
 <pan$e55c6$e7985780$d6580cb2$76eb6d4@cox.net> <CAMo7R_egQMGXs4nJBPkp86QkF9owpUhAh6P_Vn65wN84J7B95w@mail.gmail.com>
 <544679BE.9080901@pobox.com> <CAMo7R_eZo=s1Rfw6H095c9vR0Nq3NuEaNMJjRD+DF2G-cVVs=Q@mail.gmail.com>
 <54468BA0.20405@netvision.com.py>
From: Cristian Falcas <cristi.falcas@gmail.com>
Date: Tue, 21 Oct 2014 20:55:19 +0300
Message-ID: <CAMo7R_fF=bjt6jtSV7aFBVi390hqhf5uAzyMRNAkpWePodLO0Q@mail.gmail.com>
Subject: Re: downgrade from kernel 3.17 to 3.10
To: "Julio E. Gonzalez P." <jegp@netvision.com.py>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm rebuilding now the 3.16.6 version from fedora for el6 (I had to
make some small modification: remove perl-carp dependency and some
compiler flag). And it's for el6, so we have only elrepo with a newer
kernel.

Is it safe to install the kernel without recompiling it first for the
new platform?



On Tue, Oct 21, 2014 at 7:36 PM, Julio E. Gonzalez P.
<jegp@netvision.com.py> wrote:
> When you say "el6" you mean "el7" right? The last kernel for el7 is
> 3.10.xxxxx
> But Redhat lie a little with kernel version numbers. They say you have a
> 3.10 kernel, but I think they backport a lot from newers kernels.
> Probably the btrfs of redhat el7 is not really a btrfs from 3.10, maybe is
> btrfs from 3.12 or 3.14....how knows...  (I want to know better about this
> too...also using btfrs in rhel7)
>
>
>
>
> On 10/21/2014 12:34 PM, Cristian Falcas wrote:
>>
>> I will start investigating how can we build our own rpms from the 3.16
>> sources. Until then we are stuck with the ones from the official repos
>> or elrepo. Which means 3.10 is the latest for el6. We used this until
>> now and seems we where lucky enough to not hit anything bad.
>>
>> We upgraded to 3.17 because we use ceph on the machine with openstack
>> and on the ceph site they recommended >3.14. And because we need
>> writable snapshots, we are forced to use btrfs under ceph.
>>
>> Thank you all for your advice.
>>
>>
>
