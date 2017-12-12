Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33897 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752598AbdLLQIX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 11:08:23 -0500
Subject: Re: xfstests/btrfs/100 and 151 failure
From: Nikolay Borisov <nborisov@suse.com>
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
References: <CAKuJGC9ASgDD2jneSOJwR8ba0e8QFvhuA1KXzrCDOK-Jgyri8A@mail.gmail.com>
 <d3b02eb4-9ca2-5451-9cf8-1aef2863f19f@suse.com>
Message-ID: <80201d7c-8406-6f9e-9eb9-5e5e601b6697@suse.com>
Date: Tue, 12 Dec 2017 18:08:21 +0200
MIME-Version: 1.0
In-Reply-To: <d3b02eb4-9ca2-5451-9cf8-1aef2863f19f@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12.12.2017 18:06, Nikolay Borisov wrote:
> 
> 
> On 12.12.2017 17:55, Lakshmipathi.G wrote:
>> Hi.
>>
>> While checking with latest misc-next branch from btrfs-devel.
>> btrfs/100 and 151 failed.
>> Details available on below bugzilla links. thanks
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=198085
>> https://bugzilla.kernel.org/show_bug.cgi?id=198087
> 
> I've been running tests on that branch + some custom patches and haven't
> seen failure on those 2 tests.

Actually 151 has been failing for me as well but not 100

> 
>>
>> ----
>> Cheers,
>> Lakshmipathi.G
>> http://www.giis.co.in http://www.webminal.org
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
