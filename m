Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36880 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932824AbdIYLPg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 07:15:36 -0400
Received: by mail-it0-f68.google.com with SMTP id v140so206749ita.4
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Sep 2017 04:15:36 -0700 (PDT)
Subject: Re: [PATCH v3 07/14] btrfs-progs: Doc/mkfs: Add extra condition for
 rootdir option
To: kreijack@inwind.it, Anand Jain <anand.jain@oracle.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
 <20170918072139.6300-8-quwenruo.btrfs@gmx.com>
 <7cec48bd-c007-618f-b361-d4425c757c5c@oracle.com>
 <trinity-eef9a61f-60ab-47a3-9771-d638cb0083c9-1506076766926@3c-app-mailcom-bs16>
 <9f598cb9-0267-158d-c54b-13f4372eadd5@gmail.com>
 <9652f4f4-b91c-0382-fa2a-01d45dde7fbb@gmx.com>
 <5e079410-cd64-3d40-8914-b3d48ecdebfd@gmail.com>
 <808d11d8-f22b-f26e-ba3f-7d148915db5a@gmx.com>
 <5b26f9dd-8bae-a35a-4920-4a617b52f9f7@oracle.com>
 <c0652f30-5ca7-b917-7f15-78dfdb2e1205@libero.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7af34399-f969-dfe5-d006-3e7fb293b9df@gmail.com>
Date: Mon, 25 Sep 2017 07:15:30 -0400
MIME-Version: 1.0
In-Reply-To: <c0652f30-5ca7-b917-7f15-78dfdb2e1205@libero.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-24 10:08, Goffredo Baroncelli wrote:
> On 09/24/2017 12:10 PM, Anand Jain wrote:
>>
>>
>>> All my points are clear for this patchset:
>>> I know I removed one function, and my reason is:
>>> 1) No or little usage
>>>      And it's anti intuition.
>>> 2) Dead code (not tested nor well documented)
>>> 3) Possible workaround
>>>
>>> I can add several extra reasons as I stated before, but number of reasons won't validate anything anyway.
>>
>>   End user convenience wins over the developer's technical difficulties.
> 
> Sorry, but I have to agree with Qu; there is no a big demand (other than Austin) for this functionality; even you stated that "...at some point it may..."; until now the UI is quite unfriendly (we should use a big enough device, and then cut it by hand on the basis of the output of mkfs.btrfs)...
I will comment that I agree that it should not be the default.  It's not 
intuitive for most people, and as you say it's a niche feature.  Just 
removing it completely though with the above argument sounds very much 
like trying to meet quotas for coding.
> 
> I fear that this is another feature which increase the complexity of btrfs (and tools) with little or none usage....
On average?  It only increases the complexity of mkfs once there's a fix 
for the (theoretically trivial to fix) issue with it ignoring the fact 
that the first 1MB of space is supposed to be untouched by BTRFS.
> 
> The work of Qu is a nice cleanup; I hope that this will be the direction which BTRFS will takes: removing of "strange/unused" features improving the reliability of the others.
The two are not inherently interdependent, and that argument doesn't 
exactly hold up to scrutiny considering that mkfs is already perfectly 
reliable even with this feature, and it does not compromise the 
reliability of other features (again, once you fix the usage of the 
reserved area at the beginning of the image).
