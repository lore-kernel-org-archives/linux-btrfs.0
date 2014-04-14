Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3925 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753489AbaDNNiu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 09:38:50 -0400
Message-ID: <534BE4F6.9050300@fb.com>
Date: Mon, 14 Apr 2014 09:39:02 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>, <harald@redhat.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs: allow mounting btrfs subvolumes with different ro/rw options
References: <20140414131010.GA12764@mwanda>
In-Reply-To: <20140414131010.GA12764@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/14/2014 09:10 AM, Dan Carpenter wrote:
> Hello Harald Hoyer,
>
> The patch 0723a0473fb4: "btrfs: allow mounting btrfs subvolumes with
> different ro/rw options" from Nov 19, 2013, leads to the following
> static checker warning:

I'll fix this one up.  Harald's email has changed and I should have 
pulled the patch in long ago.

Thanks Dan!

-chris
