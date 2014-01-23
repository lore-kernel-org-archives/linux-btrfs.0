Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28789 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932104AbaAWOTR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 09:19:17 -0500
Message-ID: <52E124E0.4040702@fb.com>
Date: Thu, 23 Jan 2014 09:19:12 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Miguel_Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>,
        "list, btrfs" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send 3.11 vs 3.12
References: <52E0DF6B.2080200@friendlyvirus.org>
In-Reply-To: <52E0DF6B.2080200@friendlyvirus.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/23/2014 04:22 AM, Miguel Negrão wrote:
> Hi
>
> Sending snapshots incrementally started to fail on the 3.11 kernel on my
> system after I once booted with 3.12 and did the incremental send of a
> snapshot. After when I booted back to 3.11 I can no longer send the
> snapshots incrementally based on the last one sent (I could still send
> based on the last one sent from 3.11), although booting again to 3.12 I
> can send me fine again.
>
> It this intenteded ?
This is definitely not intended, I will look into why this is 
happening.  Thanks,

Josef
