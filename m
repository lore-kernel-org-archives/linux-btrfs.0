Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43640 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751221AbeDLI4f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Apr 2018 04:56:35 -0400
Subject: Re: [PATCH v2] btrfs-progs: dump-tree: add degraded option
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <20180309162324.GY23693@twin.jikos.cz>
 <20180310135449.16072-1-anand.jain@oracle.com>
 <0c04295b-1b42-37be-579d-5c8b7867affb@gmx.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <d9fe8756-8365-218b-da62-44ab09e0a2af@oracle.com>
Date: Thu, 12 Apr 2018 16:58:37 +0800
MIME-Version: 1.0
In-Reply-To: <0c04295b-1b42-37be-579d-5c8b7867affb@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>> diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
>> index df44bb635c9c..d2676ce55af7 100644
>> --- a/cmds-inspect-dump-tree.c
>> +++ b/cmds-inspect-dump-tree.c
>> @@ -198,6 +198,7 @@ const char * const cmd_inspect_dump_tree_usage[] = {
>>   	"-u|--uuid              print only the uuid tree",
>>   	"-b|--block <block_num> print info from the specified block only",
>>   	"-t|--tree <tree_id>    print only tree with the given id (string or number)",
>> +	"-x|--noscan            use the disk in the arg, do not scan for the disks (for raid1)",
> 
> Still it looks a little too restrict.
> 
> What about some equivalent just like kernel "device=" mount option?

  You mean something like..

"-o  use the disk(s) in the arg, do not scan for additional disks",

    btrfs in dump-tree [options] -o [device=<dev1>,device=<dev2>] <dev3>
    btrfs in dump-tree [options] -o <dev>
    btrfs in dump-tree [options] -o <dev1> -o <dev2> <dev3>

  I am ok.

Thanks, Anand
