Return-Path: <SRS0=DOz6=SN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ECDBC10F13
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 07:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06F5E206DF
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 07:29:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="AjT+nA6F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfDKH3D (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Apr 2019 03:29:03 -0400
Received: from mout.gmx.net ([212.227.15.19]:33659 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfDKH3D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Apr 2019 03:29:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554967730;
        bh=qjCcn8PuFY5U+HFHkeQIM7xT1TTyDr7E8jvP627cfu4=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=AjT+nA6F066mKhzQuIrAHrMZFo6oSw79fKjR2F2b/UbUEn9yrnzb+8mGDU+445JJp
         P8DFPpfqZI+kuEXG48c0jkUHeRmnerSRsbnKaIl3JUXBShrrqHrB6z+Yv+m/AnYult
         mCJCdMxt1/xIJnayYh8hC7zdz9da2U71ymio1aWQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Llm9w-1gf9Jx0C9Y-00ZP8Y; Thu, 11
 Apr 2019 09:28:49 +0200
Subject: Re: [PATCH v5 RESEND] btrfs-progs: dump-tree: add noscan option
To:     Nikolay Borisov <nborisov@suse.com>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20190404072957.2847-1-anand.jain@oracle.com>
 <121e7005-2535-c3d3-d779-9401db10bfa9@gmx.com>
 <e46d41f4-6f40-b8cb-fe2d-6ddd3b9458e4@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <839115e0-3874-97e1-a3d9-fe35daaeb782@gmx.com>
Date:   Thu, 11 Apr 2019 15:28:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <e46d41f4-6f40-b8cb-fe2d-6ddd3b9458e4@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Nj8GckORRhYkeWScbuaH27HHVw8dDTZHA3+ycMbLeK8KUobR0GX
 4Og75Z98PKcSHa/k1LagKiUJN7zCEZatd8U2LnAr7QUML5AlzRVL5LXY+2B+5YIhTZob/M8
 ccpvhm0WsMlY275UYkfPl4zVgRfKxOPErNTr4eFI7pffxzidCEILToBVG/k18e2Q1T5v+QB
 Apnlh9J0ciBOL1O6Q2z6g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:6gq5hkDvEvI=:bTfROFd6r6Nw4xOj+c3z+8
 U6rwY19Tj6YazE34TXL6XHB9a5kxmaBZSblbHavw7OYdXtWIfT1tSqm0I8J1Egzc5zVuUNsgV
 EfdD5KXHFnAnuHLbWZMwjsE2LLMe3psArUCEsc8YqrhakgUtxCf8ek4aVMSpQr4l8Y+qW9W1/
 MSKYmKCTd0fwREZqI/+CfFkn8zuBLv0K5GLkYzlbTwko+9f00+haGC3F3EkCi+67RBQL8srod
 JQxc9RVHlhajlBzSHCMwAAdedSSGp0pYsVUze0P4vfp4vSRToys1cwJ2OkByMxFxeUUZfpr/4
 q+Uvc/UiUkph2nEHthh8o8IDTfNz1QFL5JjCs/mG3UpF+iCyJGbA6vCyhBQVlnEhtJ1fdVWRg
 VuayRfYYJcRS+FdhRw7ppKdGeK2q36Eqjhcy4DNbjF9Vfgn5AxLNcYdTnm0D3JWN1WHYQZSFD
 yK7hocMSyEbXKbHf59vpW/V/+wossKJ3aX8kfFLkxpBi+CBN5RSIP1z0zIGEwinYS4MJAN9YI
 mCzhdlBWKzJ2xI4Meny9F9Xe4akUV1MQ7DpxoVBT3Xu5eawBsAzMWo9r1IMeyjP/cb2CpAgkt
 7qVlBlPOntr3O4ev45K9nOlRfQjbaCJjehBVUNtej1rtyUaALwsitO7yZgQd5bhy+Hg8MWKsw
 sB7ZTVLBWTDMYzhdtIq+LAMmJkvcocr49Q0ZambYMydGcOAk6ht54N4xBUNuxuXjaUcZGSjTA
 MKRGylChtoJFOucnCuQRvuX2jBZkhSFDbSjagiLIdXywvD1zJORgje4p7rCCFmJL4P9LcENKQ
 Z1a+EofbgoCQlGXkS7DTLRQMTs/QpiNA6Id8I04lreC1nROiQd0CQePcamBOLF5tIeDrJpqEG
 1Klr359sLrBsPDk1OCd1k24hglv266wrYvQUTRSDOE0c0vGbQryE9Z+izAjhOJG9SWALtzzC/
 ZpxE81oZrRQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/4/11 =E4=B8=8B=E5=8D=882:52, Nikolay Borisov wrote:
>
>
> On 11.04.19 =D0=B3. 7:53 =D1=87., Qu Wenruo wrote:
>>
>>
>> On 2019/4/4 =E4=B8=8B=E5=8D=883:29, Anand Jain wrote:
>>> From: Anand Jain <Anand.Jain@oracle.com>
>>>
>>> The cli 'btrfs inspect dump-tree <dev>' will scan for the partner devi=
ces
>>> if any by default.
>>>
>>> So as of now you can not inspect each mirrored device independently.
>>>
>>> This patch adds noscan option, which when used won't scan the system f=
or
>>> the partner devices, instead it just uses the devices provided in the
>>> argument.
>>>
>>> For example:
>>>   btrfs inspect dump-tree --noscan <dev> [<dev>..]
>>
>> So you can specify multiple devices, just like kernel "device=3D" mount
>> option.
>>
>> Then I don't think --noscan is a good naming, while I don't have any
>> good alternative, as the --degraded is no better.
>
> How about skipscan ?

I still prefer "--device=3D", no surprise, anyone who used "device=3D" mou=
nt
option knows what it is.

The only problem is, when only using one device, it will be super stupid:
  dump-tree --device /dev/sda /dev/sda

If this doesn't sound good, then --noscan is good enough AFAIK.

Thanks,
Qu

>
>>
>> My idea is "(--device=3D<dev1>,<dev2>)|(<dev>)", but that looks more aw=
ful.
>>
>> Despite of that, the patch looks pretty good.
>>
>>>
>>> This helps to debug degraded raid1 and raid10.
>>>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> ---
>>> v4->v5: nit: use %m to print error string.
>>> 	changelog update.
>>> v3->v4: change the patch title.
>>> 	collapse scan_args() to its only parent cmd_inspect_dump_tree()
>>> 	(it was bit confusing).
>>
>> I don't this is the correct direction.
>>
>> You're introducing "--device=3D" btrfs-progs equivalent, there is no wa=
y
>> it will only be utilized by dump-tree.
>>
>> Btrfs-check, btrfs-restore can all take advantage of this feature.
>>
>> You don't need to resend, later code can export them when needed.
>> But doing it at the first place really helps.
>>
>> Thanks,
>> Qu
>>
>>> 	update the change log.
>>> 	update usage.
>>> 	update man page.
>>> v2->v3: make it scalable for more than two disks in noscan mode
>>> v1->v2: rename --degraded to --noscan
>>>
>>>  Documentation/btrfs-inspect-internal.asciidoc |  5 ++-
>>>  cmds-inspect-dump-tree.c                      | 53 ++++++++++++++++++=
+++------
>>>  2 files changed, 45 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documenta=
tion/btrfs-inspect-internal.asciidoc
>>> index 381497d284b8..f9d7f1c58f00 100644
>>> --- a/Documentation/btrfs-inspect-internal.asciidoc
>>> +++ b/Documentation/btrfs-inspect-internal.asciidoc
>>> @@ -61,7 +61,7 @@ specify which mirror to print, valid values are 0, 1=
 and 2 and the superblock
>>>  must be present on the device with a valid signature, can be used tog=
ether with
>>>  '--force'
>>>
>>> -*dump-tree* [options] <device>::
>>> +*dump-tree* [options] <device> [device...]::
>>>  (replaces the standalone tool *btrfs-debug-tree*)
>>>  +
>>>  Dump tree structures from a given device in textual form, expand keys=
 to human
>>> @@ -95,6 +95,9 @@ intermixed in the output
>>>  --bfs::::
>>>  use breadth-first search to print trees. the nodes are printed before=
 all
>>>  leaves
>>> +--noscan::::
>>> +do not scan the system for other partner device(s), only use the devi=
ce(s)
>>> +provided in the argument
>>>  -t <tree_id>::::
>>>  print only the tree with the specified ID, where the ID can be numeri=
cal or
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
>>> @@ -185,7 +186,7 @@ static u64 treeid_from_string(const char *str, con=
st char **end)
>>>  }
>>>
>>>  const char * const cmd_inspect_dump_tree_usage[] =3D {
>>> -	"btrfs inspect-internal dump-tree [options] device",
>>> +	"btrfs inspect-internal dump-tree [options] <device> [<device> ..]",
>>>  	"Dump tree structures from a given device",
>>>  	"Dump tree structures from a given device in textual form, expand ke=
ys to human",
>>>  	"readable equivalents where possible.",
>>> @@ -200,6 +201,7 @@ const char * const cmd_inspect_dump_tree_usage[] =
=3D {
>>>  	"-b|--block <block_num> print info from the specified block only",
>>>  	"-t|--tree <tree_id>    print only tree with the given id (string or=
 number)",
>>>  	"--follow               use with -b, to show all children tree block=
s of <block_num>",
>>> +	"--noscan               do not scan for the partner device(s)",
>>>  	NULL
>>>  };
>>>
>>> @@ -214,7 +216,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>>  	struct btrfs_disk_key disk_key;
>>>  	struct btrfs_key found_key;
>>>  	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
>>> -	int ret;
>>> +	int ret =3D 0;
>>>  	int slot;
>>>  	int extent_only =3D 0;
>>>  	int device_only =3D 0;
>>> @@ -222,6 +224,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>>  	int roots_only =3D 0;
>>>  	int root_backups =3D 0;
>>>  	int traverse =3D BTRFS_PRINT_TREE_DEFAULT;
>>> +	int dev_optind;
>>>  	unsigned open_ctree_flags;
>>>  	u64 block_only =3D 0;
>>>  	struct btrfs_root *tree_root_scan;
>>> @@ -239,8 +242,8 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>>  	optind =3D 0;
>>>  	while (1) {
>>>  		int c;
>>> -		enum { GETOPT_VAL_FOLLOW =3D 256, GETOPT_VAL_DFS,
>>> -		       GETOPT_VAL_BFS };
>>> +		enum { GETOPT_VAL_FOLLOW =3D 256, GETOPT_VAL_DFS, GETOPT_VAL_BFS,
>>> +		       GETOPT_VAL_NOSCAN};
>>>  		static const struct option long_options[] =3D {
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
>>>  			traverse =3D BTRFS_PRINT_TREE_BFS;
>>>  			break;
>>> +		case GETOPT_VAL_NOSCAN:
>>> +			open_ctree_flags |=3D OPEN_CTREE_NO_DEVICES;
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
>>> -	ret =3D check_arg_type(argv[optind]);
>>> -	if (ret !=3D BTRFS_ARG_BLKDEV && ret !=3D BTRFS_ARG_REG) {
>>> +	dev_optind =3D optind;
>>> +	while (dev_optind < argc) {
>>> +		int fd;
>>> +		struct btrfs_fs_devices *fs_devices;
>>> +		u64 num_devices;
>>> +
>>> +		ret =3D check_arg_type(argv[optind]);
>>> +		if (ret !=3D BTRFS_ARG_BLKDEV && ret !=3D BTRFS_ARG_REG) {
>>> +			if (ret < 0) {
>>> +				errno =3D -ret;
>>> +				error("invalid argument %s: %m", argv[dev_optind]);
>>> +			} else {
>>> +				error("not a block device or regular file: %s",
>>> +				       argv[dev_optind]);
>>> +			}
>>> +		}
>>> +		fd =3D open(argv[dev_optind], O_RDONLY);
>>> +		if (fd < 0) {
>>> +			error("cannot open %s: %m", argv[dev_optind]);
>>> +			return -EINVAL;
>>> +		}
>>> +		ret =3D btrfs_scan_one_device(fd, argv[dev_optind], &fs_devices,
>>> +					    &num_devices,
>>> +					    BTRFS_SUPER_INFO_OFFSET,
>>> +					    SBREAD_DEFAULT);
>>> +		close(fd);
>>>  		if (ret < 0) {
>>>  			errno =3D -ret;
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
>>
