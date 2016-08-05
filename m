Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16427 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161444AbcHEPv1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Aug 2016 11:51:27 -0400
Subject: Re: Input/output error, nothing appended in dmesg
To: Tomasz Chmielewski <tch@virtall.com>
References: <ff95214f4e2dd819d42dee7dff5f6580@admin.virtall.com>
 <9fdb317f-9209-d1a7-3e1e-7ab4f5b09c8d@fb.com>
 <fe633b0f3cc110bc5520db164e54dfe3@admin.virtall.com>
 <98e070f7-2787-9df4-c1b8-ae8005c039ec@fb.com>
 <e8e15af203f0f559d46402ee6a296209@admin.virtall.com>
 <e03fc4983421a31251c6f6274dd2c597@admin.virtall.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <c3fafcae-72d4-763f-7191-d9f39b91c850@fb.com>
Date: Fri, 5 Aug 2016 11:51:13 -0400
MIME-Version: 1.0
In-Reply-To: <e03fc4983421a31251c6f6274dd2c597@admin.virtall.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/05/2016 11:45 AM, Tomasz Chmielewski wrote:
> On 2016-08-06 00:38, Tomasz Chmielewski wrote:
> 
>>> Too big for the known problem though.  Still, can you btrfs-debug-tree
>>> and just make sure it doesn't have inline items?
>>
>> Hmmm....
>>
>> # btrfs-debug-tree /dev/xvdb > /root/debug.tree
>> parent transid verify failed on 355229302784 wanted 49943295 found
>> 49943301
>> parent transid verify failed on 355229302784 wanted 49943295 found
>> 49943301
>> Ignoring transid failure
>> parent transid verify failed on 355233251328 wanted 49943299 found
>> 49943303
>> parent transid verify failed on 355233251328 wanted 49943299 found
>> 49943303
>> Ignoring transid failure
>> print-tree.c:1105: btrfs_print_tree: Assertion failed.
>> btrfs-debug-tree[0x418d99]
>> btrfs-debug-tree(btrfs_print_tree+0x26a)[0x41acf6]
>> btrfs-debug-tree(main+0x9a5)[0x432589]
>> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7f2369de0f45]
>> btrfs-debug-tree[0x4070e9]
> 
> And, miracle cure O_o
> 
> # file ./2016-08-02/serverX/syslog.log
> ERROR: cannot read `./2016-08-02/serverX/syslog.log' (Input/output error)
> 
> # echo 3 > /proc/sys/vm/drop_caches
> 
> # file 2016-08-02/serverX/syslog.log
> 2016-08-02/serverX/syslog.log: ASCII text, with very long lines
> 
> # cat 2016-08-02/serverX/syslog.log
> (...)
> 

If you don't already have this commit, please give it a try.  Should fix things up.

commit 8dff9c85341032767d7b519217a79ea04cd676b0
Author: Chris Mason <clm@fb.com>
Date:   Sat Sep 19 11:28:25 2015 -0700

    Btrfs: deal with duplciates during extent_map insertion in btrfs_get_extent

