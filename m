Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36098 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751730AbbKXIuj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 03:50:39 -0500
Subject: Re: [PATCH 00/25] Btrfs-convert rework to support native separate
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151123173330.GH31035@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <565424B8.3020502@cn.fujitsu.com>
Date: Tue, 24 Nov 2015 16:50:00 +0800
MIME-Version: 1.0
In-Reply-To: <20151123173330.GH31035@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2015/11/23 18:33 +0100:
> On Fri, Nov 20, 2015 at 11:24:04AM +0800, Qu Wenruo wrote:
>> Here comes the 1st version of btrfs-convert rework.
>> Any test is welcomed, and it can already pass the convert test from
>> btrfs-progs. (Since the test doesn't test rollback function)
>
> I went through the patches, looks mostly ok akin to the proposed
> changes. I'll take the independent patches rightaway. Unfortunatelly
> there are code changes that clash significantly with the pending
> reiserfs addition to convert, I'm afraid you'll have to rework your
> patchset on top of that.  The code is now pushed to branch
> 'dev/convert-reiser'.
>

Hi David,

It seems the conflict is quite huge, your reiserfs support is based on 
the old behavior, just like what old ext2 one do: custom extent allocation.

I'm afraid the rebase will take a lot of time since I'm completely a 
newbie about reiserfs... :(

I may need to change a lot of ext2 direct call to generic one, and may 
even change the generic function calls.(no alloc/free, only free space 
lookup)

And some (maybe a lot) of reiserfs codes may be removed during the rework.

Will it be OK for you?

Thanks,
Qu

-- 
This message has been scanned for viruses and
dangerous content by Fujitsu, and is believed to be clean.

