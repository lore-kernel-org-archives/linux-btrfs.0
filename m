From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH 0/5] btrfs: snapshot deletion via readahead
Date: Fri, 13 Apr 2012 15:43:32 +0800
Message-ID: <4F87D924.6080501@cn.fujitsu.com>
References: <cover.1334241664.git.sensille@gmx.net> <4F87A034.3030607@cn.fujitsu.com> <4F87CD6D.5040100@gmx.net> <4F87D157.4040607@cn.fujitsu.com> <4F87D368.5070807@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F87D368.5070807@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/13/2012 03:19 PM, Arne Jansen wrote:

> 
> might be out of memory. How much does this vm (?) have?
> Can you try to reduce the constants in disk-io.c:2003-2005?
> 
> Thanks,
> Arne
> 


Seems not related to an OOM:
# free -m
             total       used       free     shared    buffers     cached
Mem:          1973        478       1494          0         49        315
-/+ buffers/cache:        113       1859
Swap:            0          0          0


thanks,
liubo 
