Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i2.italiaonline.it ([212.48.25.204]:51200 "EHLO
	libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751558AbbHSUwm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 16:52:42 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [BUG][v4.2-rc7] Problem replacing a "missing" disk for a
 raid5-degraded filesystem
References: <55D4B8B8.3000806@libero.it>
 <20150819184155.GA25918@huxley.event.rightround.com>
 <20150819202812.GA3294@huxley.event.rightround.com>
To: Omar Sandoval <osandov@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <55D4EC98.40609@inwind.it>
Date: Wed, 19 Aug 2015 22:52:40 +0200
MIME-Version: 1.0
In-Reply-To: <20150819202812.GA3294@huxley.event.rightround.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-08-19 22:28, Omar Sandoval wrote:
> On Wed, Aug 19, 2015 at 11:41:55AM -0700, Omar Sandoval wrote:
>> On Wed, Aug 19, 2015 at 07:11:20PM +0200, Goffredo Baroncelli wrote:
>>> Hi all,
>>>
>>> playing with raid5 and "btrfs replace" I found a BUG. Basically it seems that if I try to replace a "missing" disk of a "degraded" filesystem I got a kernel BUG. This is reproducible at 100% for me.
>>
>> Hi, Goffredo, this is a known bug. I have a fix here:
>> http://www.spinics.net/lists/linux-btrfs/msg44874.html
>> I'll bug Chris to get this in for 4.3. Let me know if you feel like
>> testing it out and I can add your Tested-by.
> 
> Ah, I didn't notice, but it looks like he already pulled it into his
> integration-4.3 branch.

It solve; thanks for working on that so if you want you have my 

Tested-by: Goffredo Baroncelli <kreijack@inwind.it>


> 
>> Btw, just a heads up, Gmail is convinced that you're spam, it sounds
>> like you're failing your domain's DMARC checks.

It is not the first time that someone told me; I would like to use a gmail account, unfortunately gmail make a mess with the email (if I send an email to the mailing list and to me, gmail collapses the two....)

> 
> Thanks,
> 




-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
