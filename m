Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22292 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753737AbcCBAsX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2016 19:48:23 -0500
Subject: Re: [GIT PULL] Btrfs fixes for 4.6
To: Chris Mason <clm@fb.com>, <dsterba@suse.cz>, <fdmanana@kernel.org>,
        <linux-btrfs@vger.kernel.org>
References: <1456492920-18169-1-git-send-email-fdmanana@kernel.org>
 <20160301092026.GX23746@twin.jikos.cz>
 <20160301160650.fjyyrnf6qfcekgr6@floor.thefacebook.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56D63846.7090204@cn.fujitsu.com>
Date: Wed, 2 Mar 2016 08:48:06 +0800
MIME-Version: 1.0
In-Reply-To: <20160301160650.fjyyrnf6qfcekgr6@floor.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Chris Mason wrote on 2016/03/01 11:06 -0500:
> On Tue, Mar 01, 2016 at 10:20:26AM +0100, David Sterba wrote:
>> Hi Chris,
>>
>> On Fri, Feb 26, 2016 at 01:22:00PM +0000, fdmanana@kernel.org wrote:
>>> The following changes since commit 0fcb760afa6103419800674e22fb7f4de1f9670b:
>>>
>>>    Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into for-linus-4.6 (2016-02-24 10:21:44 -0800)
>>>
>>> are available in the git repository at:
>>>
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git integration-4.6
>>>
>>> for you to fetch changes up to 97c86c11a5cb9839609a9df195e998c3312e68b0:
>>>
>>>    Btrfs: do not collect ordered extents when logging that inode exists (2016-02-26 04:28:15 +0000)
>>
>> Filipe's branch is based on some integration snapshot that contains the
>> 'delete device by id' patchset that was removed from the 4.6 queue.
>>
>> Your branch 'next' merges it back again through Filipe's tree, besides
>> that the merge commits of the topic branches in my for-next appear
>> twice. While the duplicated commits are only an esthetic issue, the
>> extra branch bothers me.
>>
>> I don't see a nice way how to avoid rebases in this cases. My suggestion
>> is that Filipe rebases the branch on my for-chris that could have been
>> an integration at some point.
>>
>> As we're merging our branches that way for the first time I'd like to
>> find the workflow also for the next dev cycles so I'm open to other
>> suggestions.
>
> Ugh, thanks Dave I missed this.  I'll rebase Filipe on top of your
> branch.  The easiest way to avoid it in general is to only base trees on
> top of things already in Linus' tree.  If there are specific
> dependencies we can work it out on a case by case basis, but the merge
> conflicts are almost always trivial.
>
> -chris

Although off-topic, but do we need to rebase all sent pull to the new 
integration-4.6?
Yes, I mean the in-band de-dup patchset. (If it is going to be merged)

Thanks,
Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


