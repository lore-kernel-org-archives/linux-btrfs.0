Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37455 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbcEPDCr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 May 2016 23:02:47 -0400
Received: by mail-wm0-f53.google.com with SMTP id a17so114785444wme.0
        for <linux-btrfs@vger.kernel.org>; Sun, 15 May 2016 20:02:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <85030f6b-b149-ccd2-ea87-42135b9ccd46@cn.fujitsu.com>
References: <CAD=QJKjop2j+K16nPcAU-bXiCVqm_aGK0g7WxjvTpBvXar+fQQ@mail.gmail.com>
	<85030f6b-b149-ccd2-ea87-42135b9ccd46@cn.fujitsu.com>
Date: Sun, 15 May 2016 23:02:45 -0400
Message-ID: <CAD=QJKiT-PGSApL+GSwN3eJxLRQVFD3RyPfNi=oQ-=TdmMBPZQ@mail.gmail.com>
Subject: Re: problems with free space cache
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 15 May 2016 at 22:24, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> Nicholas D Steeves wrote on 2016/05/15 22:11 -0400:
>> What is the standard procedure for fixing the cache?  Rootfs is a
>> subvolume and the first entry in fstab.  Second entry is /btrfs-admin,
>> which is where I mount the whole volume.  Is it sufficient to add the
>> clear_cache option to the rootfs entry, or does the /btrfs-admin entry
>> also need it?
>
>
> IIRC clear_cache option is fs level option.
> So the first mount with clear_cache, then all subvolume will have
> clear_cache.
>

So that means that in this case mounting subvol=rootfs with
clear_cache will clear the cache for all subsequently mounted
subvolumes, and for the whole volume, correct?

Thanks,
Nicholas
