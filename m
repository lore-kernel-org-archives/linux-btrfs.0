Return-Path: <SRS0=uD29=Q4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EBE9C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 08:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E539F20818
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 08:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfBUITw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Feb 2019 03:19:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:40382 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726594AbfBUITv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Feb 2019 03:19:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 84562AD95;
        Thu, 21 Feb 2019 08:19:49 +0000 (UTC)
Subject: Re: [PATCH v2] shared/298: Wire btrfs support in get_free_sectors
To:     guaneryu@gmail.com
Cc:     dsterb@suse.cz, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190208114404.13505-1-nborisov@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <fd001b5e-5376-dbde-ae4a-82fac7aa98da@suse.com>
Date:   Thu, 21 Feb 2019 10:19:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190208114404.13505-1-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 8.02.19 г. 13:44 ч., Nikolay Borisov wrote:
> Add support for btrfs in shared/298. Achieve this by introducing 2
> new awk scripts that parse relevant btrfs structures and print holes.
> Additionally modify the test to create larger - 3gb filesystem in the
> case of btrfs. This is needed so that distinct block groups are used
> for data and metadata.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>


Ping, I would really like to get this ASAP to get coverage for btrfs.

> ---
> 
> V2: 
>  * Changed the way args are passed to mkfs.btrfs to preserve existing 
>  options, yet override data/metadata profile settings
> 
>  parse-dev-tree.awk    |  47 +++++++++++++++++++
>  parse-extent-tree.awk | 125 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/shared/298      |  36 +++++++++++++--
>  3 files changed, 205 insertions(+), 3 deletions(-)
>  create mode 100755 parse-dev-tree.awk
>  create mode 100755 parse-extent-tree.awk
> 
> diff --git a/parse-dev-tree.awk b/parse-dev-tree.awk
> new file mode 100755
> index 000000000000..52f9c0aadc25
> --- /dev/null
> +++ b/parse-dev-tree.awk
> @@ -0,0 +1,47 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Nikolay Borisov, SUSE LLC.  All Rights Reserved.
> +#
> +# Parses btrfs' device tree for holes, required parameters passed on command
> +# line:
> +#     * spb - how many bytes per sector, this is used so that the numbers 
> +# 		returned by the script are in sectors.
> +#	  * devsize - size of the device in bytes, used to output the final 
> +# 		hole (if any)
> +
> +function get_extent_size(line,  tmp) {
> +	split(line, tmp)
> +	return tmp[6]
> +}
> +
> +function get_extent_offset(line,  tmp) {
> +	split(line, tmp)
> +	gsub(/\)/,"", tmp[6])
> +	return tmp[6]
> +}
> +
> +BEGIN {
> +	dev_extent_match="^.item [0-9]* key \\([0-9]* DEV_EXTENT [0-9]*\\).*"
> +	dev_extent_len_match="^\\s*chunk_objectid [0-9]* chunk_offset [0-9]* length [0-9]*$"
> +}
> +
> +{
> +	if (match($0,dev_extent_match)) {
> +		extent_offset = get_extent_offset($0)		
> +		if (prev_extent_end) {
> +			hole_size = extent_offset - prev_extent_end
> +			if (hole_size > 0) {
> +				print prev_extent_end / spb, int((extent_offset - 1) / spb)
> +			}
> +		} 
> +	} else if (match($0, dev_extent_len_match)) {
> +		extent_size = get_extent_size($0)
> +		prev_extent_end = extent_offset + extent_size
> +	}
> +}
> +
> +END {
> +	if (prev_extent_end) {
> +		print prev_extent_end / spb, int((devsize - 1) / spb)
> +	}
> +}
> +
> diff --git a/parse-extent-tree.awk b/parse-extent-tree.awk
> new file mode 100755
> index 000000000000..01c61254cfef
> --- /dev/null
> +++ b/parse-extent-tree.awk
> @@ -0,0 +1,125 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Nikolay Borisov, SUSE LLC.  All Rights Reserved.
> +#
> +# Parses btrfs' extent tree for holes, required parameters passed on command
> +# line:
> +#     * spb - how many bytes per sector, this is used so that the numbers 
> +# 		returned by the script are in sectors.
> +#	  * nodesize - size of metadata extents, used for internal calculations
> +
> +function get_extent_size(line,  tmp) {
> +	if (line ~ data_match || line ~ bg_match) {
> +		split(line, tmp)
> +		gsub(/\)/,"", tmp[6])
> +		return tmp[6]
> +	} else if (line ~ metadata_match) {
> +		return nodesize
> +	}
> +}
> +
> +function get_extent_offset(line,  tmp) {
> +	split(line, tmp)
> +	gsub(/\(/,"",tmp[4])
> +	return tmp[4]
> +}
> +
> +function print_array(         base_offset, bg_line)
> +{
> +	if (match(lines[0], bg_match)) {
> +		#we don't have an extent at the beginning of of blockgroup, so we
> +		#have a hole between blockgroup offset and first extent offset
> +		bg_line = lines[0]
> +		prev_size=0
> +		prev_offset=get_extent_offset(bg_line)
> +		delete lines[0]
> +	} else {
> +		#we have an extent at the beginning of block group, so initialize 
> +		#the prev_* vars correctly
> +		bg_line = lines[1]
> +		prev_size = get_extent_size(lines[0])
> +		prev_offset = get_extent_offset(lines[0])
> +		delete lines[1]
> +		delete lines[0]
> +	}
> +
> +	bg_offset=get_extent_offset(bg_line)
> +	bgend=bg_offset + get_extent_size(bg_line)
> +
> +	for (i in lines) {
> +			cur_size = get_extent_size(lines[i])
> +			cur_offset = get_extent_offset(lines[i])
> +			if (cur_offset  != prev_offset + prev_size)
> +				print int((prev_size + prev_offset) / spb), int((cur_offset-1) / spb)
> +			prev_size = cur_size
> +			prev_offset = cur_offset
> +	}
> +
> +	print int((prev_size + prev_offset) / spb), int((bgend-1) / spb)
> +	total_printed++
> +	delete lines
> +}
> +
> +BEGIN {
> +	loi_match="^.item [0-9]* key \\([0-9]* (BLOCK_GROUP_ITEM|METADATA_ITEM|EXTENT_ITEM) [0-9]*\\).*"
> +	metadata_match="^.item [0-9]* key \\([0-9]* METADATA_ITEM [0-9]*\\).*"
> +	data_match="^.item [0-9]* key \\([0-9]* EXTENT_ITEM [0-9]*\\).*"
> +	bg_match="^.item [0-9]* key \\([0-9]* BLOCK_GROUP_ITEM [0-9]*\\).*"
> +	node_match="^node.*$"
> +	leaf_match="^leaf [0-9]* flags"
> +	line_count=0
> +	total_printed=0
> +	skip_lines=0
> +}
> +
> +{
> +	#skip lines not belonging to a leaf
> +	if (match($0,node_match)) {
> +		skip_lines=1
> +	} else if (match($0, leaf_match)) {
> +		skip_lines=0
> +	}
> +
> +	if (!match($0,loi_match) || skip_lines == 1) next;
> +
> +	#we have a line of interest, we need to parse it. First check if there is
> +	#anything in the array
> +	if (line_count==0) {
> +		lines[line_count++]=$0;
> +	} else {
> +		prev_line=lines[line_count-1]
> +		split(prev_line, prev_line_fields)
> +		prev_objectid=prev_line_fields[4]
> +		objectid=$4
> +
> +		if (objectid == prev_objectid && match($0, bg_match)) {
> +			if (total_printed>0) {
> +				#We are adding a BG after we have added its first extent
> +				#previously, consider this a record ending event and just print
> +				#the array
> +
> +				delete lines[line_count-1]
> +				print_array()
> +				#we now start a new array with current and previous lines
> +				line_count=0
> +				lines[line_count++]=prev_line
> +				lines[line_count++]=$0
> +			} else {
> +				#first 2 added lines are EXTENT and BG that match, in this case
> +				#just add them
> +				lines[line_count++]=$0
> +				
> +			}
> +		} else if (match($0, bg_match)) {
> +			#ordinary end of record
> +			print_array()
> +			line_count=0
> +			lines[line_count++]=$0
> +		} else {
> +			lines[line_count++]=$0
> +		}
> +	}
> +}
> +
> +END {
> +	print_array()
> +}
> diff --git a/tests/shared/298 b/tests/shared/298
> index e7b7b233de45..8c053aa34adb 100755
> --- a/tests/shared/298
> +++ b/tests/shared/298
> @@ -15,14 +15,24 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  . ./common/rc
>  
> -_supported_fs ext4 xfs
> +_supported_fs ext4 xfs btrfs
>  _supported_os Linux
>  _require_test
>  _require_loop
>  _require_fstrim
>  _require_xfs_io_command "fiemap"
> -_require_fs_space $TEST_DIR 307200
> +if [ "$FSTYP" = "btrfs" ]; then
> +	# 3g for btrfs to have distinct bgs
> +	_require_fs_space $TEST_DIR 3145728
> +	fssize=3000
> +else
> +	_require_fs_space $TEST_DIR 307200
> +	fssize=300
> +fi
> +
>  [ "$FSTYP" = "ext4" ] && _require_dumpe2fs
> +[ "$FSTYP" = "btrfs" ] && _require_btrfs_command inspect-internal dump-super
> +[ "$FSTYP" = "btrfs" ] && _require_btrfs_command inspect-internal dump-tree
>  
>  _cleanup()
>  {
> @@ -61,6 +71,25 @@ get_free_sectors()
>  		 $AWK_PROG -v spb=$sectors_per_block -v agsize=$agsize \
>  		'{ print spb * ($1 * agsize + $2), spb * ($1 * agsize + $2 + $3) - 1 }'
>  	;;
> +	btrfs)
> +		local device_size=$($BTRFS_UTIL_PROG filesystem show --raw $loop_mnt 2>&1 \
> +			| sed -n "s/^.*size \([0-9]*\).*$/\1/p")
> +
> +		local nodesize=$($BTRFS_UTIL_PROG inspect-internal dump-super $img_file  \
> +			| sed -n 's/nodesize\s*\(.*\)/\1/p')
> +
> +		# Get holes within block groups
> +		local btrfs_free=$($BTRFS_UTIL_PROG inspect-internal dump-tree -t extent $img_file \
> +			| $AWK_PROG -v spb=512 -v nodesize=$nodesize -f parse-extent-tree.awk)
> +
> +		btrfs_free+="\n"
> +
> +		# Get holes within unallocated space on disk
> +		btrfs_free+=$($BTRFS_UTIL_PROG inspect-internal dump-tree -t dev $img_file \
> +			| $AWK_PROG -v spb=512 -v devsize=$device_size -f parse-dev-tree.awk)
> +
> +		echo -e "$btrfs_free"
> +	;;
>  	esac
>  }
>  
> @@ -105,7 +134,7 @@ here=`pwd`
>  tmp=`mktemp -d`
>  
>  img_file=$TEST_DIR/$$.fs
> -dd if=/dev/zero of=$img_file bs=1M count=300 &> /dev/null
> +dd if=/dev/zero of=$img_file bs=1M count=$fssize &> /dev/null
>  
>  loop_dev=$(_create_loop_device $img_file)
>  loop_mnt=$tmp/loop_mnt
> @@ -118,6 +147,7 @@ merged_sectors="$tmp/merged_free_sectors"
>  mkdir $loop_mnt
>  
>  [ "$FSTYP" = "xfs" ] && MKFS_OPTIONS="-f $MKFS_OPTIONS"
> +[ "$FSTYP" = "btrfs" ] && MKFS_OPTIONS="$MKFS_OPTIONS -f -dsingle -msingle"
>  
>  _mkfs_dev $loop_dev
>  _mount $loop_dev $loop_mnt
> 
