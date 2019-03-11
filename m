Return-Path: <SRS0=TRLW=RO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA108C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 14:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 875AA20657
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 14:45:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CJgg7VgT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbfCKOpq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Mar 2019 10:45:46 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49906 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbfCKOpM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Mar 2019 10:45:12 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2BEhkv9016852;
        Mon, 11 Mar 2019 14:44:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2018-07-02;
 bh=pYrgxjWz90Ry1livzDfPFJY8Eba9VbDNS2TlZoDpRsI=;
 b=CJgg7VgTtCItqrdoRrnoZcZNu92Vg/WZnpku6UW38Kp24UgJSxJ0SE2N/kQ+sFTVe9n6
 VEDLDEKW7osN3cWncTyQ5HE0EgDbtG9+jb9jGenFXssuBmeOMwRAHakhcN+jInoE5kW8
 lF39l2PHoeRcbJZp5a9pxesxJp322Jp7EsyXPGY72u5sem/sZlPqNQ7wFWtba3jxuzHX
 10IqLEo/xLsrIoLVcETcKJ2W7Ed5sWYSFxIXCUgkyq27uiCGuO75h4LRSk3azoL5hPo5
 0T3PRZV8c6D4FW86iznVXAuj0AbZP73bWftrVib32IZVfFwJaFoyNeNK/FdiGXINpRnD cQ== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2r430efb46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Mar 2019 14:44:46 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2BEikOA029371
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Mar 2019 14:44:46 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2BEikQc002214;
        Mon, 11 Mar 2019 14:44:46 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Mar 2019 07:44:45 -0700
From:   Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH v4] btrfs-progs: dump-tree: add noscan option
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1551336865-9954-1-git-send-email-anand.jain@oracle.com>
 <bc654de6-f8f9-ec5d-bdf0-b2570f3d8e56@suse.com>
Message-ID: <6db79bc0-29a4-cdd1-73f3-9c433acb12f2@oracle.com>
Date:   Mon, 11 Mar 2019 22:44:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <bc654de6-f8f9-ec5d-bdf0-b2570f3d8e56@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9192 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903110107
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3/11/19 6:11 PM, Nikolay Borisov wrote:
> 
> 
> On 28.02.19 г. 8:54 ч., Anand Jain wrote:
>> From: Anand Jain <Anand.Jain@oracle.com>
>>
>> There is no way to dump tree from a disk in the degraded mode.
>> Such as, when you specify a device for the cli 'btrfs inspect
>> dump-tree /dev/sda' it would invariably scan for its partner devices
>> to built and print the tree. This approach at times defeats the purpose.
> 
> define "at times" which are those times?

  Its already defined as below. Will reword or state it explicitly.

>> Suppose in RAID1 if you want to review each mirror separately as of now
>> there is no way you can do that. So this patch adds an option --noscan
>> for example:
>>    'btrfs inspect dump-tree --noscan <dev> [<dev>..]'
>> with which it shall not scan for the other devices to report the tree, and
>> helps debug RAID1s.
> 
> This example contradicts what the code is doing,

  No. did you miss the flag OPEN_CTREE_NO_DEVICES at [1] below. ?
  Which means it does not scan the system for the btrfs devices.

> with this patch you
> will call btrfs_scan_one_device for every device passed to the noscan
> option?

  That's right. Its correct behavior.

>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> v3->v4: change the patch title.
>> 	collapse scan_args() to its only parent cmd_inspect_dump_tree()
>> 	(it was bit confusing).
>> 	update the change log.
>> 	update usage.
>> 	update man page.
>> v2->v3: make it scalable for more than two disks in noscan mode
>> v1->v2: rename --degraded to --noscan
> 
> So what problem is this actually trying to solve? The following succeeds
> for me with btrfs-progs 4.17.1:

