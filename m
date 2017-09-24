Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17-i6.italiaonline.it ([213.209.14.17]:56417 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752288AbdIXOIG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Sep 2017 10:08:06 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH v3 07/14] btrfs-progs: Doc/mkfs: Add extra condition for
 rootdir option
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
References: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
 <20170918072139.6300-8-quwenruo.btrfs@gmx.com>
 <7cec48bd-c007-618f-b361-d4425c757c5c@oracle.com>
 <trinity-eef9a61f-60ab-47a3-9771-d638cb0083c9-1506076766926@3c-app-mailcom-bs16>
 <9f598cb9-0267-158d-c54b-13f4372eadd5@gmail.com>
 <9652f4f4-b91c-0382-fa2a-01d45dde7fbb@gmx.com>
 <5e079410-cd64-3d40-8914-b3d48ecdebfd@gmail.com>
 <808d11d8-f22b-f26e-ba3f-7d148915db5a@gmx.com>
 <5b26f9dd-8bae-a35a-4920-4a617b52f9f7@oracle.com>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <c0652f30-5ca7-b917-7f15-78dfdb2e1205@libero.it>
Date: Sun, 24 Sep 2017 16:08:00 +0200
MIME-Version: 1.0
In-Reply-To: <5b26f9dd-8bae-a35a-4920-4a617b52f9f7@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/24/2017 12:10 PM, Anand Jain wrote:
> 
> 
>> All my points are clear for this patchset:
>> I know I removed one function, and my reason is:
>> 1) No or little usage
>>     And it's anti intuition.
>> 2) Dead code (not tested nor well documented)
>> 3) Possible workaround
>>
>> I can add several extra reasons as I stated before, but number of reasons won't validate anything anyway.
> 
>  End user convenience wins over the developer's technical difficulties.

Sorry, but I have to agree with Qu; there is no a big demand (other than Austin) for this functionality; even you stated that "...at some point it may..."; until now the UI is quite unfriendly (we should use a big enough device, and then cut it by hand on the basis of the output of mkfs.btrfs)...

I fear that this is another feature which increase the complexity of btrfs (and tools) with little or none usage....

The work of Qu is a nice cleanup; I hope that this will be the direction which BTRFS will takes: removing of "strange/unused" features improving the reliability of the others.

BR
G.Baroncelli



> 
>  Pls don't remove this feature, it needs fix such as #2 (above) to improve on #1 (above) as in your list.
> 
> Thanks, Anand
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
