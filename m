Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37074 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750814AbaLPBfO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 20:35:14 -0500
Message-ID: <548F8C4E.4020905@cn.fujitsu.com>
Date: Tue, 16 Dec 2014 09:35:10 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Filipe David Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs-progs: Add support for btrfs-image + corrupt
 script fsck test case.
References: <1418615699-18169-1-git-send-email-quwenruo@cn.fujitsu.com> <CAL3q7H5TrEGT87by4Zgs_Gy-OagBBEQVdk0A54snC9334wRP1w@mail.gmail.com> <CAL3q7H5XAR1UBYeNzcV6AXRFEpN7=gZ2znDycsDDE2opLovK3g@mail.gmail.com> <20141215181953.GT27601@twin.jikos.cz>
In-Reply-To: <20141215181953.GT27601@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH 1/2] btrfs-progs: Add support for btrfs-image + 
corrupt script fsck test case.
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Date: 2014年12月16日 02:19
> On Mon, Dec 15, 2014 at 10:13:45AM +0000, Filipe David Manana wrote:
>>> So another thing I would like to see is doing a more comprehensive
>>> verification that the repair code worked as expected. Currently we
>>> only check that a readonly fsck, after running fsck --repair, returns
>>> 0.
>>>
>>> For the improvements you've been doing, it's equally important to
>>> verify that --repair recovered the inodes, links, etc to the
>>> lost+found directory (or whatever is the directory's name).
>>>
>>> So perhaps adding a verify.sh script to the tarball for example?
>> Or, forgot before, it might be better to do such verification/test in
>> xfstests since we can create the fs and use the new btrfs-progs
>> programs to corrupt leafs/nodes. xfstests has a lot of infrastructure
>> already and probably run by a lot more people (compared to the fsck
>> tests of btrfs-progs).
> I'm thinking about the best way how to integrate that, but it seems that
> there will be always some level of code or infrastructure duplication
> (or other hassle).
>
> btrfs-corrupt-block is not installed by default (make install) and it's
> not a type of utility I'd consider for default installations. The tests
> would be skipped in absence of the utility, so there will be test
> environments where "install xfstests, install btrfspprogs" will not add
> the desired test coverage. Solvable by packaging the extra progs.
>
> Adding corrupt-block into xfsprogs is infeasible (IMO too much code from
> btrfs-progs to be added).
>
> I don't know how much infrastructure code we'd have to either write or
> copy from fstests, but I think it would not be that much. Ideally we
> could write the tests within btrfs-progs and then submit them to fstests
> once they're considered reliable. If we keep the same "syntax" of the
> tests, provide stubs where applicable, the code duplication in test
> itself would be zero. We'd only have to write the stubs in btrfs-progs
> and probably extend fstests to provide helpers for preparing/unpacking
> the images.
In my wildest idea, if we have a good enough btrfs debugger(maybe even 
stronger than debugfs), which can
do almost everything from read key/item to corrupt given structure, then 
we can resolve them all.
No binary image since corruption can be done by it and verify can also 
done by it.
(OK, it's just a daydream)

But IMHO, isn't xfstests designed to mainly detect kernel defeats?
I don't see any fsck tool test case in it.

Thanks,
Qu
>
> Also, collecting the crafted binary images may bloat the git repo
> nicely, even if we use xz.