> root@ubuntu-virtual:~# losetup -f file1.img
> root@ubuntu-virtual:~# losetup -f file2.img
> root@ubuntu-virtual:~# mkfs.btrfs -m raid1 /dev/loop1 /dev/loop0
> losetup -d /dev/loop1
> root@ubuntu-virtual:~# mount /dev/loop0 /media/scratch/
> mount: wrong fs type, bad option, bad superblock on /dev/loop0,
>         missing codepage or helper program, or other error
> 
>         In some cases useful info is found in syslog - try
>         dmesg | tail or so.
> 
> 
> root@ubuntu-virtual:~# btrfs inspect-internal dump-tree /dev/loop0
> btrfs-progs v4.17.1
> warning, device 1 is missing
> root tree
> leaf 30556160 items 10 free space 13173 generation 5 owner ROOT_TREE
> leaf 30556160 flags 0x1(WRITTEN) backref revision 1
> fs uuid 8727408c-b1af-4c14-b63b-51b12bcff933
> chunk uuid 5ebde928-324f-42d0-98c6-f953d680fc21
> 	item 0 key (EXTENT_TREE ROOT_ITEM 0) itemoff 15844 itemsize 439
> 		generation 5 root_dirid 0 bytenr 30523392 level 0 refs 1
> .................
> 
> 
> 
> Your changelog definitely needs rewriting to make it clear what you are
> trying to do.

  In your example above /dev/loop1 is destroyed. So are you suggesting to
  destroy the partner device to dump-tree in degraded mode? That's not
  a viable workaround.

Thanks, Anand

