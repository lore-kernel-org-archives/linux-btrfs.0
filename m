Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f44.google.com ([209.85.213.44]:35969 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbbCUAIm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 20:08:42 -0400
Received: by yhjf44 with SMTP id f44so46896240yhj.3
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2015 17:08:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <550C7655.10907@libero.it>
References: <CAJCQCtRFUMAeyjLxADKLVaHA0wqQBY_tbyZoJJ6Hze7AeeTa_w@mail.gmail.com>
	<550C7655.10907@libero.it>
Date: Fri, 20 Mar 2015 18:08:41 -0600
Message-ID: <CAJCQCtRFnCm=ug4Byd=A+mT+CrUPrrGW_T+SzYaD+mLc6wypOA@mail.gmail.com>
Subject: Re: [systemd-devel] systemd and nested Btrfs subvolumes
From: Chris Murphy <lists@colorremedies.com>
To: kreijack@inwind.it
Cc: systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 20, 2015 at 1:34 PM, Goffredo Baroncelli <kreijack@libero.it> wrote:
> Hi Chris,
> On 2015-03-20 02:27, Chris Murphy wrote:
>> Short version:
>> ------------------
>>   Instead of machinectl clone using btrfs snapshots, or even needing
>> to store things in a var/lib/machines Btrfs subvolume, does it meet
>> the requirements for Btrfs optimization to do this with cp -a
>> --reflink instead?
>>
>> Why? Nested subvolumes are confusing. And nested subvolumes are
>> excluded from snapshots. Subvolume B inside of Subvolume A, will not
>> be snapshot or rolled back, if I snapshot Subvolume A and subsequently
>> rollback to the snapshot of A.
>
> Personally I prefer this kind of behavior. Each subvolumes may have its life cycle so a rollback on a volume doesn't means that the other also need it.

Sure but now it's missing if you do a rollback, or if you mount any
different root tree, so immediately special handling is needed.

If machines is a subvolume at the top level, it can always be mounted
at /var/lib/machines regardless of which root is used.

I also think this is more consistent with
http://0pointer.net/blog/revisiting-how-we-put-together-linux-systems.html
specifically the section "What We Propose" when it comes to the
location and naming convention for Btrfs subvolumes.


> I think that a "cp --reflink" is slower than a snapshot, because all the metadata still have to be copied. Another disadvantage, is that a snapshot and its parent could be "easily" [3] compared; the same would be not true if a cp --reflink is used.

If it's containers themselves being snapshot, then /var/lib/machines
isn't really what needs to be snapshot, it's the individual containers
themselves that belong in a subvolume so they can be individually
snapshot/cloned.

-- 
Chris Murphy
