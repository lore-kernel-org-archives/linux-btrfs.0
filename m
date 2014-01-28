Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:47183 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaA1Mvn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 07:51:43 -0500
Received: by mail-vc0-f169.google.com with SMTP id hq11so210366vcb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jan 2014 04:51:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52E77879.1080000@oracle.com>
References: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
	<52E77879.1080000@oracle.com>
Date: Tue, 28 Jan 2014 13:51:42 +0100
Message-ID: <CACeaM8_x392hkWq0OxHWspBYfqron3Kq-6KSwp4D+1L_CPX_rQ@mail.gmail.com>
Subject: Re: [PATCH RFCv2] new ioctl TREE_SEARCH_V2
From: Gerhard Heift <gerhard@heift.name>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-01-28 Anand Jain <Anand.Jain@oracle.com>:
>  You may have covered this but its not explicit.
>  Could you write few lines on whats wrong with the current
>  TREE SEARCH and how V2 is helping.

I wrote a program, which basically calculates a checksum over a files
content checksums. First I got the fiemap of the file and then
searched for the csum items with

  objectid: BTRFS_EXTENT_CSUM_OBJECTID;
  type: BTRFS_EXTENT_CSUM_KEY;
  offset: [physical pages]

This worked good but sometimes resulted in a empty items, because they
did not fit in the given buffer of 3992 bytes, specially for large
files. As David worte in [1], EXTENT_CSUM items seem to cap at 16k. A
simple solution would have been to just expand the static buffer size,
but with this solution, the user can decide how much buffer is needed.
Either way, directly copying the data to userspace with
read_extent_buffer_to_user (as suggested in [2]) will eliminate the
double-copy of data and needs less memory in the kernel.

[1] http://article.gmane.org/gmane.comp.file-systems.btrfs/31765
[2] http://article.gmane.org/gmane.comp.file-systems.btrfs/32064

> Thanks, Anand
>
>
>
>
> On 01/27/2014 09:28 PM, Gerhard Heift wrote:
>>
>> This patch series adds a new ioctl TREE_SEARCH_V2 with which we could
>> store the
>> results in a varying buffer. Now even items larger than 3992 bytes or a
>> large
>> amount of items can be returned.
>>
>> I have a few questions:
>>    Which value should I assign to TREE_SEARCH_V2?
>>    Should we limit the buffer size?
>>    What about documentation?
>>
>> Changelog
>>
>> RFCv2
>>    * fixed a build bug caused by using a wrong patch
>>    * added a patch to expand buffer lifetime
>>
>> Gerhard
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
