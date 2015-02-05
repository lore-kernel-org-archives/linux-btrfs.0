Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21799 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753953AbbBEQ5X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Feb 2015 11:57:23 -0500
Message-ID: <54D3A0C9.3000907@fb.com>
Date: Thu, 5 Feb 2015 11:56:41 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: <linux-btrfs@vger.kernel.org>, <dm-devel@redhat.com>,
        <david@fromorbit.com>, <sandeen@redhat.com>, <hch@infradead.org>,
        <linux-fsdevel@vger.kernel.org>, <tytso@mit.edu>, <clm@facebook.com>,
        <zab@redhat.com>
Subject: Re: [PATCH][RFC] dm: log writes target
References: <1418077949-28771-1-git-send-email-jbacik@fb.com> <20150204184108.GA2801@redhat.com>
In-Reply-To: <20150204184108.GA2801@redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/04/2015 01:41 PM, Mike Snitzer wrote:
> On Mon, Dec 08 2014 at  5:32P -0500,
> Josef Bacik <jbacik@fb.com> wrote:
>
>> This is my latest attempt at a target for testing power fail and fs consistency.
>> This is based on the idea Zach Brown had where we could just walk through all
>> the operations done to an fs in order to verify we're doing the correct thing.
>> There is a userspace component as well that can be found here
>>
>> https://github.com/josefbacik/log-writes
>>
>> It is very rough as I just threw it together to test the various aspects of how
>> you would want to replay a log to test it.  Again I would love feedback on this,
>> I really want to have something that we all think is usefull and eventually
>> incorporate it into xfstests.
>
> hey josef,
>
> i finally took a quick look at your target.  has this target proven
> useful to you (or others) since you posted?  would you still like to see
> this land upstream?
>
> i see no need to stack discard limits if discards are supported by the
> underlying device (you'll get that for free via blk_stack_limits).
>
> here is a patch that applies ontop of your original submission.  mostly
> whitespace (i'm not pedantic about 80 char limit, etc).  but i did
> include some small improvements and FIXMEs/questions in the patch:
>

Hello,

Yup I still want to land this upstream, I've been using it to find 
balance bugs and other things in btrfs.  With the holidays and all my 
family medical things going on recently I haven't had as much time to 
put into this as I wanted but I've made some improvements to it 
recently.  My plan was to wait until LSF so I could present my ideas to 
all the FS and DM guys at the same time to make sure we were happy with 
this approach and then submit shortly after that.

I will apply this and look through the FIXME's soon and send another 
update to make sure things still look good.  Thanks for looking at this,

Josef
