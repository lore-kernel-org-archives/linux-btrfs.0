Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36366 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbbDIWB5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 18:01:57 -0400
Received: by wizk4 with SMTP id k4so108231262wiz.1
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2015 15:01:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5525CBA1.5000408@cn.fujitsu.com>
References: <201504091039.33442.russell@coker.com.au>
	<5525CBA1.5000408@cn.fujitsu.com>
Date: Thu, 9 Apr 2015 15:01:55 -0700
Message-ID: <CAKgsxVQ8=Y43DbJ+cNJSt6sb9uPKSfNx+HxErnVMvA6grBCVyg@mail.gmail.com>
Subject: Re: snapshot space use
From: Justin Maggard <jmaggard10@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: russell@coker.com.au, BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 8, 2015 at 5:45 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Hi,
>
> You can use btrfs quota feature to do it.
> Like this:
>
> # btrfs quota enable <MNT_POINT>
> # btrfs quota rescan -w <MNT_POINT>
> # btrfs qgroup show -prce <MNT_POINT>
> qgroupid rfer    excl    max_rfer max_excl parent  child
> -------- ----    ----    -------- -------- ------  -----
> 0/5      2248704 12288   0        0        ---     ---
> 0/256    5509120 3272704 0        0        ---     ---
>
>
> rfer is all the space the subvolume takes.
> excl is the exclusive space the subvolume takes.
>

Yes, but this isn't as useful as it sounds if you have more than one
snapshot.  Because if a file is included in at least two snapshots,
it's no longer exclusive.  So AFAICT even with btrfs qgroups, you
still cannot answer the question "How much space are my snapshots
using?" for a given subvolume, unless you have only one snapshot.  But
I'd be happy to be informed otherwise. :-)

-Justin

> You can also refer to 'btrfs-quota'(8) and 'btrfs-qgroup'(8),
> Also the following wiki can help:
> https://btrfs.wiki.kernel.org/index.php/Quota_support
>
> NOTE: quota is not so stable and has some problem, but should give
> you enough info.
>
> Thanks,
> Qu
>
>> # zfs list -t snapshot
>> NAME                        USED  AVAIL  REFER  MOUNTPOINT
>> hetz0/be0-mail@2015-03-10  2.88G      -   387G  -
>> hetz0/be0-mail@2015-03-11  1.12G      -   388G  -
>> hetz0/be0-mail@2015-03-12  1.11G      -   388G  -
>> hetz0/be0-mail@2015-03-13  1.19G      -   388G  -
>> hetz0/be0-mail@2015-03-14  1.02G      -   388G  -
>> hetz0/be0-mail@2015-03-15   989M      -   386G  -
>>
>> Is there any way to do something similar to the above ZFS command?  It's
>> handy
>> to know which snapshots are taking up the most space, especially when
>> multiple
>> subvols are being snapshotted.
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
