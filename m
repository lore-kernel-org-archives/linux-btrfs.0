Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:59233 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759982AbcHEPpQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Aug 2016 11:45:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sat, 06 Aug 2016 00:45:13 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Input/output error, nothing appended in dmesg
In-Reply-To: <e8e15af203f0f559d46402ee6a296209@admin.virtall.com>
References: <ff95214f4e2dd819d42dee7dff5f6580@admin.virtall.com>
 <9fdb317f-9209-d1a7-3e1e-7ab4f5b09c8d@fb.com>
 <fe633b0f3cc110bc5520db164e54dfe3@admin.virtall.com>
 <98e070f7-2787-9df4-c1b8-ae8005c039ec@fb.com>
 <e8e15af203f0f559d46402ee6a296209@admin.virtall.com>
Message-ID: <e03fc4983421a31251c6f6274dd2c597@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-06 00:38, Tomasz Chmielewski wrote:

>> Too big for the known problem though.  Still, can you btrfs-debug-tree
>> and just make sure it doesn't have inline items?
> 
> Hmmm....
> 
> # btrfs-debug-tree /dev/xvdb > /root/debug.tree
> parent transid verify failed on 355229302784 wanted 49943295 found 
> 49943301
> parent transid verify failed on 355229302784 wanted 49943295 found 
> 49943301
> Ignoring transid failure
> parent transid verify failed on 355233251328 wanted 49943299 found 
> 49943303
> parent transid verify failed on 355233251328 wanted 49943299 found 
> 49943303
> Ignoring transid failure
> print-tree.c:1105: btrfs_print_tree: Assertion failed.
> btrfs-debug-tree[0x418d99]
> btrfs-debug-tree(btrfs_print_tree+0x26a)[0x41acf6]
> btrfs-debug-tree(main+0x9a5)[0x432589]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7f2369de0f45]
> btrfs-debug-tree[0x4070e9]

And, miracle cure O_o

# file ./2016-08-02/serverX/syslog.log
ERROR: cannot read `./2016-08-02/serverX/syslog.log' (Input/output 
error)

# echo 3 > /proc/sys/vm/drop_caches

# file 2016-08-02/serverX/syslog.log
2016-08-02/serverX/syslog.log: ASCII text, with very long lines

# cat 2016-08-02/serverX/syslog.log
(...)


Tomasz Chmielewski
https://lxadm.com
