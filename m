Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2750C10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 09:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C64220850
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 09:07:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XFnS0sxo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfDLJHH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 05:07:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41182 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbfDLJHH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 05:07:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C8xRoQ144336;
        Fri, 12 Apr 2019 09:06:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : cc : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=t8lbAQI5cCJ2XPz7L8diBhNTa0RAgOSVDRg4QbEDvB4=;
 b=XFnS0sxoyzhzm7uhYq7lmyNRW4JfKQnZ3CptqmAkgUrTsEDXoKAjksvwqkhH3HM6G3ri
 oSKse0S3egZmpDa+iXCVDVe/FrSwKkarkGskTC18RuuGZ8pTEotNmqU0MZOeyT6+8qOH
 XH5gP8mNUzu+G5b/pbli0Ah83jJshBbw0RNSmCGVf2J7m/E1xVDNMBcwjTqKJRU0cCq3
 jbGjLMskrs/BxHwlqawSlCSG1jbFXiSnSPbGpKXKvFxY75I7Iu4fSvFQjMwOTnOw83J9
 v0KRF4yZerAw6Ah4B/Y516Q5ue9QUJfdoxRncVievpG6YvokNHe3Urui9YYqN1KMftIY 0g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2rpmrqnbdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Apr 2019 09:06:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C940DC041386;
        Fri, 12 Apr 2019 09:04:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2rtd84enm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Apr 2019 09:04:59 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3C94wWg027801;
        Fri, 12 Apr 2019 09:04:58 GMT
