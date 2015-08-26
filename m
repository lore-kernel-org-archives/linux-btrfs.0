Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14443 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751860AbbHZTG1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 15:06:27 -0400
Message-ID: <55DE0E2D.6000001@fb.com>
Date: Wed, 26 Aug 2015 15:06:21 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: deal with error on secondary log properly
References: <1440522583-32120-1-git-send-email-jbacik@fb.com> <20150826020609.GB5614@localhost.localdomain>
In-Reply-To: <20150826020609.GB5614@localhost.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/25/2015 10:06 PM, Liu Bo wrote:
> On Tue, Aug 25, 2015 at 01:09:43PM -0400, Josef Bacik wrote:
>> If we have an fsync at the same time in two seperate subvolumes we could end up
>> with the tree log pointing at invalid blocks.  We need to notice if our writeout
>
> Mind to share more details of the problem?
>

It's the problem Filipe was trying to solve.  Say we fsync() on two 
different subvols, one of them will race in and be the one who commits 
the log root tree.  So process A waits on process B to add its log to 
the log root tree and write out its log.  If we get an IO error while 
writing out the log the log root tree will be pointing to invalid crap, 
and we also won't return an error back to userspace.  We need to notice 
if there was an error, turn on the transaction commit stuff since we've 
already updated the the log root tree with our subvol log so we don't 
get garbage on the disk, and we need to return an error to process B. 
Thanks,

Josef

