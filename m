From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/2] treewide: fix memory corruptions when TASK_COMM_LEN
 != 16
Date: Thu, 23 Feb 2012 12:19:28 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1202231152280.9220@frira.zrqbmnf.qr>
References: <1327183785-27023-1-git-send-email-jengelh@medozas.de> <20120124135443.2772d455.akpm@linux-foundation.org> <alpine.LNX.2.01.1201250121260.20692@frira.zrqbmnf.qr> <20120131172334.7f26f164.akpm@linux-foundation.org> <alpine.LNX.2.01.1202010224510.29848@frira.zrqbmnf.qr>
 <20120131174914.8ce5291d.akpm@linux-foundation.org> <alpine.LNX.2.01.1202010257240.29848@frira.zrqbmnf.qr> <20120131190109.b53347fd.akpm@linux-foundation.org> <alpine.LNX.2.01.1202221343530.10125@frira.zrqbmnf.qr> <20120222125810.50cd5789.akpm@linux-foundation.org>
 <alpine.LNX.2.01.1202222303190.15465@frira.zrqbmnf.qr> <20120223015726.cb065d73.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120223015726.cb065d73.akpm@linux-foundation.org>
List-ID: <linux-btrfs.vger.kernel.org>


On Thursday 2012-02-23 10:57, Andrew Morton wrote:
>>
But there's more,
>> 
>> 24931 ?        S      0:00  \_ [btrfs-endio-met]
                               \_ [kconservative/5]
                               \_ [ext4-dio-unwrit]
>> 
>> [with a wondersome patch:] $ grep Name /proc/{29431,29432}/stat*
>> /proc/29431/status:Name: btrfs-endio-meta-1
>> /proc/29432/status:Name: btrfs-endio-meta-write-1
                      Name: kconservative/512
                      Name: ext4-dio-unwritten
>
>doh.  The fix for that is to have less clueless btrfs developers.

And truncate their names to SUNWbtfs, ORCLintg and EXT4diou?
I think not :)