Received: from [10.190.130.106] (/192.188.170.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Apr 2019 02:04:57 -0700
Subject: Re: [PATCH v5 RESEND] btrfs-progs: dump-tree: add noscan option
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Nikolay Borisov <nborisov@suse.com>
References: <20190404072957.2847-1-anand.jain@oracle.com>
 <121e7005-2535-c3d3-d779-9401db10bfa9@gmx.com>
 <e46d41f4-6f40-b8cb-fe2d-6ddd3b9458e4@suse.com>
 <839115e0-3874-97e1-a3d9-fe35daaeb782@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
From:   Anand Jain <Anand.Jain@oracle.com>
Message-ID: <3caa0fe2-1310-2531-359b-cff562a39831@oracle.com>
Date:   Fri, 12 Apr 2019 17:04:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <839115e0-3874-97e1-a3d9-fe35daaeb782@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9224 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904120061
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9224 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904120061
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 11/4/19 3:28 PM, Qu Wenruo wrote:
> 
> 
> On 2019/4/11 下午2:52, Nikolay Borisov wrote:
>>
>>
>> On 11.04.19 г. 7:53 ч., Qu Wenruo wrote:
>>>
>>>
>>> On 2019/4/4 下午3:29, Anand Jain wrote:
>>>> From: Anand Jain <Anand.Jain@oracle.com>
>>>>
>>>> The cli 'btrfs inspect dump-tree <dev>' will scan for the partner devices
>>>> if any by default.
>>>>
>>>> So as of now you can not inspect each mirrored device independently.
>>>>
>>>> This patch adds noscan option, which when used won't scan the system for
>>>> the partner devices, instead it just uses the devices provided in the
>>>> argument.
>>>>
>>>> For example:
>>>>    btrfs inspect dump-tree --noscan <dev> [<dev>..]
>>>
>>> So you can specify multiple devices, just like kernel "device=" mount
>>> option.
>>>
>>> Then I don't think --noscan is a good naming, while I don't have any
>>> good alternative, as the --degraded is no better.
>>
>> How about skipscan ?
> 
> I still prefer "--device=", no surprise, anyone who used "device=" mount
> option knows what it is.
> 
> The only problem is, when only using one device, it will be super stupid:
>    dump-tree --device /dev/sda /dev/sda
> 
> If this doesn't sound good, then --noscan is good enough AFAIK.

  It was difficult to pick a name for this. IMO --degraded is not a bad
  either, matches with the kernel mount -o degraded. Thanks for your
  thoughts.

Thanks, Anand


> Thanks,
> Qu
> 
>>
>>>
>>> My idea is "(--device=<dev1>,<dev2>)|(<dev>)", but that looks more awful.
>>>
>>> Despite of that, the patch looks pretty good.
>>>
>>>>
>>>> This helps to debug degraded raid1 and raid10.
>>>>
>>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>>> ---
>>>> v4->v5: nit: use %m to print error string.
>>>> 	changelog update.
>>>> v3->v4: change the patch title.
>>>> 	collapse scan_args() to its only parent cmd_inspect_dump_tree()
>>>> 	(it was bit confusing).
>>>
>>> I don't this is the correct direction.
>>>
>>> You're introducing "--device=" btrfs-progs equivalent, there is no way
>>> it will only be utilized by dump-tree.
>>>
>>> Btrfs-check, btrfs-restore can all take advantage of this feature.
>>>
>>> You don't need to resend, later code can export them when needed.
>>> But doing it at the first place really helps.
>>>
>>> Thanks,
>>> Qu
>>>
>>>> 	update the change log.
>>>> 	update usage.
>>>> 	update man page.
>>>> v2->v3: make it scalable for more than two disks in noscan mode
>>>> v1->v2: rename --degraded to --noscan
>>>>
>>>>   Documentation/btrfs-inspect-internal.asciidoc |  5 ++-
>>>>   cmds-inspect-dump-tree.c                      | 53 +++++++++++++++++++++------
>>>>   2 files changed, 45 insertions(+), 13 deletions(-)
>>>>
>>>> diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
>>>> index 381497d284b8..f9d7f1c58f00 100644
>>>> --- a/Documentation/btrfs-inspect-internal.asciidoc
>>>> +++ b/Documentation/btrfs-inspect-internal.asciidoc
>>>> @@ -61,7 +61,7 @@ specify which mirror to print, valid values are 0, 1 and 2 and the superblock
>>>>   must be present on the device with a valid signature, can be used together with
>>>>   '--force'
>>>>
>>>> -*dump-tree* [options] <device>::
>>>> +*dump-tree* [options] <device> [device...]::
>>>>   (replaces the standalone tool *btrfs-debug-tree*)
>>>>   +
>>>>   Dump tree structures from a given device in textual form, expand keys to human
>>>> @@ -95,6 +95,9 @@ intermixed in the output
>>>>   --bfs::::
>>>>   use breadth-first search to print trees. the nodes are printed before all
>>>>   leaves
>>>> +--noscan::::
>>>> +do not scan the system for other partner device(s), only use the device(s)
>>>> +provided in the argument
>>>>   -t <tree_id>::::
>>>>   print only the tree with the specified ID, where the ID can be numerical or
>>>>   common name in a flexible human readable form
>>>> diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
>>>> index ad5345b4f1db..37d9b29fa824 100644
>>>> --- a/cmds-inspect-dump-tree.c
>>>> +++ b/cmds-inspect-dump-tree.c
>>>> @@ -21,6 +21,7 @@
>>>>   #include <unistd.h>
>>>>   #include <uuid/uuid.h>
>>>>   #include <getopt.h>
>>>> +#include <fcntl.h>
>>>>
>>>>   #include "kerncompat.h"
>>>>   #include "radix-tree.h"
>>>> @@ -185,7 +186,7 @@ static u64 treeid_from_string(const char *str, const char **end)
>>>>   }
>>>>
>>>>   const char * const cmd_inspect_dump_tree_usage[] = {
>>>> -	"btrfs inspect-internal dump-tree [options] device",
>>>> +	"btrfs inspect-internal dump-tree [options] <device> [<device> ..]",
>>>>   	"Dump tree structures from a given device",
>>>>   	"Dump tree structures from a given device in textual form, expand keys to human",
>>>>   	"readable equivalents where possible.",
>>>> @@ -200,6 +201,7 @@ const char * const cmd_inspect_dump_tree_usage[] = {
>>>>   	"-b|--block <block_num> print info from the specified block only",
>>>>   	"-t|--tree <tree_id>    print only tree with the given id (string or number)",
>>>>   	"--follow               use with -b, to show all children tree blocks of <block_num>",
>>>> +	"--noscan               do not scan for the partner device(s)",
>>>>   	NULL
>>>>   };
>>>>
>>>> @@ -214,7 +216,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>>>   	struct btrfs_disk_key disk_key;
>>>>   	struct btrfs_key found_key;
>>>>   	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
>>>> -	int ret;
>>>> +	int ret = 0;
>>>>   	int slot;
>>>>   	int extent_only = 0;
>>>>   	int device_only = 0;
>>>> @@ -222,6 +224,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>>>   	int roots_only = 0;
>>>>   	int root_backups = 0;
>>>>   	int traverse = BTRFS_PRINT_TREE_DEFAULT;
>>>> +	int dev_optind;
>>>>   	unsigned open_ctree_flags;
>>>>   	u64 block_only = 0;
>>>>   	struct btrfs_root *tree_root_scan;
>>>> @@ -239,8 +242,8 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>>>   	optind = 0;
>>>>   	while (1) {
>>>>   		int c;
>>>> -		enum { GETOPT_VAL_FOLLOW = 256, GETOPT_VAL_DFS,
>>>> -		       GETOPT_VAL_BFS };
>>>> +		enum { GETOPT_VAL_FOLLOW = 256, GETOPT_VAL_DFS, GETOPT_VAL_BFS,
>>>> +		       GETOPT_VAL_NOSCAN};
>>>>   		static const struct option long_options[] = {
>>>>   			{ "extents", no_argument, NULL, 'e'},
>>>>   			{ "device", no_argument, NULL, 'd'},
>>>> @@ -252,6 +255,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>>>   			{ "follow", no_argument, NULL, GETOPT_VAL_FOLLOW },
>>>>   			{ "bfs", no_argument, NULL, GETOPT_VAL_BFS },
>>>>   			{ "dfs", no_argument, NULL, GETOPT_VAL_DFS },
>>>> +			{ "noscan", no_argument, NULL, GETOPT_VAL_NOSCAN },
>>>>   			{ NULL, 0, NULL, 0 }
>>>>   		};
>>>>
>>>> @@ -313,24 +317,49 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>>>   		case GETOPT_VAL_BFS:
>>>>   			traverse = BTRFS_PRINT_TREE_BFS;
>>>>   			break;
>>>> +		case GETOPT_VAL_NOSCAN:
>>>> +			open_ctree_flags |= OPEN_CTREE_NO_DEVICES;
>>>> +			break;
>>>>   		default:
>>>>   			usage(cmd_inspect_dump_tree_usage);
>>>>   		}
>>>>   	}
>>>>
>>>> -	if (check_argc_exact(argc - optind, 1))
>>>> +	if (check_argc_min(argc - optind, 1))
>>>>   		usage(cmd_inspect_dump_tree_usage);
>>>>
>>>> -	ret = check_arg_type(argv[optind]);
>>>> -	if (ret != BTRFS_ARG_BLKDEV && ret != BTRFS_ARG_REG) {
>>>> +	dev_optind = optind;
>>>> +	while (dev_optind < argc) {
>>>> +		int fd;
>>>> +		struct btrfs_fs_devices *fs_devices;
>>>> +		u64 num_devices;
>>>> +
>>>> +		ret = check_arg_type(argv[optind]);
>>>> +		if (ret != BTRFS_ARG_BLKDEV && ret != BTRFS_ARG_REG) {
>>>> +			if (ret < 0) {
>>>> +				errno = -ret;
>>>> +				error("invalid argument %s: %m", argv[dev_optind]);
>>>> +			} else {
>>>> +				error("not a block device or regular file: %s",
>>>> +				       argv[dev_optind]);
>>>> +			}
>>>> +		}
>>>> +		fd = open(argv[dev_optind], O_RDONLY);
>>>> +		if (fd < 0) {
>>>> +			error("cannot open %s: %m", argv[dev_optind]);
>>>> +			return -EINVAL;
>>>> +		}
>>>> +		ret = btrfs_scan_one_device(fd, argv[dev_optind], &fs_devices,
>>>> +					    &num_devices,
>>>> +					    BTRFS_SUPER_INFO_OFFSET,
>>>> +					    SBREAD_DEFAULT);
>>>> +		close(fd);
>>>>   		if (ret < 0) {
>>>>   			errno = -ret;
>>>> -			error("invalid argument %s: %m", argv[optind]);
>>>> -		} else {
>>>> -			error("not a block device or regular file: %s",
>>>> -			      argv[optind]);
>>>> +			error("device scan %s: %m", argv[dev_optind]);
>>>> +			return ret;
>>>>   		}
>>>> -		goto out;
>>>> +		dev_optind++;
>>>>   	}
>>>>
>>>>   	printf("%s\n", PACKAGE_STRING);
>>>>
>>>

