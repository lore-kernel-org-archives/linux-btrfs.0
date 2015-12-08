Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41802 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932185AbbLHBvP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Dec 2015 20:51:15 -0500
Subject: Re: [PATCH v2 00/25] Btrfs-convert rework to support separate chunk
 type
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151207152011.GE4227@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56663775.9080504@cn.fujitsu.com>
Date: Tue, 8 Dec 2015 09:50:45 +0800
MIME-Version: 1.0
In-Reply-To: <20151207152011.GE4227@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2015/12/07 16:20 +0100:
> On Tue, Dec 01, 2015 at 03:11:20PM +0800, Qu Wenruo wrote:
>> Here comes the 2st version of btrfs-convert rework.
>> This time, it is rebased to co-operate with David new abstraction work
>> for incoming reiserfs support.
>> (Sorry David, your reiserfs support will need more modification as the
>> abstraction facility is also modified in this patchset)
>
> Yeah seems like the removed functions are not needed, the reiser code
> should be portable on top of the v2 code.
>
>> Any test is welcomed, and it can already pass the convert test from
>> btrfs-progs. (Since the test doesn't test rollback function)
>
> I'll start merging the patches to devel when I'm sure I understand the
> change so more reviewers can help and are welcome too. The unmerged
> patches would be put into an integration branch, hopefully this would
> work.

Feel free if you have any question on the patches or the design behind it.

>
>> 2. Structurized make_btrfs_v2()
>>     Unlike old make_btrfs() which is a mess of hand written codes
>
> I though 99% of our code is hand written :)

I hope I can write code by mind. :)

Thanks,
Qu

>
>>     new
>>     make_btrfs_v2() is all structurized and should be easy for later
>>     expansion.
>
>


