Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:51383 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbaFWXnl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 19:43:41 -0400
Received: by mail-ie0-f177.google.com with SMTP id tp5so6368843ieb.22
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jun 2014 16:43:40 -0700 (PDT)
Message-ID: <53A8BBAA.4020901@gmail.com>
Date: Mon, 23 Jun 2014 18:43:38 -0500
From: Kevin Brandstatter <icarusthecow@gmail.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: Removing file = quota exceded
References: <53A62E89.6040900@gmail.com> <53A7069E.5010003@fb.com>
In-Reply-To: <53A7069E.5010003@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 06/22/2014 11:38 AM, Josef Bacik wrote:
> On 06/21/2014 06:16 PM, Kevin Brandstatter wrote:
>> so ive come accross the issue of being unable to remove a file when a
>> subvolume quota is reached. This can be resolved by truncating the file
>> first, or removing the quota temporarily.
>> However, it should be reasonable that you should alwasy be able to
>> remove a file, regardless of quota limitations yes?
>> Upon delving into the code, I found the comment that an unlink may not
>> always free space. This seems reasonable on a COW filesystem, however,
>> it should not preclude a removal IMO (please correct me if i missed
>> something)
>> Personally I'm looking to try and fix this issue to allow a removal of a
>> file even when the subvol quota has been reached. I'm hoping one of the
>> current developers may be able to assist me in where to focus my
>> efforts, as I am still unable to follow exactly where a remove operation
>> would check the quota limitations.
>> Any help is appreciated.
>>
>
> For quota I think we should always allow unlink, it's not really the
> users fault
> that we sometimes won't actually remove space with unlink.  The normal
> ENOSPC
> stuff still needs to take this into account of course but for quota I
> think it's
> ok to just go over quota.  I'll look into this later this week.  Thanks,
>
> Josef
I was able to trace the error to the __unlink_start_trans, and noticed
the handling for the
ENOSPC error code. I modified this function to do the same in the case
of the EDQUOT error
(the one that gets returned when the quota is exceded). When I did this
i was able to remove a file even when the quota was reached. Submitted
the patch to the mailing list for feedback.

-Kevin