>> ---
>>   Documentation/btrfs-inspect-internal.asciidoc |  5 ++-
>>   cmds-inspect-dump-tree.c                      | 57 ++++++++++++++++++++-------
>>   2 files changed, 47 insertions(+), 15 deletions(-)
>>
>> diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
>> index 381497d284b8..f9d7f1c58f00 100644
>> --- a/Documentation/btrfs-inspect-internal.asciidoc
>> +++ b/Documentation/btrfs-inspect-internal.asciidoc
>> @@ -61,7 +61,7 @@ specify which mirror to print, valid values are 0, 1 and 2 and the superblock
>>   must be present on the device with a valid signature, can be used together with
>>   '--force'
>>   
>> -*dump-tree* [options] <device>::
>> +*dump-tree* [options] <device> [device...]::
>>   (replaces the standalone tool *btrfs-debug-tree*)
>>   +
>>   Dump tree structures from a given device in textual form, expand keys to human
>> @@ -95,6 +95,9 @@ intermixed in the output
>>   --bfs::::
>>   use breadth-first search to print trees. the nodes are printed before all
>>   leaves
>> +--noscan::::
>> +do not scan the system for other partner device(s), only use the device(s)
>> +provided in the argument
>>   -t <tree_id>::::
>>   print only the tree with the specified ID, where the ID can be numerical or
>>   common name in a flexible human readable form
>> diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
>> index ad5345b4f1db..9dd040e5de17 100644
>> --- a/cmds-inspect-dump-tree.c
>> +++ b/cmds-inspect-dump-tree.c
>> @@ -21,6 +21,7 @@
>>   #include <unistd.h>
>>   #include <uuid/uuid.h>
>>   #include <getopt.h>
>> +#include <fcntl.h>
>>   
>>   #include "kerncompat.h"
>>   #include "radix-tree.h"
>> @@ -185,7 +186,7 @@ static u64 treeid_from_string(const char *str, const char **end)
>>   }
>>   
>>   const char * const cmd_inspect_dump_tree_usage[] = {
>> -	"btrfs inspect-internal dump-tree [options] device",
>> +	"btrfs inspect-internal dump-tree [options] <device> [<device> ..]",
>>   	"Dump tree structures from a given device",
>>   	"Dump tree structures from a given device in textual form, expand keys to human",
>>   	"readable equivalents where possible.",
>> @@ -200,6 +201,7 @@ const char * const cmd_inspect_dump_tree_usage[] = {
>>   	"-b|--block <block_num> print info from the specified block only",
>>   	"-t|--tree <tree_id>    print only tree with the given id (string or number)",
>>   	"--follow               use with -b, to show all children tree blocks of <block_num>",
>> +	"--noscan               do not scan for the partner device(s)",
>>   	NULL
>>   };
>>   
>> @@ -214,7 +216,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>   	struct btrfs_disk_key disk_key;
>>   	struct btrfs_key found_key;
>>   	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
>> -	int ret;
>> +	int ret = 0;
>>   	int slot;
>>   	int extent_only = 0;
>>   	int device_only = 0;
>> @@ -222,6 +224,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>   	int roots_only = 0;
>>   	int root_backups = 0;
>>   	int traverse = BTRFS_PRINT_TREE_DEFAULT;
>> +	int dev_optind;
>>   	unsigned open_ctree_flags;
>>   	u64 block_only = 0;
>>   	struct btrfs_root *tree_root_scan;
>> @@ -239,8 +242,8 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>   	optind = 0;
>>   	while (1) {
>>   		int c;
>> -		enum { GETOPT_VAL_FOLLOW = 256, GETOPT_VAL_DFS,
>> -		       GETOPT_VAL_BFS };
>> +		enum { GETOPT_VAL_FOLLOW = 256, GETOPT_VAL_DFS, GETOPT_VAL_BFS,
>> +		       GETOPT_VAL_NOSCAN};
>>   		static const struct option long_options[] = {
>>   			{ "extents", no_argument, NULL, 'e'},
>>   			{ "device", no_argument, NULL, 'd'},
>> @@ -252,6 +255,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>   			{ "follow", no_argument, NULL, GETOPT_VAL_FOLLOW },
>>   			{ "bfs", no_argument, NULL, GETOPT_VAL_BFS },
>>   			{ "dfs", no_argument, NULL, GETOPT_VAL_DFS },
>> +			{ "noscan", no_argument, NULL, GETOPT_VAL_NOSCAN },
>>   			{ NULL, 0, NULL, 0 }
>>   		};
>>   
>> @@ -313,24 +317,49 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>   		case GETOPT_VAL_BFS:
>>   			traverse = BTRFS_PRINT_TREE_BFS;
>>   			break;
>> +		case GETOPT_VAL_NOSCAN:
>> +			open_ctree_flags |= OPEN_CTREE_NO_DEVICES;  <--- [1]
>> +			break;
>>   		default:
>>   			usage(cmd_inspect_dump_tree_usage);
>>   		}
>>   	}
>>   
>> -	if (check_argc_exact(argc - optind, 1))
>> +	if (check_argc_min(argc - optind, 1))
>>   		usage(cmd_inspect_dump_tree_usage);
>>   
>> -	ret = check_arg_type(argv[optind]);
>> -	if (ret != BTRFS_ARG_BLKDEV && ret != BTRFS_ARG_REG) {
>> -		if (ret < 0) {
>> -			errno = -ret;
>> -			error("invalid argument %s: %m", argv[optind]);
>> -		} else {
>> -			error("not a block device or regular file: %s",
>> -			      argv[optind]);
>> +	dev_optind = optind;
>> +	while (dev_optind < argc) {
>> +		int fd;
>> +		struct btrfs_fs_devices *fs_devices;
>> +		u64 num_devices;
>> +
>> +		ret = check_arg_type(argv[optind]);
>> +		if (ret != BTRFS_ARG_BLKDEV && ret != BTRFS_ARG_REG) {
>> +			if (ret < 0) {
>> +				errno = -ret;
>> +				error("invalid argument %s: %m", argv[dev_optind]);
>> +			} else {
>> +				error("not a block device or regular file: %s",
>> +				       argv[dev_optind]);
>> +			}
>>   		}
>> -		goto out;
>> +		fd = open(argv[dev_optind], O_RDONLY);
>> +		if (fd < 0) {
>> +			error("cannot open %s: %m", argv[dev_optind]);
>> +			return -EINVAL;
>> +		}
>> +		ret = btrfs_scan_one_device(fd, argv[dev_optind], &fs_devices,
>> +					    &num_devices,
>> +					    BTRFS_SUPER_INFO_OFFSET,
>> +					    SBREAD_DEFAULT);
>> +		close(fd);
>> +		if (ret) {
>> +			error("device scan %s: %s", argv[dev_optind],
>> +			       strerror(-ret));
>> +			return ret;
>> +		}
>> +		dev_optind++;
>>   	}
>>   
>>   	printf("%s\n", PACKAGE_STRING);
>>
