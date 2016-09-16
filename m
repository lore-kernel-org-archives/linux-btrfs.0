Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18720 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933782AbcIPLyR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 07:54:17 -0400
Subject: Re: [RFC] Preliminary BTRFS Encryption
To: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.cz
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <20160916084958.GA933@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <313b1db1-cf32-7103-e259-328517d1c81f@oracle.com>
Date: Fri, 16 Sep 2016 19:56:02 +0800
MIME-Version: 1.0
In-Reply-To: <20160916084958.GA933@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>> however here below is the quick example
>> on the cli usage. Please try out, let me know if I have missed something.
>>
>> Also would like to mention that a review from the security experts is due,
>> which is important and I believe those review comments can be accommodated
>> without major changes from here.
>
> I disagree. Others commented on the crypto stuff, I see enough points to
> address that would lead to major changes.
>
>> Also yes, thanks for the emails, I hear, per file encryption and inline
>> with vfs layer is also important, which is wip among other things in the
>> list.
>
> Implementing the recent vfs encryption in btrfs is ok, it's just feature
> parity using an existing API.


  As mentioned 'inline with vfs layer' I mean to say to use
  fs/crypto KPIs. Which I haven't seen what parts of the code
  from ext4 was made as generic KPIs. If that's getting stuff
  correct in the encryption related, I think it would here as well.

  Internal to btrfs - I had challenges to get the extents encoding
  done properly without bailout, and the test plan. Which I think
  is addressed here in this code. as mentioned.



> And a note from me with maintainer's hat on, there are enough pending
> patches and patchsets that need review, and bugs to fix, I'm not going
> to spend time on something that we don't need at the moment if there are
> alternatives.

  Honestly I agree. I even suggested but I had no choice.


PS:
  Pls, feel free to flame on the (raid) patches if its not correct,
  because its rather more productive than no reply.


Thanks, Anand
