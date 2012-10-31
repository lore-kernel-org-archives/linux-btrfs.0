Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:22950 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab2JaCbv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 22:31:51 -0400
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
	by aserp1050.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9V2Vonx013730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2012 02:31:50 GMT
Message-ID: <50908D3E.3000609@oracle.com>
Date: Wed, 31 Oct 2012 10:30:22 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Nyers?= <gnyers@suse.com>
CC: Liu Bo <liub.liubo@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: How to find (out if) files sharing content?
References: <20121030162005.0308d5a2@lupus.demo.lan> <5090736C.5040609@oracle.com>
In-Reply-To: <5090736C.5040609@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/31/2012 08:40 AM, Liu Bo wrote:
> On 10/30/2012 11:20 PM, Gábor Nyers wrote:
>> Hi,
>>
>> How could one find out if 2 files share any extents on a btrfs file system?
>>
>> A more generic variation of the above: How to list files on the same
>> file system/subvolume sharing content?
One idea is to mark those cloned extents as FIEMAP_EXTENT_SHARED so that
we can go through a file to figure out how many extents are shared
through fiemap(2), and calculate the real storage(fs/subvolume) footprint
in the end.

Thanks,
-Jeff
>>
> 
> Indeed ocfs2 already has the feature where you can get shared parts via 'du',
> we're planning to support this in btrfs, too.
> 
> thanks,
> liubo
> 
>> Thanks,
>> Gábor
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 

