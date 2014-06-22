Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:59077 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaFVR4b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jun 2014 13:56:31 -0400
Received: by mail-ig0-f169.google.com with SMTP id c1so2279477igq.4
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Jun 2014 10:56:31 -0700 (PDT)
Message-ID: <53A718CE.9030701@gmail.com>
Date: Sun, 22 Jun 2014 12:56:30 -0500
From: Kevin Brandstatter <icarusthecow@gmail.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: Removing file = quota exceded
References: <53A62E89.6040900@gmail.com> <53A7069E.5010003@fb.com>
In-Reply-To: <53A7069E.5010003@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One thing i note is that I can unlink from a full filesystem.
I tested it by writing a file until the device ran out of space, and
then rm it,
the same method that i used to cause the disk quota error, and it was
able to remove without
issue.

-Kevin

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

