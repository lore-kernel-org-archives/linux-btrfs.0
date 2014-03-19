Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31480 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964900AbaCSQRX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 12:17:23 -0400
Message-ID: <5329C3B8.8050204@fb.com>
Date: Wed, 19 Mar 2014 12:20:08 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-rmw-2: page allocation failure: order:1, mode:0x8020
References: <20140319154513.GQ6143@merlins.org>
In-Reply-To: <20140319154513.GQ6143@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/19/2014 11:45 AM, Marc MERLIN wrote:
> My server died last night during a btrfs send/receive to a btrfs radi5 array
>
> Here are the logs. Is this anything known or with a possible workaround?
>
> Thanks,
> Marc
>
> btrfs-rmw-2: page allocation failure: order:1, mode:0x8020

This is an order 1 atomic allocation from the mvs driver, we really 
should not be depending on that to get IO done.  A quick search and it 
looks like we're allocating MVS_SLOT_BUF_SZ (8192) bytes.

You could try bumping the lowmem reserves.

-chris
