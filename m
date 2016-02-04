Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26383 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964847AbcBDBNG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Feb 2016 20:13:06 -0500
Subject: Re: [PATCH 0/7] Let user specify the kernel version for features
To: <dsterba@suse.cz>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>,
        <calestyo@scientia.net>, <ahferroin7@gmail.com>,
        <1i5t5.duncan@cox.net>
References: <5656A18E.9050607@oracle.com> <5656AC64.3030304@cn.fujitsu.com>
 <5656EA7F.1070500@oracle.com> <5656FBB7.5020802@gmx.com>
 <565784DE.5080401@oracle.com> <5657A757.90909@cn.fujitsu.com>
 <56581742.9030308@oracle.com> <565A5317.8040506@gmx.com>
 <565BD67B.9090007@oracle.com> <565BE2A7.8050501@gmx.com>
 <20160203105038.GL31992@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56B2A592.3000305@cn.fujitsu.com>
Date: Thu, 4 Feb 2016 09:12:50 +0800
MIME-Version: 1.0
In-Reply-To: <20160203105038.GL31992@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/02/03 11:50 +0100:
> Going back to this discussion,
>
> On Mon, Nov 30, 2015 at 01:46:15PM +0800, Qu Wenruo wrote:
>> To be honest, how many guys really unhappy with current default features
>> behavior *except* you?
>
> Me too.
>
> Anand's summary matches my view of how we should do it:
>
> ". Do it at run time for the running kernel. Current. In the order of
>     priority .. check sysfs, if not check kernel-version, if not use
>     progs-version-based-defaults (original)."

I'm curious under which case btrfs will fallback to 
progs-version-based-default, as I though kernel-version probe will make 
it never go to progs-version-based one. (Maybe non-numeric kernel version?)

>
> I understand that the the kernel version is not always reliable, but
> when we use it only as a fallback we know that at least kernel of this
> upstream version can mount the filesystem.

Yes, upstream version can mount it, but it does not always make sense.

For example, the kernel used by user may doesn't contain btrfs 
modules/built-in.
We shouldn't do extra check even trying to ensure something we can't ensure.

>
> And becase we can turn on additional features later this should not be a
> blocker.
>
> I disagree with your view that the weight should be put on the distro
> integrators. I've been packaging btrfs-progs for the SLES and openSUSE,
> several product lines with different kernels (upstream and backports).
> Keeping the features in sync with kernel started to be an issue with the
> first incompat feature that was different among the kernels. And we want
> change the defaults further.
>
> The main user bases that I take into account:
>
> * upstream community, ie. the latest stable version or the git version
> * older stable trees, ie. 3.2, 3.14 up to 4.1
> * heavy backports to enterprise kernels, arbitrary base version
>
> My idea of the default behaviour is to be able to use latest btrfs-progs
> (released or git) on any of them and minimize possible damage. Ie.
> respect the running kernel and try to best detect the features.

OK, but I didn't see anything sysfs-based probe can't handle.
(Except kernel doesn't support btrfs sysfs interface)

Personally, I just prefer to deprecate any kernel doesn't support btrfs 
features sysfs interface, and give a strong enough warning.

So my idea about the workflow would be:
1) Check sysfs feature interface and use it.
2) Fallback to progs-default-feature unless '-f' is given.

Much more straightforward and makes sense for me.
If kernel is too old without the sysfs intreface backported (or without 
btrfs modules/built-in), it's a very bad idea to use btrfs.

>
> Besides ancient kernels and the 3.2 that's still in use, the sysfs based
> detection should work.

Ancient kernels (including 3.2 though) without heavy backports are never 
a good idea to run btrfs on.
So I just like to deprecate them in btrfs-progs.

>
>> Or how many bug report in maillist/bugzilla is about that?
>>
>> Introducing a new feature matrix only to change the behavior to your flavor?
>> Isn't this what you called "bloated intelligence"?
>
> I'm not sure why you see the feature matrix getting more complicated.
> The testeres and developers know what features to turn on if desired,
> testing recent kernel with recent progs will do the right thing on
> itself.  The rest of the user are supposed to just install and use it.
>
>
Your point also shows that, -O ver=X.XX is not needed.
Testers/developers know which exactly feature they need to enable/disable.

And end user just use it, sysfs-based probe handles them quite well.

Ancient kernel users also get warned, so I see no need to use feature 
matrix.

Thanks,
Qu


