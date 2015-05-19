Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9515 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092AbbESTUt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 May 2015 15:20:49 -0400
Received: from pps.filterd (m0004346 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t4JJKRC5017646
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2015 12:20:48 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 1ug9640bcd-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2015 12:20:48 -0700
Message-ID: <555B8D0B.9020609@fb.com>
Date: Tue, 19 May 2015 15:20:43 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: set UNWRITTEN for prealloc'ed extents in fiemap
References: <1432046644-6981-1-git-send-email-jbacik@fb.com> <555B7BF4.40200@fb.com>
In-Reply-To: <555B7BF4.40200@fb.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/19/2015 02:07 PM, Chris Mason wrote:
> On 05/19/2015 10:44 AM, Josef Bacik wrote:
>> We should be doing this, it's weird we hadn't been doing this.
>
> Isn't there an xfstest we should be failing because of this?
>

You'd think that but apparently the test that does my fiemap-tester 
specifically disables using prealloc'ed extents, so I've added another 
test to do the tester with prealloc, which we pass with this patch.  Thanks,

Josef

