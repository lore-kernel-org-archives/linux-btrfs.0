Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41413 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbbHQLSE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Aug 2015 07:18:04 -0400
Message-ID: <55D1C2DC.1060608@oracle.com>
Date: Mon, 17 Aug 2015 19:17:48 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: kreijack@inwind.it, linux-btrfs@vger.kernel.org
CC: clm@fb.com, dsterba@suse.cz
Subject: Re: [PATCH 2/2] btrfs-progs: device delete to accept devid
In-Reply-To: <55D1869A.8080802@inwind.it>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1439548611-29730-1-git-send-email-anand.jain@oracle.com>
 <1439548611-29730-3-git-send-email-anand.jain@oracle.com>
 <55D1869A.8080802@inwind.it>



>>
>> -*remove* <dev> [<dev>...] <path>::
>> +*remove* <dev>|<devid> [<dev>|<devid>...] <path>::
>>   Remove device(s) from a filesystem identified by <path>.
>>
>>   *delete* <dev> [<dev>...] <path>::
> also here is missing <devid> (below you added)

  Thank you. Got this fixed.
