Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28267 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751242AbbESSHw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 May 2015 14:07:52 -0400
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t4JI4EsG017620
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2015 11:07:51 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1ug8xp8c0j-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2015 11:07:51 -0700
Message-ID: <555B7BF4.40200@fb.com>
Date: Tue, 19 May 2015 14:07:48 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: set UNWRITTEN for prealloc'ed extents in fiemap
References: <1432046644-6981-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1432046644-6981-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/19/2015 10:44 AM, Josef Bacik wrote:
> We should be doing this, it's weird we hadn't been doing this.

Isn't there an xfstest we should be failing because of this?

-chris

