Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16801 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbaCUSY5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Mar 2014 14:24:57 -0400
Message-ID: <532C83ED.3040103@fb.com>
Date: Fri, 21 Mar 2014 14:24:45 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs deadlock (3.14 kernel)
References: <20140321060632.GD28005@merlins.org>
In-Reply-To: <20140321060632.GD28005@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/21/2014 02:06 AM, Marc MERLIN wrote:
> After 1.5 days of running, the machine I was doing btrfs receive on got
> stuck with this (note, the traces are not all the same).
>
> The machine is not dead, but any IO that goes through btrfs seems dead.
>
> If you want Sysrq-W, let me know.
>
> Is thre anything I can try to unwedge or prevent this problem next time I try?
>

Sysrq+w would be nice so I can see what everybody is doing.  Thanks,

Josef

