Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:29281 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbdJBAkw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Oct 2017 20:40:52 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id EFA65AC0140
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Oct 2017 09:40:42 +0900 (JST)
Subject: Re: [PATCH] btrfs-progs: add option to only list parent subvolumes
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        Graham Cobb <g.btrfs@cobb.uk.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <6c01643a-b6cd-21ae-45ec-e074995a5de2@applied-asynchrony.com>
 <264aa617-9484-a5fe-ad47-8ed052d6764e@cobb.uk.net>
 <e20b2520-5bed-7f61-57b6-dd9e41918680@applied-asynchrony.com>
 <a6f89874-2048-6903-9ebc-d28991a00adc@applied-asynchrony.com>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <2f33c77a-c523-b602-72ab-e972ec7c9e7a@jp.fujitsu.com>
Date: Mon, 2 Oct 2017 09:40:34 +0900
MIME-Version: 1.0
In-Reply-To: <a6f89874-2048-6903-9ebc-d28991a00adc@applied-asynchrony.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017/10/01 3:17, Holger Hoffstätte wrote:
> On 09/30/17 19:56, Holger Hoffstätte wrote:
>> shell hackery as alternative. Anyway, I was sure that at the time the
>> other letters sounded even worse/were taken, but that may just have been
>> in my head. ;-)
>>
>> I just rechecked and -S is still available, so that's good.
> 
> Except that it isn't really, since there is already an 'S'
> case in cmds-subvolume.c as shortcut to --sort:
> 
> --
>         case 'S':
>             ret = btrfs_list_parse_sort_string(optarg,
>                                &comparer_set);
> --
> 
> ..which is why I picked P at the time.

Hello,

It is confusing, but the third args of getopt_long doesn't take 'S':

 445                 static const struct option long_options[] = {
 446                         {"sort", required_argument, NULL, 'S'},
 447                         {NULL, 0, NULL, 0}
 448                 };
 449 
 450                 c = getopt_long(argc, argv,
 451                                     "acdgopqsurRG:C:t", long_options, NULL);

So, you can use -S option if you change 'S' in L.446 to something.
(I'm not sure this is intended or someone forgot to add 'S'.)

> 
> Holger
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

