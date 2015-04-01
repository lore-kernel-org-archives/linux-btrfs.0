Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51810 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbbDAGvo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 02:51:44 -0400
Message-ID: <551B951A.2030606@oracle.com>
Date: Wed, 01 Apr 2015 14:50:02 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Rich Freeman <r-btrfs@thefreemanclan.net>
CC: "G. Richard Bellamy" <rbellamy@pteradigm.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Upgrade to 3.19.2 Kernel fails to boot
References: <CADw2B2Nxr5PPSaVWpQWxg0ZaXYSpOTye_pMU1HbjCHif8q9_LQ@mail.gmail.com>	<550FCD9C.1000706@oracle.com>	<CAGfcS_miW0=6A7a5PAQZcseCbS1KDpTPM7woKTosMjnAB3C3Cw@mail.gmail.com>	<CAGfcS_nmUyBMZyrr_9pzvKxVFMJVfsmPb3DM83aaxCSUTj-2NA@mail.gmail.com>	<551104B9.2010105@oracle.com> <CAGfcS_nc03H7ekvHBjZF7wEp2wFXuCXPA4Ar09mte4-+jOQKUA@mail.gmail.com>
In-Reply-To: <CAGfcS_nc03H7ekvHBjZF7wEp2wFXuCXPA4Ar09mte4-+jOQKUA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Eric found something like this and has a fix with in the email.
Sub: "I think "btrfs: fix leak of path in btrfs_find_item" broke stable 
trees ..."

Anand

On 03/24/2015 06:40 PM, Rich Freeman wrote:
> On Tue, Mar 24, 2015 at 2:31 AM, Anand Jain <Anand.Jain@oracle.com> wrote:
>> Do you have this fix ..
>>
>>   [PATCH] Btrfs: release path before starting transaction in can_nocow_extent
>>
>> could you try ?.
>
> I believe I already have this patch.  3.18.9 contains this:
>
> commit bdeeab62a611f1f7cd48fd285ce568e8dcd0455a
> Merge: 797afdf 1bda19e
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Fri Oct 18 16:46:21 2013 -0700
>
>      Merge branch 'for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
>
>      Pull btrfs fix from Chris Mason:
>       "Sage hit a deadlock with ceph on btrfs, and Josef tracked it down to a
>        regression in our initial rc1 pull.  When doing nocow writes we were
>        sometimes starting a transaction with locks held"
>
>      * 'for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs:
>        Btrfs: release path before starting transaction in can_nocow_extent
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
