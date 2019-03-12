Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C003EC10F00
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 14:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F83C214AE
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 14:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfCLOYM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 10:24:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:59558 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725917AbfCLOYL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 10:24:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2BA0AAF32;
        Tue, 12 Mar 2019 14:24:10 +0000 (UTC)
Subject: Re: [PATCH v5] btrfs-progs: dump-tree: add noscan option
To:     Hugo Mills <hugo@carfax.org.uk>,
        Nikolay Borisov <nborisov@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
References: <1552396970-14651-1-git-send-email-anand.jain@oracle.com>
 <babdc163-61c5-1c12-7708-c26c544748ce@suse.com>
 <20190312141937.GC15963@carfax.org.uk>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <fc348976-2180-0457-7f81-a771ad03f88e@suse.com>
Date:   Tue, 12 Mar 2019 16:24:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190312141937.GC15963@carfax.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 12.03.19 г. 16:19 ч., Hugo Mills wrote:
> On Tue, Mar 12, 2019 at 04:16:29PM +0200, Nikolay Borisov wrote:
>>
>>
>> On 12.03.19 г. 15:22 ч., Anand Jain wrote:
>>> From: Anand Jain <Anand.Jain@oracle.com>
>>>
>>> The cli 'btrfs inspect dump-tree <dev>' will scan for the partner devices
>>> if any by default.
>>>
>>> So as of now you can not inspect each mirrored device independently.
>>>
>>> This patch adds noscan option, which when used won't scan the system for
>>> the partner devices, instead it just uses the devices provided in the
>>> argument.
>>>
>>> For example:
>>>   btrfs inspect dump-tree --noscan <dev> [<dev>..]
>>>
>>> This helps to debug degraded raid1 and raid10.
>>
>> This is a much more clear and concise description of what you want to
>> achieve. However, I don't think noscan is a good name, how about
>> --use-dev or --force-dev or something like that ? I'll also like David
>> to chime in on a particular naming. Don't be quick to send another version.
> 
>    How about --one-device, or just --device <dev1> --device <dev2> ..

