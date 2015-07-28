Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4416 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752739AbbG1AZr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 20:25:47 -0400
Subject: Re: [PATCH 0/7] btrfs-progs: qgroup related enhance.
To: <dsterba@suse.com>, <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1425025599-30048-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150323233803.GP20767@twin.jikos.cz> <5510B191.1010402@cn.fujitsu.com>
 <20150727143509.GF6306@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55B6CC07.5000301@cn.fujitsu.com>
Date: Tue, 28 Jul 2015 08:25:43 +0800
MIME-Version: 1.0
In-Reply-To: <20150727143509.GF6306@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2015/07/27 16:35 +0200:
> On Tue, Mar 24, 2015 at 08:36:33AM +0800, Qu Wenruo wrote:
>>> All of the above merged.
>>>
>>>>     btrfs-progs: Schedule quota rescan if qgroup assign caused
>>>>       inconsistence.
>>>
>>> The rescan can be a long running operation and touches a lot of
>>> metadata, so I'd rather avoid starting the rescan automatically. Right
>>> now the user may start rescan manually, or please add an commandline
>>> option (eg. --rescan) to do the rescan in one go with the 'assign'
>>> command. Thanks.
>>>
>> Makes sense, I'll update the last patch soon.
>
> I've merged your patch without changes and implemented the --rescan
> option myself.
>
Oh, I forgot to update this one...

Thanks a lot for implement --rescan option.

Thanks,
Qu
