Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35737 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbaKDXmY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Nov 2014 18:42:24 -0500
Date: Tue, 4 Nov 2014 15:42:22 -0800
From: Mark Fasheh <mfasheh@suse.de>
To: Chris Mason <clm@fb.com>
Cc: Erik Berg <btrfs@slipsprogrammoer.no>, linux-btrfs@vger.kernel.org
Subject: Re: Kernel crash during "btrfs device delete" on raid6 volume
Message-ID: <20141104234222.GB27026@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <m3ao9u$de7$1@ger.gmane.org> <1415112914.25930.0@mail.thefacebook.com> <1415116728.25930.1@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1415116728.25930.1@mail.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 04, 2014 at 10:58:48AM -0500, Chris Mason wrote:
>> Not a new bug unfortunately, but since it is in the error handling people 
>> must not be hitting it often.  It's also not related to device replace.
>>
>>
>>        while (ret < 0 && !list_empty(&tmplist)) {
>>                sums = list_entry(&tmplist, struct btrfs_ordered_sum, 
>> list);
>>                list_del(&sums->list);
>>                kfree(sums);
>>        }
>>
>> We're trying to call kfree on the on-stack list head.  I'm fixing it up 
>> here, thanks for posting the oops!
>
> Fix attached, or you can wait for the next rc.  Thanks.
>
> -chris
>
>

> >From 6e5aafb27419f32575b27ef9d6a31e5d54661aca Mon Sep 17 00:00:00 2001
> From: Chris Mason <clm@fb.com>
> Date: Tue, 4 Nov 2014 06:59:04 -0800
> Subject: [PATCH] Btrfs: fix kfree on list_head in btrfs_lookup_csums_range
>  error cleanup
> 
> If we hit any errors in btrfs_lookup_csums_range, we'll loop through all
> the csums we allocate and free them.  But the code was using list_entry
> incorrectly, and ended up trying to free the on-stack list_head instead.
> 
> This bug came from commit 0678b6185

Wow, that's an old commit! Thanks for the CC. The fix looks good to me, so
you can add:

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

if you like, thanks.
	--Mark

--
Mark Fasheh
