Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:36196 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932791AbdHVN1S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 09:27:18 -0400
Received: by mail-io0-f193.google.com with SMTP id o196so2837068ioe.3
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 06:27:17 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id h13sm5134546ith.36.2017.08.22.06.27.15
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Aug 2017 06:27:15 -0700 (PDT)
Subject: Re: finding root filesystem of a subvolume?
To: linux-btrfs@vger.kernel.org
References: <20170822122350.GA14804@rus.uni-stuttgart.de>
 <20170822124036.GA32302@carfax.org.uk>
 <20170822125030.GB14804@rus.uni-stuttgart.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <16778020-9167-b7cc-4768-ee33dca2bbb7@gmail.com>
Date: Tue, 22 Aug 2017 09:27:14 -0400
MIME-Version: 1.0
In-Reply-To: <20170822125030.GB14804@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-22 08:50, Ulli Horlacher wrote:
> On Tue 2017-08-22 (12:40), Hugo Mills wrote:
>> On Tue, Aug 22, 2017 at 02:23:50PM +0200, Ulli Horlacher wrote:
>>
>>> How do I find the root filesystem of a subvolume?
>>> Example:
>>>
>>> root@fex:~# df -T
>>> Filesystem     Type  1K-blocks      Used Available Use% Mounted on
>>> -              -    1073740800 104244552 967773976  10% /local/.backup/home
>>
>>     I've never seen the "- -" output from df before. Is this a bind
>> mount or something?
> 
> No, /local/.backup/home is just a btrfs subvolume
It arguably shouldn't be showing up here then if it's not been 
explicitly mounted.  I'm betting you're running OpenSUSE or SLES and 
they finally got their df integration done, as that df output absolutely 
matches the type of brain-dead handling of BTRFS I'm coming to expect 
out of them.


Note to SUSE people reading this:  You should be including actual 
information for at least the Type field, and ideally the Filesystem 
field too.  People expect this to behave reasonably, and not listing any 
info about where the 'mount' originated or what it is is not reasonable.