I like the --device option
.
> 
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> ---
>>> v4->v5: nit: use %m to print error string.
>>> 	changelog update.
>>> v3->v4: change the patch title.
>>> 	collapse scan_args() to its only parent cmd_inspect_dump_tree()
>>> 	(it was bit confusing).
>>> 	update the change log.
>>> 	update usage.
>>> 	update man page.
>>> v2->v3: make it scalable for more than two disks in noscan mode
>>> v1->v2: rename --degraded to --noscan
>>>
>>>  Documentation/btrfs-inspect-internal.asciidoc |  5 ++-
>>>  cmds-inspect-dump-tree.c                      | 53 +++++++++++++++++++++------
>>>  2 files changed, 45 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
>>> index 381497d284b8..f9d7f1c58f00 100644
>>> --- a/Documentation/btrfs-inspect-internal.asciidoc
>>> +++ b/Documentation/btrfs-inspect-internal.asciidoc
>>> @@ -61,7 +61,7 @@ specify which mirror to print, valid values are 0, 1 and 2 and the superblock
>>>  must be present on the device with a valid signature, can be used together with
>>>  '--force'
>>>  
>>> -*dump-tree* [options] <device>::
>>> +*dump-tree* [options] <device> [device...]::
>>>  (replaces the standalone tool *btrfs-debug-tree*)
>>>  +
>>>  Dump tree structures from a given device in textual form, expand keys to human
>>> @@ -95,6 +95,9 @@ intermixed in the output
>>>  --bfs::::
>>>  use breadth-first search to print trees. the nodes are printed before all
>>>  leaves
>>> +--noscan::::
>>> +do not scan the system for other partner device(s), only use the device(s)
>>> +provided in the argument
>>>  -t <tree_id>::::
>>>  print only the tree with the specified ID, where the ID can be numerical or
>>>  common name in a flexible human readable form
>>> diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
>>> index ad5345b4f1db..37d9b29fa824 100644
>>> --- a/cmds-inspect-dump-tree.c
>>> +++ b/cmds-inspect-dump-tree.c
>>> @@ -21,6 +21,7 @@
>>>  #include <unistd.h>
>>>  #include <uuid/uuid.h>
>>>  #include <getopt.h>
>>> +#include <fcntl.h>
>>>  
>>>  #include "kerncompat.h"
>>>  #include "radix-tree.h"
>>> @@ -185,7 +186,7 @@ static u64 treeid_from_string(const char *str, const char **end)
>>>  }
>>>  
>>>  const char * const cmd_inspect_dump_tree_usage[] = {
>>> -	"btrfs inspect-internal dump-tree [options] device",
>>> +	"btrfs inspect-internal dump-tree [options] <device> [<device> ..]",
>>>  	"Dump tree structures from a given device",
>>>  	"Dump tree structures from a given device in textual form, expand keys to human",
>>>  	"readable equivalents where possible.",
>>> @@ -200,6 +201,7 @@ const char * const cmd_inspect_dump_tree_usage[] = {
>>>  	"-b|--block <block_num> print info from the specified block only",
>>>  	"-t|--tree <tree_id>    print only tree with the given id (string or number)",
>>>  	"--follow               use with -b, to show all children tree blocks of <block_num>",
>>> +	"--noscan               do not scan for the partner device(s)",
>>>  	NULL
>>>  };
>>>  
>>> @@ -214,7 +216,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>>  	struct btrfs_disk_key disk_key;
>>>  	struct btrfs_key found_key;
>>>  	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
>>> -	int ret;
>>> +	int ret = 0;
>>>  	int slot;
>>>  	int extent_only = 0;
>>>  	int device_only = 0;
>>> @@ -222,6 +224,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>>  	int roots_only = 0;
>>>  	int root_backups = 0;
>>>  	int traverse = BTRFS_PRINT_TREE_DEFAULT;
>>> +	int dev_optind;
>>>  	unsigned open_ctree_flags;
>>>  	u64 block_only = 0;
>>>  	struct btrfs_root *tree_root_scan;
>>> @@ -239,8 +242,8 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>>  	optind = 0;
>>>  	while (1) {
>>>  		int c;
>>> -		enum { GETOPT_VAL_FOLLOW = 256, GETOPT_VAL_DFS,
>>> -		       GETOPT_VAL_BFS };
>>> +		enum { GETOPT_VAL_FOLLOW = 256, GETOPT_VAL_DFS, GETOPT_VAL_BFS,
>>> +		       GETOPT_VAL_NOSCAN};
>>>  		static const struct option long_options[] = {
>>>  			{ "extents", no_argument, NULL, 'e'},
>>>  			{ "device", no_argument, NULL, 'd'},
>>> @@ -252,6 +255,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>>  			{ "follow", no_argument, NULL, GETOPT_VAL_FOLLOW },
>>>  			{ "bfs", no_argument, NULL, GETOPT_VAL_BFS },
>>>  			{ "dfs", no_argument, NULL, GETOPT_VAL_DFS },
>>> +			{ "noscan", no_argument, NULL, GETOPT_VAL_NOSCAN },
>>>  			{ NULL, 0, NULL, 0 }
>>>  		};
>>>  
>>> @@ -313,24 +317,49 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>>  		case GETOPT_VAL_BFS:
>>>  			traverse = BTRFS_PRINT_TREE_BFS;
>>>  			break;
>>> +		case GETOPT_VAL_NOSCAN:
>>> +			open_ctree_flags |= OPEN_CTREE_NO_DEVICES;
>>> +			break;
>>>  		default:
>>>  			usage(cmd_inspect_dump_tree_usage);
>>>  		}
>>>  	}
>>>  
>>> -	if (check_argc_exact(argc - optind, 1))
>>> +	if (check_argc_min(argc - optind, 1))
>>>  		usage(cmd_inspect_dump_tree_usage);
>>>  
>>> -	ret = check_arg_type(argv[optind]);
>>> -	if (ret != BTRFS_ARG_BLKDEV && ret != BTRFS_ARG_REG) {
>>> +	dev_optind = optind;
>>> +	while (dev_optind < argc) {
>>> +		int fd;
>>> +		struct btrfs_fs_devices *fs_devices;
>>> +		u64 num_devices;
>>> +
>>> +		ret = check_arg_type(argv[optind]);
>>> +		if (ret != BTRFS_ARG_BLKDEV && ret != BTRFS_ARG_REG) {
>>> +			if (ret < 0) {
>>> +				errno = -ret;
>>> +				error("invalid argument %s: %m", argv[dev_optind]);
>>> +			} else {
>>> +				error("not a block device or regular file: %s",
>>> +				       argv[dev_optind]);
>>> +			}
>>> +		}
>>> +		fd = open(argv[dev_optind], O_RDONLY);
>>> +		if (fd < 0) {
>>> +			error("cannot open %s: %m", argv[dev_optind]);
>>> +			return -EINVAL;
>>> +		}
>>> +		ret = btrfs_scan_one_device(fd, argv[dev_optind], &fs_devices,
>>> +					    &num_devices,
>>> +					    BTRFS_SUPER_INFO_OFFSET,
>>> +					    SBREAD_DEFAULT);
>>> +		close(fd);
>>>  		if (ret < 0) {
>>>  			errno = -ret;
>>> -			error("invalid argument %s: %m", argv[optind]);
>>> -		} else {
>>> -			error("not a block device or regular file: %s",
>>> -			      argv[optind]);
>>> +			error("device scan %s: %m", argv[dev_optind]);
>>> +			return ret;
>>>  		}
>>> -		goto out;
>>> +		dev_optind++;
>>>  	}
>>>  
>>>  	printf("%s\n", PACKAGE_STRING);
>>>
> 
