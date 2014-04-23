Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45746 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752395AbaDWOIc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 10:08:32 -0400
Message-ID: <5357C985.3010805@fb.com>
Date: Wed, 23 Apr 2014 10:09:09 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Xavier Bassery <xavier@bartica.org>,
        <linux-btrfs@vger.kernel.org>, Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH] btrfs-progs: read global reserve size from space infos
References: <1398172800-19548-1-git-send-email-dsterba@suse.cz> <20140422140900.GA30423@carfax.org.uk> <20140422171234.51a9fffb@renoir.lan> <20140423133035.GC2027@suse.cz>
In-Reply-To: <20140423133035.GC2027@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/23/2014 09:30 AM, David Sterba wrote:
> On Tue, Apr 22, 2014 at 05:12:34PM +0200, Xavier Bassery wrote:
>>>> Global_rsv or GlobalRsv or Globalrsv or something else?
>>>
>>>     Personally, I'd probably go for the camel case GlobalRsv, or
>>> possibly GlbReserve. (Assuming that it's going to be only a single
>>> token without whitespace to make parsing easier).
>>
>> I second the camel case (if whitespace is to be avoided) and if I may
>> put my two cents in, what about GlobalReserve?
>> As pointed by Hugo, this has the same length as Data+Metadata.
>
> Sounds good, thank you both for input.

GlobalReserve gets my vote too.

-chris

