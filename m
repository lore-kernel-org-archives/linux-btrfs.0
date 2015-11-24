Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21377 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752498AbbKXAxi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 19:53:38 -0500
Subject: Re: [PATCH 00/25] Btrfs-convert rework to support native separate
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151123173330.GH31035@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5653B503.5040500@cn.fujitsu.com>
Date: Tue, 24 Nov 2015 08:53:23 +0800
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
Thanks for the check, David.

I'll rebase it soon.

Thanks,
Qu

-- 
This message has been scanned for viruses and
dangerous content by FCNIC, and is
believed to be clean.

