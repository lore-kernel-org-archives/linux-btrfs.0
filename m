Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33496 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754719AbaCNOoj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 10:44:39 -0400
Message-ID: <532315D0.7090805@fb.com>
Date: Fri, 14 Mar 2014 10:44:32 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: remove transaction from send
References: <1394739733-500-1-git-send-email-jbacik@fb.com> <892DD229-24DA-439C-B431-2761E51A9937@gmail.com>
In-Reply-To: <892DD229-24DA-439C-B431-2761E51A9937@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/14/2014 09:13 AM, Wang Shilong wrote:
>> Lets try this again.  We can deadlock the box if we send on a box and try to
>> write onto the same fs with the app that is trying to listen to the send pipe.
>> This is because the writer could get stuck waiting for a transaction commit
>> which is being blocked by the send.  So fix this by making sure looking at the
>> commit roots is always going to be consistent.  We do this by keeping track of
>> which roots need to have their commit roots swapped during commit, and then
>> taking the commit_root_sem and swapping them all at once.  Then make sure we
>> take a read lock on the commit_root_sem in cases where we search the commit root
>> to make sure we're always looking at a consistent view of the commit roots.
>> Previously we had problems with this because we would swap a fs tree commit root
>> and then swap the extent tree commit root independently which would cause the
>> backref walking code to screw up sometimes.  With this patch we no longer
>> deadlock and pass all the weird send/receive corner cases.  Thanks,
> 
> Now btrfs send are alway searching commit root! Your codes only seems to protect backref codes,
> it reduce transaction blocked but make it not safe as we have discussed before.
> 
>

I was trying to remember why we didn't like this solution before but I
couldn't come up with anything.  Apparently I haven't completely fixed
the problem yet so stay tuned for what I do next ;).  Thanks,

Josef

