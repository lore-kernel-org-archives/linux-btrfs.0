Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:56225 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaJUPe7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 11:34:59 -0400
Received: by mail-lb0-f171.google.com with SMTP id z12so1231444lbi.16
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 08:34:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <544679BE.9080901@pobox.com>
References: <CAMo7R_e9=wdGhEm9P+DZgXrKQ+qrKqdELzwwi-OMTCp6Mk8aTg@mail.gmail.com>
 <pan$e55c6$e7985780$d6580cb2$76eb6d4@cox.net> <CAMo7R_egQMGXs4nJBPkp86QkF9owpUhAh6P_Vn65wN84J7B95w@mail.gmail.com>
 <544679BE.9080901@pobox.com>
From: Cristian Falcas <cristi.falcas@gmail.com>
Date: Tue, 21 Oct 2014 18:34:34 +0300
Message-ID: <CAMo7R_eZo=s1Rfw6H095c9vR0Nq3NuEaNMJjRD+DF2G-cVVs=Q@mail.gmail.com>
Subject: Re: downgrade from kernel 3.17 to 3.10
To: Robert White <rwhite@pobox.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I will start investigating how can we build our own rpms from the 3.16
sources. Until then we are stuck with the ones from the official repos
or elrepo. Which means 3.10 is the latest for el6. We used this until
now and seems we where lucky enough to not hit anything bad.

We upgraded to 3.17 because we use ceph on the machine with openstack
and on the ceph site they recommended >3.14. And because we need
writable snapshots, we are forced to use btrfs under ceph.

Thank you all for your advice.




On Tue, Oct 21, 2014 at 6:20 PM, Robert White <rwhite@pobox.com> wrote:
> On 10/21/2014 06:18 AM, Cristian Falcas wrote:
>>
>> Thank you for your answer.
>>
>> I will reformat the disk with a 3.10 kernel in the meantime, because I
>> don't have any rpms for 3.16 now.
>
>
> More concisely: Don't use 3.10 BTRFS for data you value. There is a
> non-trivial chance that the problems you observed are/were due to "bad
> things" on the disk written there by 3.10.
>
> There is no value to recreating your file systems under 3.10 as the same
> thing is likely to go bad again when you get out of the dungeon.
>
> What are your RPM options? What about just getting the sources from
> kernel.org and compiling your won 3.16.5?
>
> Seriously, 3.10.... just... no...
>
> 8-)
>
