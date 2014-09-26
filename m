Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21757 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753984AbaIZNAy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Sep 2014 09:00:54 -0400
Message-ID: <54256381.1070608@fb.com>
Date: Fri, 26 Sep 2014 09:00:49 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Zach Brown <zab@zabbo.net>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: let btrfs-image actually work on a balanced
 fs
References: <1411678015-5928-1-git-send-email-jbacik@fb.com> <20140925214419.GO920@lenny.home.zabbo.net>
In-Reply-To: <20140925214419.GO920@lenny.home.zabbo.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/25/2014 05:44 PM, Zach Brown wrote:
>> --- a/btrfs-image.c
>> +++ b/btrfs-image.c
>> @@ -1020,6 +1020,9 @@ static int copy_tree_blocks(struct btrfs_root *root, struct extent_buffer *eb,
>>   	int i = 0;
>>   	int ret;
>>
>> +	if (btrfs_header_bytenr(eb) == 65536)
>> +		printf("We have bytenr 65536, belongs to %llu, level %d\n",
>> +		       btrfs_header_owner(eb), btrfs_header_level(eb));
>>   	ret = add_extent(btrfs_header_bytenr(eb), root->leafsize, metadump, 0);
>>   	if (ret) {
>>   		fprintf(stderr, "Error adding metadata block\n");
>
> Did you mean to leave that in?  The raw super offset sure makes it look
> like debugging output.
>

Sigh sorry, thought I culled everything.  Thanks,

Josef

