Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:49164 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1038476AbdDULNQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Apr 2017 07:13:16 -0400
Received: from [IPv6:2001:828:13c8:10b::c] (blackbox.bofh.hq.mendix.net [IPv6:2001:828:13c8:10b::c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id D69706004A
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Apr 2017 13:13:13 +0200 (CEST)
Subject: Re: Experiences with metadata balance/convert
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <78d61749-ec9c-1cc3-196f-5330489e2b3e@mendix.com>
 <f0c293aa-06b9-3478-2d72-905797708ec9@mendix.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <6054483d-437f-e8d2-f74b-7560c9e0819d@mendix.com>
Date: Fri, 21 Apr 2017 13:13:13 +0200
MIME-Version: 1.0
In-Reply-To: <f0c293aa-06b9-3478-2d72-905797708ec9@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/21/2017 12:31 PM, Hans van Kranenburg wrote:
> Doh,
> 
> On 04/21/2017 12:26 PM, Hans van Kranenburg wrote:
>> [...]
>>
>> == Thinking out of the box ==
>>
>> Technically, converting from DUP to single could also mean:
>> * Flipping one bit in the block group type flags to 0 for each block
>> group item
>> * Flipping one bit in the chunk type flags and removing 1 stripe struct
>> for each metadata chunk item
>> * Removing the
> 
> Removing the dev extent objects for all removed stripes from the dev tree.
> 
>> * Anything else?
>>
>> How feasible would it be to write btrfs-progs style conversion to do this?

>From the feedback on IRC already, to clear things up:

I'm *not* proposing/asking for this kind of functionality to be
officially available or added to mainline btrfs-progs and be supported
for every user to use. I understand that's a whole different kind of
discussion.

I only mean... would there be any great show-stopper for this idea which
would mean I couldn't technically do it myself in a 'one-off' style.

-- 
Hans van Kranenburg
