Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50923 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933607Ab2JXKDD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 06:03:03 -0400
Message-ID: <5087BCEB.8070303@cn.fujitsu.com>
Date: Wed, 24 Oct 2012 18:03:23 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: cwillu <cwillu@cwillu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs: do not delete a subvolume which is in a R/O
 subvolume
References: <50853089.6010801@cn.fujitsu.com> <CAE5mzvhaQLZEMgyAPGZ7pFbNR9c17ke1FGRXUfY86vD31_3viQ@mail.gmail.com>
In-Reply-To: <CAE5mzvhaQLZEMgyAPGZ7pFbNR9c17ke1FGRXUfY86vD31_3viQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 22 Oct 2012 05:57:12 -0600, cwillu wrote:
> On Mon, Oct 22, 2012 at 5:39 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>> Step to reproduce:
>>  # mkfs.btrfs <disk>
>>  # mount <disk> <mnt>
>>  # btrfs sub create <mnt>/subv0
>>  # btrfs sub snap <mnt> <mnt>/subv0/snap0
>>  # change <mnt>/subv0 from R/W to R/O
>>  # btrfs sub del <mnt>/subv0/snap0
>>
>> We deleted the snapshot successfully. I think we should not be able to delete
>> the snapshot since the parent subvolume is R/O.
> 
> snap0 isn't read-only in that case, right?  From a user interaction
> standpoint, this seems like it just forces a user to rm -rf rather
> btrfs sub del, which strikes me as a bit ham-handed when all we really
> care about is leaving a (the?) directory entry where snap0 used to be.
> 

I don't think we can identify "btrfs sub del" with "rm -rf", because "rm -rf"
will check the permission of the parent directory of each file/directory which
is going to be deleted, but "btrfs sub del" doesn't do it, it will see all the
file/directory in the subvolume as one, so I think it seems like a special
"rmdir". From this standpoint, deleting a snapshot whose parent subvolume
is readonly should be forbidden.

Thanks
Miao
