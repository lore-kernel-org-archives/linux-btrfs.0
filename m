Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:36641 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752443AbcHWChc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Aug 2016 22:37:32 -0400
Received: by mail-oi0-f45.google.com with SMTP id f189so178532731oig.3
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Aug 2016 19:37:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57BB9826.6050001@suse.com>
References: <CAJCQCtQZajfwrb-JGjLVzLk2eCvqDA_tqLbBSn81bHvT8XFFVw@mail.gmail.com>
 <57BB9826.6050001@suse.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 22 Aug 2016 20:37:30 -0600
Message-ID: <CAJCQCtS=1mmmwbMPnfh0P2CwQxdiNRa90FppkdrVw9tGwyDQdg@mail.gmail.com>
Subject: Re: possible recursive locking detected, 4.8.0-0.rc3.git0.1.fc25.x86_64+debug
To: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 22, 2016 at 6:26 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> On 8/22/16 6:51 PM, Chris Murphy wrote:
>> Trivially reproducible every boot, shortly after mount happens. Also
>> happened with rc2.
>>
>
> Yep.  We've disabled this in our kernels.  It can actually deadlock.

Interesting. I've only gotten scary looking messages so far.




-- 
Chris Murphy
