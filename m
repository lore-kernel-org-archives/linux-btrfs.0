Return-Path: <SRS0=uD29=Q4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A2DFC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 17:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9B552077B
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 17:10:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L3k/+JLq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbfBURK6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Feb 2019 12:10:58 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34434 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728402AbfBURK5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Feb 2019 12:10:57 -0500
Received: by mail-pg1-f196.google.com with SMTP id i130so13997270pgd.1;
        Thu, 21 Feb 2019 09:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9yXK62uZI224r0P+LroEuQvzV34wVqOaooK8wQGVBDc=;
        b=L3k/+JLqcDbWb5fu8iMRxqmk5E2UidP2JYTfySpS4bzAlf8WqUc7c4+skU4lHQFB2Q
         bJssIbHL7pdcvMm90mnb8pd6sKySQECW6oHen0fmX/SZADJo2JocLf1oM0N+R4s4B/M5
         vBEeQukgckyJ8rXgWPeYaDYFRXRGuJea2pSOxj7GAlD5+RAL2Hm/o6Ke/OPdQpBUG0Bm
         cAk87yAJwWaxqXczD4e2Dak4KFffOHHiOI/6f9oMF46yLB1v7Z+9/oV7/GokvQJYOxwA
         0HZJzt7HDng7ucugRskEbVYuNI4M/EgmgffXrMwaHGamEHT+WspNP//oHjdd3BgYc3F/
         njFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9yXK62uZI224r0P+LroEuQvzV34wVqOaooK8wQGVBDc=;
        b=Uv5YdofFJS7TYWjSTx29H5xtSQLOW84SvnXByRbKbOnKUPc6CKoJs6Dd3hMNQeKwoE
         5Je0L9oM0hu1B4hPpLjqdigG7qHvZt8qsRvenHi9HFxLzOilm9OIN3Tl9EBfc9DVaHAy
         CAQfX6SHAdoaM/GBUvLrTSTq+9JhZnHQEG8PwFZ+25QFQ2EIJNtmYzfC2wArbhboSASB
         XcUl+1GV+vMTEsohaRBz/fgjQ9w1N/98fx5ryx1vx6zxUS0+nrkSd0PWffpbQCzCTfbp
         wLYJdW/FEzylGEw3z8hIXiKjS7eh8mR/y0FOweBT8AZiKnx/Kspv8Xlj80GdistNby5t
         DjmA==
X-Gm-Message-State: AHQUAuZJyC7SFq1GQlY7hns0TqzHfMhKtLA0IlJeXtjxjni55zwKUsaB
        QFOSveD35HPry6NLXKHBaP+q4PFBqXQ=
X-Google-Smtp-Source: AHgI3Ib+xdAioOT6NXaVhuu/oSbPVLPHz71UV0eKG4Otp3ItEtr8hvqsTVo8P3GWWBZPlKagUUGGuA==
X-Received: by 2002:a62:c302:: with SMTP id v2mr41578845pfg.155.1550769056537;
        Thu, 21 Feb 2019 09:10:56 -0800 (PST)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id u184sm1530540pgd.13.2019.02.21.09.10.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Feb 2019 09:10:55 -0800 (PST)
Date:   Fri, 22 Feb 2019 01:10:51 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     dsterb@suse.cz, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] shared/298: Wire btrfs support in get_free_sectors
Message-ID: <20190221171051.GC2713@desktop>
References: <20190208114404.13505-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190208114404.13505-1-nborisov@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 08, 2019 at 01:44:04PM +0200, Nikolay Borisov wrote:
> Add support for btrfs in shared/298. Achieve this by introducing 2
> new awk scripts that parse relevant btrfs structures and print holes.
> Additionally modify the test to create larger - 3gb filesystem in the
> case of btrfs. This is needed so that distinct block groups are used
> for data and metadata.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Sorry for the late review.. I find that parsing btrfs extent and dev
tree is very btrfs-specific, it'd be great if btrfs folks could help
review the two awk scripts as well!

> ---
> 
> V2: 
>  * Changed the way args are passed to mkfs.btrfs to preserve existing 
>  options, yet override data/metadata profile settings
> 
>  parse-dev-tree.awk    |  47 +++++++++++++++++++
>  parse-extent-tree.awk | 125 ++++++++++++++++++++++++++++++++++++++++++++++++++

I'd prefer placing these files in src dir, instead of dumping them in
top dir directly.

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

I find this description not very useful, would you please describe the
expected output and format as well?

> +# line:
> +#     * spb - how many bytes per sector, this is used so that the numbers 
           ^^^ This is misleading, in shared/298 spb represents "sector
	   per block", but here it's really sector size.

> +# 		returned by the script are in sectors.
> +#	  * devsize - size of the device in bytes, used to output the final 

This line is not aligned with above line, it contains leading tab.

> +# 		hole (if any)
> +
> +function get_extent_size(line,  tmp) {

Would you please document the expected intput and output in comment as
well? So it's easier to review.

Also, is the 'tmp' argument really needed?

> +	split(line, tmp)
> +	return tmp[6]
> +}
> +
> +function get_extent_offset(line,  tmp) {

Same here.

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

Same here, please provide more details.

> +# line:
> +#     * spb - how many bytes per sector, this is used so that the numbers 

And replace 'spb' with a more proper variable name.

> +# 		returned by the script are in sectors.
> +#	  * nodesize - size of metadata extents, used for internal calculations

Indention issue too.

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

Document the expected input and output of these functions too.

And why there're so many spaces before 'base_offset' argument?

> +{
> +	if (match(lines[0], bg_match)) {
> +		#we don't have an extent at the beginning of of blockgroup, so we

Add a space after '#' for comments.

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

I don't think the "$btrfs_free" variable is needed, we could just let
awk print the result out.

Thanks,
Eryu

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
> -- 
> 2.7.4
> 
