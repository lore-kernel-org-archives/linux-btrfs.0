Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7620 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148AbaDFX5Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 6 Apr 2014 19:57:25 -0400
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s36NokWx019733
	for <linux-btrfs@vger.kernel.org>; Sun, 6 Apr 2014 16:57:24 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1k259sd09b-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 06 Apr 2014 16:57:24 -0700
Message-ID: <5341E9E5.7070108@fb.com>
Date: Sun, 6 Apr 2014 19:57:25 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: don't clear uptodate if the eb is under IO
References: <1396040847-6026-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1396040847-6026-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/28/2014 05:07 PM, Josef Bacik wrote:
> So I have an awful exercise script that will run snapshot, balance and
> send/receive in parallel.  This sometimes would crash spectacularly and when it
> came back up the fs would be completely hosed.  Turns out this is because of a
> bad interaction of balance and send/receive.  Send will hold onto its entire
> path for the whole send, but its blocks could get relocated out from underneath
> it, and because it doesn't old tree locks theres nothing to keep this from
> happening.  So it will go to read in a slot with an old transid, and we could
> have re-allocated this block for something else and it could have a completely
> different transid.  But because we think it is invalid we clear uptodate and
> re-read in the block.  If we do this before we actually write out the new block
> we could write back stale data to the fs, and boom we're screwed.
>
> Now we definitely need to fix this disconnect between send and balance, but we
> really really need to not allow ourselves to accidently read in stale data over
> new data.  So make sure we check if the extent buffer is not under io before
> clearing uptodate, this will kick back EIO to the caller instead of reading in
> stale data and keep us from corrupting the fs.  Thanks,

Josef is on vacation, so I'm posting a short follow up:

> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 0148999..6f035ee 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -5609,7 +5609,9 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
>   			NULL);
>   	sort_clone_roots = 1;
>
> +	current->journal_info = (void *)BTRFS_SEND_TRANS_STUB;
>   	ret = send_subvol(sctx);
> +	current->journal_info = NULL;
>   	if (ret < 0)
>   		goto out;
>

This confuses start_transaction() which tries to dereference whatever it 
finds in current->journal_info.  It just needs an extra check against 
BTRFS_SEND_TRANS_STUB.

I'm folding the fix into his original patch in my tree, and rerunning 
tests here.

-chris

