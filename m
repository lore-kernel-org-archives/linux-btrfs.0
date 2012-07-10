Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49510 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab2GJMSU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jul 2012 08:18:20 -0400
Received: by wgbdr13 with SMTP id dr13so12450342wgb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2012 05:18:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FF12190.9090005@cn.fujitsu.com>
References: <CAMVG2stz6ED4D-YzST7V59jFsDS0gcB4cXrVd8ZTpXohRZh6Hw@mail.gmail.com>
	<4FF12190.9090005@cn.fujitsu.com>
Date: Tue, 10 Jul 2012 20:18:18 +0800
Message-ID: <CAMVG2stBLy9U6GyLty=EsNrPKbEasLsnF5rcQW2EO0DOtOK0Og@mail.gmail.com>
Subject: Re: Please hammer my for-linus branch
From: Daniel J Blueman <daniel@quora.org>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        Linux BTRFS <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2 July 2012 12:20, Liu Bo <liubo2009@cn.fujitsu.com> wrote:
> On 07/02/2012 11:35 AM, Daniel J Blueman wrote:
>
>>> Hi everyone,
>>>
>>> I've got a nice set of fixes from Josef, Jan, Ilya and others in my
>>> for-linus branch:
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
>>>
>>> Some of the changes are fixes for the tree logging code, so I ran some
>>> extra crash runs against them Friday night.
>>>
>>> I ended up with a new crash in the tree log directory deletion replay
>>> code, so I didn't send out the pull request to Linus.
>>>
>>> It isn't clear yet if the new crash is because I was testing differently
>>> or if it is a regression.  I'm nailing it down this weekend, but please
>>> give my for-linus a shot.
>>
>> With this branch (3.4.0), my test has consistently been hitting the
>> BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID) in
>> insert_inline_extent_backref [1]. This is followed by a string of
>> other issues [2] and a hard lockup, so I used netconsole to collect
>> this.
>>
>> I'm preparing my btrfs test for xfstests integration, but can slip you
>> it if interested. It hits this case in ~30s.
>>
>
>
> IMO the BUG_ON is meant to avoid to mix 'log tree' in, it should be:
>
> BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID && root_objectid == BTRFS_TREE_LOG_OBJECTID);
>
> This should help you, can you give it a try?

Bo, this did address the assertion I was tripping, so looks good from
here; it allowed me to report the second (different) assertion of
course.

If you still think the fix is sound, is it a good idea for 3.5-rc7?

Thanks,
  Daniel
-- 
Daniel J Blueman
