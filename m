Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39818 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932452AbcHINsX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Aug 2016 09:48:23 -0400
Subject: Re: Issue: errno:28 (No space left on device)
To: Thomas <c.monty@web.de>, <linux-btrfs@vger.kernel.org>
References: <e4671ca6-38bc-ce32-0bc9-c1e7bc9873cd@web.de>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <c68c0215-0ba0-67ac-55de-a914e1d9ea8d@fb.com>
Date: Tue, 9 Aug 2016 09:47:58 -0400
MIME-Version: 1.0
In-Reply-To: <e4671ca6-38bc-ce32-0bc9-c1e7bc9873cd@web.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/09/2016 07:50 AM, Thomas wrote:
> Hello!
>
> I'm facing a severe issue with Debian installation using BTRFS:
> errno:28 (No space left on device)
>
> After a few minutes of system usage I get this error message for any action,
> means there's really no disk space left.
>
> However, the output of btrfs fi usage / reports that ~10% of disk space should
> be free.
>
> I have 2 questions:
> 1. Why is the OS reporting an error "Issue: errno:28 (No space left on device)"
> whereas "btrfs fi usage" reports free space?
> 2. How can I solve this issue w/o the possibility of extending the partition?
>

Please try linus's latest tree, it has some enospc accounting fixes that have 
recently gone in.  Thanks,

Josef
