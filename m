Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48597 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464AbbCWNso (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 09:48:44 -0400
Date: Mon, 23 Mar 2015 09:48:38 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: BTRFS: unable to add free space :-17
To: Tomasz Chmielewski <tch@virtall.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <1427118518.5707.6@mail.thefacebook.com>
In-Reply-To: <1427114113.5707.1@mail.thefacebook.com>
References: <d1161c0c22333dfe9b77144aa18779b1@admin.virtall.com>
	<1427114113.5707.1@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Mon, Mar 23, 2015 at 8:35 AM, Chris Mason <clm@fb.com> wrote:
> 
> 
> On Mon, Mar 23, 2015 at 8:19 AM, Tomasz Chmielewski <tch@virtall.com> 
> wrote:
>> Got this with 4.0.0-rc5 when doing a degraded mount:
> Do you get this every time, even after going back to rc4?
> 
> It should be caused by this commit, but I really don't get how.  I'll 
> dig deeper, but if you can trigger this consistently I'd love to hear 
> if reverting this commit helps.
> 
> commit ea526d18990018f224e5734748975bea1824545f
> Author: Josef Bacik <jbacik@fb.com>
> Date:   Fri Mar 13 16:40:45 2015 -0400
> 
>    Btrfs: fix ASSERT(list_empty(&cur_trans->dirty_bgs_list)

To test things, you'll need to revert this one before the ASSERT fix:

commit dcdf7f6ddba006f3482ebee73dfa6b75aec5f07b
Author: Josef Bacik <jbacik@fb.com>
Date:   Mon Mar 2 16:37:31 2015 -0500

    Btrfs: prepare block group cache before writing

    Writing the block group cache will modify the extent tree quite a 
bit because it
    truncates the old space cache and pre-allocates new stuff.  To try 
and cut down
    on the churn lets do the setup dance first, then later on hopefully 
we can avoid
    looping with newly dirtied roots.  Thanks,

    Signed-off-by: Josef Bacik <jbacik@fb.com>




