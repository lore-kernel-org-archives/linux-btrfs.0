Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41618 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753903AbcHEPPY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Aug 2016 11:15:24 -0400
Subject: Re: Input/output error, nothing appended in dmesg
To: Tomasz Chmielewski <tch@virtall.com>
References: <ff95214f4e2dd819d42dee7dff5f6580@admin.virtall.com>
 <9fdb317f-9209-d1a7-3e1e-7ab4f5b09c8d@fb.com>
 <fe633b0f3cc110bc5520db164e54dfe3@admin.virtall.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <98e070f7-2787-9df4-c1b8-ae8005c039ec@fb.com>
Date: Fri, 5 Aug 2016 11:15:15 -0400
MIME-Version: 1.0
In-Reply-To: <fe633b0f3cc110bc5520db164e54dfe3@admin.virtall.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/05/2016 10:44 AM, Tomasz Chmielewski wrote:
> On 2016-08-05 23:26, Chris Mason wrote:
>> On 08/05/2016 07:42 AM, Tomasz Chmielewski wrote:
>>> I'm getting occasional (every few weeks) input/output errors on a btrfs
>>> filesystem with compress-force=zlib, running on Amazon EC2, with 4.5.2
>>> kernel:
>>>
>>> # cat 2016-08-02/serverX/syslog.log
>>> cat: 2016-08-02/serverX/syslog.log: Input/output error
>>
>> How big is the file?  We had one bug with inline files that might have
>> caused this.
>
> This one's tiny, 158137 bytes.

Too big for the known problem though.  Still, can you btrfs-debug-tree 
and just make sure it doesn't have inline items?

-chris
