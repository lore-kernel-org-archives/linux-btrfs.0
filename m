Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30354 "EHLO
	m0001303.ppops.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753237AbbINPez (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Sep 2015 11:34:55 -0400
Subject: Re: Horrible dbench performance
To: <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <20150914152820.GA25610@localhost.localdomain>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <55F6E91A.5020203@fb.com>
Date: Mon, 14 Sep 2015 11:34:50 -0400
MIME-Version: 1.0
In-Reply-To: <20150914152820.GA25610@localhost.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/14/2015 11:28 AM, Liu Bo wrote:
> Hi,
>
> Both [1] and [2] had run dbench on btrfs with fast storage, and
> showed bad numbers, I got an impression that after refractoring btree lock to
> smart rwlock, we have mitigated this issue..
>
> Not got a fast-enough ssd handy, does anyone confirm the result showed
> in those link?
>
> [1]:https://lkml.org/lkml/2015/4/29/793
> [2]:https://lkml.org/lkml/2015/8/21/22
>
> Thanks,
>

I'll try after I'm finished with my ENOSPC rework.  Thanks,

Josef

