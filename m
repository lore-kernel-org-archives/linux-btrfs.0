Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44535 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752866AbbA2BUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Jan 2015 20:20:38 -0500
Message-ID: <54C98420.9050408@cn.fujitsu.com>
Date: Thu, 29 Jan 2015 08:51:44 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/4] Better btrfsck tree corruption report and automatic
 csum tree rebuild.
References: <1421114687-6084-1-git-send-email-quwenruo@cn.fujitsu.com> <20150128182740.GI3641@twin.jikos.cz>
In-Reply-To: <20150128182740.GI3641@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH 0/4] Better btrfsck tree corruption report and 
automatic csum tree rebuild.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年01月29日 02:27
> On Tue, Jan 13, 2015 at 10:04:43AM +0800, Qu Wenruo wrote:
>> Although btrfsck can rebuild the csum tree, but has the following
>> problems for end users or sysadmins who is not familiar with btrfs.
>> 1) No brief info on which tree is corrupted.
>>     In fact, after extent and chunk tree check, we iterate all the
>>     extents and should have a brief view about which tree is corrupted.
>>     We can info user the fact to give them a clear view about what to do
>>     next
>>
>> 2) No automatically csum tree rebuild.
>>     If btrfsck can rebuild csum tree when needed and possible, why not
>>     rebuild it?
>> This patchset handles this 2 problems:
>> Patch 1 will handle problem 1) and patch 2~3) to handle problem 2).
>> Now csum tree will be automatically rebuilt if and only if csum tree is
>> broken but all other tree is OK.
> I don't agree here, rebuilding the csum tree should be user's decision.
> Point 1) is good, giving more information to the user certainly helps to
> make that decision.
If 1) is merged, I'm OK with not merging 2).
Since before this patchset, even csum tree is corrupted, we don't even 
know csum tree is corrupted.

So if 1) is merged, user will be more clear to reset the csum tree.

Thanks,
Qu


