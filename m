Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46467 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751013AbdGGJd3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Jul 2017 05:33:29 -0400
Date: Fri, 7 Jul 2017 17:33:20 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Marc MERLIN <marc@merlins.org>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Josef Bacik <jbacik@fb.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>
Subject: Re: ctree.c:197: update_ref_for_cow: BUG_ON `ret` triggered, value -5
Message-ID: <20170707093318.GD3224@fnst>
References: <20170628071026.GA21006@lufq.5F>
 <20170628144348.abvqowzmeveyzssn@merlins.org>
 <20170501170641.GG3516@merlins.org>
 <20170501180856.GH3516@merlins.org>
 <CAJCQCtR4Hr5ekASiqWn2RNju5pHz8itS91N=M29Cz8Nqx8=kqA@mail.gmail.com>
 <20170502032346.ayhh3n3uh5d5ekbb@merlins.org>
 <CAJCQCtRaeejj4b+J6M7VTsDAe7Sn4PUtBwcvHXgfLNAFe=8Jqg@mail.gmail.com>
 <20170502051155.igmbqcqgzi4ukefg@merlins.org>
 <20170707053718.GA9735@merlins.org>
 <20170707053953.GB9735@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20170707053953.GB9735@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 06, 2017 at 10:39:53PM -0700, Marc MERLIN wrote:
>On Thu, Jul 06, 2017 at 10:37:18PM -0700, Marc MERLIN wrote:
>> I'm still trying to fix my filesystem.
>> It seems to work well enough since the damage is apparently localized, but
>> I'd really want check --repair to actually bring it back to a working
>> state, but now it's crashing

I apologise for my late reply. As a colleague left, I have to take over his
work recently.

>> 
>> This is btrfs tools from git from a few days ago
>> 
>> Failed to find [4068943577088, 168, 16384]
>> btrfs unable to find ref byte nr 4068943577088 parent 0 root 4  owner 1 offset 0
>> Failed to find [5905106075648, 168, 16384]
>> btrfs unable to find ref byte nr 5906282119168 parent 0 root 4  owner 0 offset 1
>> Failed to find [21037056, 168, 16384]
>> btrfs unable to find ref byte nr 21037056 parent 0 root 3  owner 1 offset 0
>> Failed to find [21053440, 168, 16384]
>> btrfs unable to find ref byte nr 21053440 parent 0 root 3  owner 0 offset 1
>> Failed to find [21299200, 168, 16384]
>> btrfs unable to find ref byte nr 21299200 parent 0 root 3  owner 0 offset 1
>> Failed to find [5523931971584, 168, 16384]
>> btrfs unable to find ref byte nr 5524037566464 parent 0 root 3861  owner 3 offset 0
>> ctree.c:197: update_ref_for_cow: BUG_ON `ret` triggered, value -5
>> btrfs(+0x113cf)[0x5651e60443cf]
>> btrfs(__btrfs_cow_block+0x576)[0x5651e6045848]
>> btrfs(btrfs_cow_block+0xea)[0x5651e6045dc6]
>> btrfs(btrfs_search_slot+0x11df)[0x5651e604969d]
>> btrfs(+0x59184)[0x5651e608c184]
>> btrfs(cmd_check+0x2bd4)[0x5651e60987b3]
>> btrfs(main+0x85)[0x5651e60442c3]
>> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7f34f523d2b1]
>> btrfs(_start+0x2a)[0x5651e6043e3a]
>
>Mmmh, never mind, it seems that the software raid suffered yet another
>double disk failure due to some undermined flakiness in the underlying block
>device cabling :-/
>That would likely explain the failures here.

I'm sorry for hear this. Which raid level are you using? So could you recover
from this double disk failure?

-- 
Thanks,
Lu


