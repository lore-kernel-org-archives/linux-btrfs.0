Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:63467 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab3FXQmR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Jun 2013 12:42:17 -0400
Message-ID: <51C876E5.4060802@giantdisaster.de>
Date: Mon, 24 Jun 2013 18:42:13 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 1/8] Btrfs: introduce a tree for items that map UUIDs
 to something
References: <cover.1371749051.git.sbehrens@giantdisaster.de> <ef484aa41751485fc6301ce78b5e3cddaa3f9a52.1371749051.git.sbehrens@giantdisaster.de> <20130620194704.GC32674@lenny.home.zabbo.net> <51C41318.8070703@giantdisaster.de> <20130621161138.GA25321@lenny.home.zabbo.net>
In-Reply-To: <20130621161138.GA25321@lenny.home.zabbo.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 21 Jun 2013 09:11:38 -0700, Zach Brown wrote:
>>>> +	offset = (unsigned long)ptr;
>>>> +	while (sub_item_len > 0) {
>>>> +		u64 data;
>>>> +
>>>> +		read_extent_buffer(eb, &data, offset, sizeof(data));
>>>> +		data = le64_to_cpu(data);
>>>> +		if (data == subid) {
>>>> +			ret = 0;
>>>> +			break;
>>>> +		}
>>>> +		offset += sizeof(data);
>>>> +		sub_item_len--;
>>>> +	}
>>>
>>> This could be cleaned up a bit by comparing an on-stack little-endian
>>> input subid with each little-endian subid in the item with
>>> memcmp_extent_buffer().
>>
>> This would save some CPU cycles for the repeated le64_to_cpu() and for
>> the memcpy(). The number of lines of code is equal for both ways.
> 
> Hmm?  It would be many fewer lines of code.

Are you thinking of something shorter than the following?

offset = (unsigned long)ptr;
subid = cpu_to_le64(subid);
while (sub_item_len > 0) {
	if (memcmp_extent_buffer(eb, &subid, offset,
				 sizeof(subid)) == 0) {
		ret = 0;
		break;
	}
	offset += sizeof(subid);
	sub_item_len--;
}

