Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30244 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752445AbbIWHQo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 03:16:44 -0400
Subject: Re: [PATCH RFC 00/14] Yet Another In-band(online) deduplication
 implement
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1438072250-2871-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150728145021.GI6306@twin.jikos.cz> <55BF15DF.9080805@cn.fujitsu.com>
 <20150827091407.GB11834@suse.cz> <55E3AA39.1060109@cn.fujitsu.com>
 <20150922150737.GP12815@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <560251DA.5080509@cn.fujitsu.com>
Date: Wed, 23 Sep 2015 15:16:42 +0800
MIME-Version: 1.0
In-Reply-To: <20150922150737.GP12815@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2015/09/22 17:07 +0200:
> On Mon, Aug 31, 2015 at 09:13:29AM +0800, Qu Wenruo wrote:
>>> That's the wrong interface to use for such actions.
>>>
>> But IMHO, deduplication is much like compression, we only need to
>> execution extra hook to handle data at run_delalloc_range().
>
> It is, but the filesystem-wide compression already shows its
> limitations. Eg. it's not possible to set the compression on a
> per-subvolume (or at least per-subvolume-mount [*]) basis, it's not possible
> to select the compression method for a given file or directory.

Make sense, for this point, it's better to use ioctl other than add 
complicated mount options.

>
> Next, changing the status of dedup via remount is quite a heavy
> operation. Remount has to sync the whole filesystem, while this is not
> strictly necessary for changes in the dedup parameters.
>
> The ioctl, if designed well, can be ready for future enhancements and we
> can fine-tune the dedup engine in ways that we do not forsee right now.
> I really don't want to see the mount options grow that way.

Very convincing.
I'll change to use ioctl instead of mount option.

But this will definitely introduce new incompact feature, as even using 
the in-memory only dedup engine, it will still need some persistent data 
to record the dedup status, or we need to call "btrfs dedup enable" 
every time after mount.

Thanks for the review,
Qu

>
>> And even better than compression, inline dedup won't even cause any
>> format change.
>> So I'd prefer to use mount option other than introduce a new ioctl
>> interface.
>
> Yeah, no change in the format makes it just a matter of selecting the
> right interface to manage dedup.
>
> (I don't remember if there were other points that I wrote back then when
> Liu Bo sent his in-band dedup patches and wanted to use the mount
> options as well.)
>
>
> [*] I do have a POC for that, mostly working and will submit at least
>      for RFC
>
