Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-02.prod.phx3.secureserver.net ([184.168.200.140]:42958
        "EHLO p3nlsmtpcp01-02.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750730AbdALOiw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 09:38:52 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 12 Jan 2017 07:37:44 -0700
From: lakshmipathi.g@giis.co.in
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btfs-progs: fsck-tests: corrupt nlink value test
In-Reply-To: <77e26cd7-0390-d02e-3dda-7107a2c68e7d@cn.fujitsu.com>
References: <20170107231955.GA24631@fedori>
 <c9e21f30-2231-94cd-09ed-8422951e7b69@cn.fujitsu.com>
 <fdc7f38883f4333cad73b7a92a1ba00a@giis.co.in>
 <77e26cd7-0390-d02e-3dda-7107a2c68e7d@cn.fujitsu.com>
Message-ID: <f5ef3a5bec7fccbd06559eda6a7cf59a@giis.co.in>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

Thanks for the details, I'll create image using these steps. Never used 
btrfs-image before will try it out.  in the mean time: I was thinking 
about these two approaches:

--
I agree on the dependency issue with btrfs-debug-tree. Test script will 
break if output is changed or jumbled.
If btrfs-debug-tree is the only issue, possible solution can be :

(a) when btrfs-debug-tree breaks the scripts add a backward captiable 
option (--print-old-format) for outputs. (or)
(b) Use 'ls -i' to find the inode object id?  I guess that will be more 
reliable than parsing btrfs-debug-tree output.  (or)
(c) may be use hard-corded id, if i'm not wrong, first object id will be 
always 256+1 = 257

I slightly prefer script over image because:
* It might be more easier to have script to add new functionality (ex: 
corrupt nlink field from hardlink)
* It allows option to inject corruption sequentitally.
ex: clean image->injection corrupt-x -> run btrfsck -> fixed image -> 
inject corruption 'variant of' x  -> repeat the process.
* It might also be more easier to deal with possible RAID-based 
corruption test scripts.
--

To my (QA) eyes, creating new image from 'mkfs.btrfs' for a each 
btrfs-progs version, injecting corruption (using ls -i output) and then 
verifying looks better. This way we can even catch any (rare) changes 
made to mkfs.btrfs. Script makes btrfsck heavily dependent on 
'mkfs.btrfs' which is a good thing,imo.

Let me know your thoughts. thanks!

Cheers.
Lakshmipathi.G
