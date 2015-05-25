Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.lqfe.com ([72.14.186.34]:60107 "EHLO mail.lqfe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbbEYQg6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 May 2015 12:36:58 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Subject: Re: Did convert do anything?
From: Anthony Plack <tmy@plack.net>
In-Reply-To: <CA+WRLO_5mG7t+2x-B+AV052i2=pkPmAr88txeQ4ZkxL7jvOAig@mail.gmail.com>
Date: Mon, 25 May 2015 11:36:55 -0500
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <33764626-2528-47DC-A31B-B801419856C7@plack.net>
References: <CA+WRLO_=RV_Ga7d-ff=p13TxycquQ1Ra2d2WYeGroQn9tm934w@mail.gmail.com> <036B4518-F7BF-4C9A-8906-38550D7F125F@plack.net> <CA+WRLO_5mG7t+2x-B+AV052i2=pkPmAr88txeQ4ZkxL7jvOAig@mail.gmail.com>
To: Gareth Pye <gareth@cerberos.id.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On May 24, 2015, at 11:00 PM, Gareth Pye <gareth@cerberos.id.au> wrote:
> 
> 2.
> 18% or 1.1T spare currently. That isn't what I'd call tiny free space.
> --
> 

# btrfs  fi df /data
Data, RAID1: total=4.43TiB, used=4.41TiB

Of 4.43TiB, btrfs believes you have used 4.41TiB.  

Chris’s fix to this has to deal with the ENOSPC error "No space left on device”, not because you don’ t have free space but because your extents are marked as used and you need a balance operation to clean it up.

https://patchwork.kernel.org/patch/6238111/
> Before the reverted commit, this test case failed with ENOSPC because
> all chunks on the freshly converted filesystem were allocated, although
> many were empty. The reverted commit removed an allocation attempt in
> btrfs_set_block_group_ro(), but that fix wasn't right. After the
> reverted commit, the balance succeeds, but the data/metadata profiles
> aren't actually updated:

