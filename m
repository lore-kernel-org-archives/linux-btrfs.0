Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31673 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753640AbcIRJwX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Sep 2016 05:52:23 -0400
Subject: Re: [RFC] Preliminary BTRFS Encryption
To: dsterba@suse.cz
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <20160916084958.GA933@twin.jikos.cz>
 <313b1db1-cf32-7103-e259-328517d1c81f@oracle.com>
 <20160917203519.GE933@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Message-ID: <b57797f0-224f-4874-ce76-c7a8e9b412d3@oracle.com>
Date: Sun, 18 Sep 2016 17:54:12 +0800
MIME-Version: 1.0
In-Reply-To: <20160917203519.GE933@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/18/2016 04:35 AM, David Sterba wrote:
> On Fri, Sep 16, 2016 at 07:56:02PM +0800, Anand Jain wrote:
>>
>>
>>>> however here below is the quick example
>>>> on the cli usage. Please try out, let me know if I have missed something.
>>>>
>>>> Also would like to mention that a review from the security experts is due,
>>>> which is important and I believe those review comments can be accommodated
>>>> without major changes from here.
>>>
>>> I disagree. Others commented on the crypto stuff, I see enough points to
>>> address that would lead to major changes.
>>>
>>>> Also yes, thanks for the emails, I hear, per file encryption and inline
>>>> with vfs layer is also important, which is wip among other things in the
>>>> list.
>>>
>>> Implementing the recent vfs encryption in btrfs is ok, it's just feature
>>> parity using an existing API.
>>
>>
>>   As mentioned 'inline with vfs layer' I mean to say to use
>>   fs/crypto KPIs. Which I haven't seen what parts of the code
>>   from ext4 was made as generic KPIs. If that's getting stuff
>>   correct in the encryption related, I think it would here as well.
>
> So you were not talking about the 'fs/crypto' that was merged in 4.6?

  Looks like I am out of sync here, looks like I miss understood,
   'Implementing the recent vfs encryption in btrfs is ok'
  I was ref to fs/crypto

>>   Internal to btrfs - I had challenges to get the extents encoding
>>   done properly without bailout, and the test plan. Which I think
>>   is addressed here in this code. as mentioned.
>
> Sorry, I don't understand what you mean.

    basically making sure all the extents are really encoded, does not
    matter which crypto (unless like in compress where extents may not
    be encoded,in some situation) and having a test plan, now the test
    plan is same as
      mount option -o 'compress=ctr(aes)' with dummykey or dummy encrypt.
    for encryption.


  Thanks for integrating  most of the patches in the ML.


-Anand
