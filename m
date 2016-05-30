Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49943 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161330AbcE3QQj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 May 2016 12:16:39 -0400
Received: from pps.filterd (m0075420.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u4UGDnZI031399
	for <linux-btrfs@vger.kernel.org>; Mon, 30 May 2016 12:16:38 -0400
Message-Id: <201605301616.u4UGDnZI031399@mx0a-001b2d01.pphosted.com>
Received: from e28smtp06.in.ibm.com (e28smtp06.in.ibm.com [125.16.236.6])
	by mx0a-001b2d01.pphosted.com with ESMTP id 238j3ysxve-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 May 2016 12:16:37 -0400
Received: from localhost
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Mon, 30 May 2016 21:46:33 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 27D3C1258063
	for <linux-btrfs@vger.kernel.org>; Mon, 30 May 2016 21:48:50 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay05.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u4UGGAV021168488
	for <linux-btrfs@vger.kernel.org>; Mon, 30 May 2016 21:46:10 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u4UGGPHN023378
	for <linux-btrfs@vger.kernel.org>; Mon, 30 May 2016 21:46:28 +0530
Subject: Re: [PATCH 3/5] Btrfs: self-tests: Support non-4k page size
To: dsterba@suse.cz, Fei Fei Xu <feifeixu.sh@gmail.com>,
        linux-btrfs@vger.kernel.org, steve.capper@linaro.org,
        chandan@mykolab.com, jbacik@fb.com, dsterba@suse.com,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
References: <201605270701.u4R6xXUw031405@mx0a-001b2d01.pphosted.com>
 <201605270701.u4R6xPFu036351@mx0a-001b2d01.pphosted.com>
 <20160527192915.GX29147@twin.jikos.cz> <574A7B6E.2020904@gmail.com>
 <20160530135514.GA29147@twin.jikos.cz>
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
Date: Tue, 31 May 2016 00:16:17 +0800
MIME-Version: 1.0
In-Reply-To: <20160530135514.GA29147@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2016/5/30 21:55, David Sterba wrote:
> On Sun, May 29, 2016 at 01:17:34PM +0800, Fei Fei Xu wrote:
>>> There are more instances of the pointed style issues, please fix all of
>>> them. As the changes do not affect functionality I'll add the paches to
>>> for-next, but I'm expecting a v2.
>> Thanks, I will send out v2 soon according to all above comments.
> What's the base of the patchset? Does not apply cleanly on the current
> integration (ie. what's in master).
>
It is based on branch master commit 2f7c3a18a2dc79ddf7b , which is not 
up-to-date already.
I will send out a v2 soon to fix this.

Thanks
Feifei







