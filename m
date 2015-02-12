Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7821 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753447AbbBLBgC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 20:36:02 -0500
Message-ID: <54DC0381.9050303@cn.fujitsu.com>
Date: Thu, 12 Feb 2015 09:36:01 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 00/10] Enhance btrfs-find-root and open_ctree() to
 provide better chance on damaged btrfs.
References: <1422522437-18886-1-git-send-email-quwenruo@cn.fujitsu.com> <20150210144839.GC28877@twin.jikos.cz> <54DAA33F.7040109@cn.fujitsu.com> <20150211175226.GF28877@twin.jikos.cz>
In-Reply-To: <20150211175226.GF28877@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH v3 00/10] Enhance btrfs-find-root and open_ctree() 
to provide better chance on damaged btrfs.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年02月12日 01:52
> On Wed, Feb 11, 2015 at 08:33:03AM +0800, Qu Wenruo wrote:
>>>> Also, since only 2 patches is modified(although other part is slightly
>>>> modified to match the change), to avoid mail bombing, I created the pull
>>>> request on github and only send the first 2 patches with cover-letter.
>>>> https://github.com/kdave/btrfs-progs/pull/5
>>> Sending the changed patches only is ok (if you point me at the rest of
>>> the patches), but it's not necessary to open the github pull request.
>>>
>>> The version to version changelogs are also stored in the commit
>>> changelogs, that's a bit unexpected for a branch to be pulled.
>> Oh, very sorry for this.
>> I was meant to save your time, but I forgot that pull branch won't emit
>> the changelog like patches.
> Pulled except the last patch, and I've cleaned up some bits so please
> have a look. It's basically what I'd tell you during a normal review but
> now it was easier to do myself.
Thanks for merging and modifying them.
It seems that my naming sense is not so good and the new naming looks 
good for me, except some of them,
like OPEN_CTREE_SUPPRESS_CHECK_TREE_ERROR seems too long for me, but 
that's all right and doesn't
do any harm.

And it seems that the patch I send it still out of date and some naming 
changes in my v3 patch doesn't show in
it...

Sorry for taking  your time to change them.

>
> My concern about the patch "btrfs-progs: Allow open_ctree use backup
> tree root or search it automatically if primary..." is the
> 'automatically' part. Falling to the backup roots should be IMO on
> request. The tools should have (and some of them already do have)
> commandline options to request a given backup root. That way the user
> can try the default action and then decide if the backup roots are fine
> for use.
What about ask user to do such fallback method?
IMHO, such way should take a balance for average user and advanced user 
who can, for example, extract
the bad block and fix it manually without corruption.

Current btrfsck has a problem that doesn't give enough info on possible 
solutions.
The case is much like --init-(csum/extent)-tree, we provide such 
options, but when a tree block in extent
tree happens, the backref mismatch error messages won't really help to 
guide user to use --init-extent-tree
option.

How do you think about the ask-user method?

Thanks,
Qu



