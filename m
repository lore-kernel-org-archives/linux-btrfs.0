Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15597 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553AbaFVQjE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jun 2014 12:39:04 -0400
Message-ID: <53A7069E.5010003@fb.com>
Date: Sun, 22 Jun 2014 09:38:54 -0700
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Kevin Brandstatter <icarusthecow@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Removing file = quota exceded
References: <53A62E89.6040900@gmail.com>
In-Reply-To: <53A62E89.6040900@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/21/2014 06:16 PM, Kevin Brandstatter wrote:
> so ive come accross the issue of being unable to remove a file when a
> subvolume quota is reached. This can be resolved by truncating the file
> first, or removing the quota temporarily.
> However, it should be reasonable that you should alwasy be able to
> remove a file, regardless of quota limitations yes?
> Upon delving into the code, I found the comment that an unlink may not
> always free space. This seems reasonable on a COW filesystem, however,
> it should not preclude a removal IMO (please correct me if i missed
> something)
> Personally I'm looking to try and fix this issue to allow a removal of a
> file even when the subvol quota has been reached. I'm hoping one of the
> current developers may be able to assist me in where to focus my
> efforts, as I am still unable to follow exactly where a remove operation
> would check the quota limitations.
> Any help is appreciated.
>

For quota I think we should always allow unlink, it's not really the users fault
that we sometimes won't actually remove space with unlink.  The normal ENOSPC
stuff still needs to take this into account of course but for quota I think it's
ok to just go over quota.  I'll look into this later this week.  Thanks,

Josef
