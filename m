Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47153 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752497AbbKZAij (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 19:38:39 -0500
Subject: Re: [PATCH 00/25] Btrfs-convert rework to support native separate
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151123173330.GH31035@twin.jikos.cz> <565424B8.3020502@cn.fujitsu.com>
 <20151125124235.GO31035@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5656547F.5050900@cn.fujitsu.com>
Date: Thu, 26 Nov 2015 08:38:23 +0800
MIME-Version: 1.0
In-Reply-To: <20151125124235.GO31035@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2015/11/25 13:42 +0100:
> On Tue, Nov 24, 2015 at 04:50:00PM +0800, Qu Wenruo wrote:
>> It seems the conflict is quite huge, your reiserfs support is based on
>> the old behavior, just like what old ext2 one do: custom extent allocation.
>
>> I'm afraid the rebase will take a lot of time since I'm completely a
>> newbie about reiserfs... :(
>
> Yeah, the ext2 callbacks are abstracted and replaced by reiserfs
> implementations, and the abstratction is quite direct. This might be a
> problem with merging your patchset.

The abstraction is better than I expected, and should be quite handle to 
use.

Although a lot of my codes will be changed to use it.

>
>> I may need to change a lot of ext2 direct call to generic one, and may
>> even change the generic function calls.(no alloc/free, only free space
>> lookup)
>>
>> And some (maybe a lot) of reiserfs codes may be removed during the rework.
>
> As far as the conversion support stays, it's not a problem of course. I
> don't have a complete picture of all the actual merging conflicts, but
> the idea is to provide the callback abstraction v2 to allow ext2 and
> reiser plus allow all the changes of this pathcset.
>
>
Glad to hear that.

BTW, which reiserfs progs headers are you using?

It seems that the headers you are using is quite different from what my 
distribution is providing, and this makes compile impossible.

For example, in my /usr/include/reiserfs, there is no io.h, no reiserfs.h.

No structure named reseifs_key, but only key.

Not sure if it is my progsreiserfs is too old or whatever other reason.

What progsreiserfs are you using?

Thanks,
Qu


