Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45673 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751888AbdCAJfC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Mar 2017 04:35:02 -0500
Subject: Re: [4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already
 exists
To: Marc Joliet <marcec@gmx.de>, <linux-btrfs@vger.kernel.org>
References: <20160828152908.6e1325b5@jupiter.sol.kaishome.de>
 <20170217091915.066488ef@jupiter.sol.kaishome.de>
 <21888099.8VRa6s2ieu@thetick> <1975016.KbFk7ASZDg@thetick>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <63cf74bb-009a-b422-4390-7562395db31d@cn.fujitsu.com>
Date: Wed, 1 Mar 2017 17:32:35 +0800
MIME-Version: 1.0
In-Reply-To: <1975016.KbFk7ASZDg@thetick>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/01/2017 04:23 PM, Marc Joliet wrote:
> On Tuesday 28 February 2017 23:14:54 Marc Joliet wrote:
>> I think I'm at that point now myself, unless anybody has any other ideas.
>
> For example, could the --init-extent-tree option to btrfs-check help, given
> that I needed to pass -w to btrfs-image?

--init-extent-tree should be avoided normally, unless you're 100% sure 
about only extent tree is corrupted, and you have enough faith that 
--init-extent-tree can finish.

Or it will mostly make things worse.

Before trying any RW btrfs check operations, did you run btrfs check on 
the image?

And btrfs check --mode=lowmem is also recommended as in some rare case, 
low mem mode can detect bug which original mode doesn't.

(And it also helps us to enhance lowmem mode)
>
> Also, the image is complete, so I only need to find somewhere where I can
> upload a 9.4 GB file.

Is it a compressed dump? Dumped with btrfs-image -c9?

If so, such large one won't help much unless there is some developer 
really interested in inspecting the image.

Thanks,
Qu

>
> Greetings
>


