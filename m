Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:35414 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3CJRv0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 13:51:26 -0400
Received: by mail-we0-f176.google.com with SMTP id s43so2807069wey.35
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2013 10:51:25 -0700 (PDT)
Message-ID: <513CC87B.50005@gmail.com>
Date: Sun, 10 Mar 2013 18:52:59 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, kreijack@inwind.it,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] Add man page description for nCmSpP replication levels
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk> <1362861071-12589-6-git-send-email-hugo@carfax.org.uk> <513C9228.6020703@gmail.com> <20130310172009.GC30771@carfax.org.uk>
In-Reply-To: <20130310172009.GC30771@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/10/2013 06:20 PM, Hugo Mills wrote:
> On Sun, Mar 10, 2013 at 03:01:12PM +0100, Goffredo Baroncelli wrote:
>> Hi Hugo,
>>
>> could you please add also to the btrfs man page a section where are
>> described the nCmSpP levels ?
>>
>> Thanks.
>> GB
>>
>>
>>
>> On 03/09/2013 09:31 PM, Hugo Mills wrote:
>>> Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
>>> ---
> [snip]
>>> diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
>>> index 41163e0..2e71e65 100644
>>> --- a/man/mkfs.btrfs.8.in
>>> +++ b/man/mkfs.btrfs.8.in
>>> @@ -37,7 +37,29 @@ mkfs.btrfs uses all the available storage for the filesystem.
>>>  .TP
>>>  \fB\-d\fR, \fB\-\-data \fItype\fR
>>>  Specify how the data must be spanned across the devices specified. Valid
>>> -values are raid0, raid1, raid10 or single.
> 
>    Like here?

Yes, I thought about a section which lists the allowable raid level.

> 
>>> +values are of the form <n>C[D][<m>S[<p>P]], where <n> is the number of copies
>>> +of data, <m> is the number of stripes per copy, and <p> is the number of parity
>>> +stripes. The <m> parameter must (currently) be a literal "m", indicating that
>>> +as many stripes as possible will be used. The letter D may be added to the
>>> +number of copies, to indicate non-redundant copies (e.g. on the same device).
>>> +
>>> +The following deprecated values may also be used:
>>> +.RS 16
>>> +.P
>>> +single	1C
>>> +.P
>>> +raid0	1CmS
>>> +.P
>>> +raid1	2C
>>> +.P
>>> +dup		2CD
>>> +.P
>>> +raid10	2CmS
>>> +.P
>>> +raid5	1CmS1P
>>> +.P
>>> +raid6	1CmS2P
>>> +.RS -16
>>>  .TP
>>>  \fB\-f\fR
>>>  Force overwrite when an existing filesystem is detected on the device.
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
