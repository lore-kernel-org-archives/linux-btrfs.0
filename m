Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:55141 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbaFZHRu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jun 2014 03:17:50 -0400
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail.fujitsu.co.jp (Postfix) with ESMTP id A68963EE0DD
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Jun 2014 16:17:48 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.nic.fujitsu.com [10.0.50.91])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id A6474AC09DA
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Jun 2014 16:17:47 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 42477E0800A
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Jun 2014 16:17:47 +0900 (JST)
Message-ID: <53ABC90A.9040800@jp.fujitsu.com>
Date: Thu, 26 Jun 2014 16:17:30 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: <franziska.naepelt@hiperscan.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: cancel btrfs delete job
References: <1403596252.4221.9.camel@hsew-frn.HIPERSCAN>
In-Reply-To: <1403596252.4221.9.camel@hsew-frn.HIPERSCAN>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Franziska,

(2014/06/24 16:50), Franziska Näpelt wrote:
> Hi,
>
> i want to expand a btrfs filesystem. In the moment I have four 2 TB HDDs
> for one btrfs pool.
> I want to replace two of the HDDs with 3 TB devices. For this reason i
> added as first one 3 TB device. After that, i do the btrfs delete job.
> This job lasts since 4 days and it seems, that it hangs.
>
> Is it possible to cancel a btrfs delete job?
> And when so, how can i do that?

Unfortunately you can't cancel btrfs delete.

Q1. Does your environment and operations are as follows?

Environment:
  - You have six disks.
    - four 2TB disks: /dev/sd[a-d]
    - two 3TB disks: /dev/sd[ef]
  - Currently your btrfs filesystem consists of /dev/sd[a-d].
  - You want to replace /dev/sd[cd] with /dev/[ef].

Your operation:
  1. Add one 3TB disk, /dev/sde.     # It works correctly.
  2. Delete one 2TB disk, /dev/sdc   # Hanged up happens here!

Q2. Does I/Os for delete still in progress, or there is no I/O?

Thanks,
Satoru

>
> Best regards,
> Franziska
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

