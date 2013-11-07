Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17550 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab3KGLNQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Nov 2013 06:13:16 -0500
Message-ID: <527B77C6.1090803@oracle.com>
Date: Thu, 07 Nov 2013 19:21:42 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs@vger.kernel.org, jbacik@fusionio.com, zab@redhat.com,
        dsterba@suse.cz
Subject: Re: [PATCH 1/3] btrfs-progs: mechanism to fetch fsinfo from btrfs-control
 v3
In-Reply-To: <527B65A2.3020703@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1383818503-29607-1-git-send-email-anand.jain@oracle.com>
 <527B65A2.3020703@giantdisaster.de>



On 11/07/2013 06:04 PM, Stefan Behrens wrote:
> On Thu,  7 Nov 2013 18:01:41 +0800, Anand Jain wrote:
>> +	*out_fslist = malloc(sz);
>> +	if (*out_fslist == NULL) {
>> +		ret = -ENOMEM;
>> +		goto out;
>> +	}
>> +	memcpy(*out_fslist, fslist, sz);
>> +	ret = 0;
>> +out:
>> +	free(fsargs_saved);
>> +	close(fd);
>> +	return 0;
>> +}
>
> return ret;

  nice catch. Thanks.
  Also fsargs_saved wasn't initialized along with one of early goto out.
  I have fixed it as well in v4 which was sent out.

Thanks, Anand

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
