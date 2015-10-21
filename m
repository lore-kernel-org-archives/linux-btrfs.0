Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35498 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbbJURQs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 13:16:48 -0400
Received: by wicll6 with SMTP id ll6so100941958wic.0
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 10:16:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADob98SbbLfLorGX0W4MRWMYe_uWFVQA88k7VRJLkv0nhANReg@mail.gmail.com>
References: <1428383355-1686-1-git-send-email-dccitaliano@gmail.com>
	<1428383355-1686-2-git-send-email-dccitaliano@gmail.com>
	<20150626140823.GU726@twin.jikos.cz>
	<CADob98SbbLfLorGX0W4MRWMYe_uWFVQA88k7VRJLkv0nhANReg@mail.gmail.com>
Date: Wed, 21 Oct 2015 10:16:46 -0700
Message-ID: <CADob98QV6MLi9W_T+EdPyLc=UJ9=hzycJ7J=uVPT-6p4zqH8GQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: Improve FL_KEEP_SIZE handling in fallocate.
From: Davide Italiano <dccitaliano@gmail.com>
To: Davide Italiano <dccitaliano@gmail.com>, linux-btrfs@vger.kernel.org,
        Chris Mason <clm@fb.com>, dsterba@suse.cz, bo.li.liu@oracle.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 22, 2015 at 10:45 AM, Davide Italiano <dccitaliano@gmail.com> wrote:
> On Fri, Jun 26, 2015 at 7:08 AM, David Sterba <dsterba@suse.cz> wrote:
>> On Mon, Apr 06, 2015 at 10:09:15PM -0700, Davide Italiano wrote:
>>> - We call inode_size_ok() only if FL_KEEP_SIZE isn't specified.
>>> - As an optimisation we can skip the call if (off + len)
>>>   isn't greater than the current size of the file. This operation
>>>   is called under the lock so the less work we do, the better.
>>> - If we call inode_size_ok() pass to it the correct value rather
>>>   than a more conservative estimation.
>>>
>>> Signed-off-by: Davide Italiano <dccitaliano@gmail.com>
>>
>> Reviewed-by: David Sterba <dsterba@suse.cz>
>
> Hi Chris, this has been around for a while and it's been reviewed by
> multiple people. Any chances you can pull in your branch?
>
> Thanks,
>
> --
> Davide

Any chance to get this in?
