Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61116 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932820AbbLHGvc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2015 01:51:32 -0500
Subject: Re: [PATCH v2] btrfs: Introduce new mount option to disable tree log
 replay
To: Roman Mamedov <rm@romanrm.net>
References: <1449555033-25075-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151208113152.5f8edeaf@natsu>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56667DC2.6080507@cn.fujitsu.com>
Date: Tue, 8 Dec 2015 14:50:42 +0800
MIME-Version: 1.0
In-Reply-To: <20151208113152.5f8edeaf@natsu>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Roman Mamedov wrote on 2015/12/08 11:31 +0500:
> On Tue,  8 Dec 2015 14:10:33 +0800
> Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>> Introduce a new mount option "nologreplay" to co-operate with "ro" mount
>> option to get real readonly mount, like "norecovery" in ext* and xfs.
>
> Maybe name it "norecovery" too, for simplicity and consistency?

That's also our first idea.
But the sad fact is, btrfs already has a mount option called "recovery".

So "norecovery" here will just be considered as a mount option to 
disable "recovery", and that will make things more confusing.

And finally we choose the name "nologreplay".

Thanks,
Qu

>
> The actual effect of "norecovery" in ext* and xfs is to also disable log
> replay, but that's an under-the-hood detail not relevant to the user.
>
> ---
> Mount options for ext3
>
>         norecovery/noload
>                Don't load the journal on mounting.  Note that if the filesystem
>                was not unmounted cleanly, skipping the journal replay will lead
>                to  the  filesystem  containing inconsistencies that can lead to
>                any number of problems.
> ---
> Mount options for xfs
>
>         norecovery
>                The filesystem will be mounted without running log recovery.  If
>                the filesystem was not cleanly unmounted, it  is  likely  to  be
>                inconsistent  when  mounted  in  norecovery mode.  Some files or
>                directories may not be accessible because of this.   Filesystems
>                mounted  norecovery  must be mounted read-only or the mount will
>                fail.
> ---
>


