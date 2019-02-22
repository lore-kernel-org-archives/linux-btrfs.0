Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ACF7C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 06:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E06AE207E0
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 06:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbfBVGXv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 01:23:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:57628 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725888AbfBVGXv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 01:23:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 314D6B17C;
        Fri, 22 Feb 2019 06:23:48 +0000 (UTC)
Subject: Re: [PATCH v2] shared/298: Wire btrfs support in get_free_sectors
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     dsterba@suse.cz, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190208114404.13505-1-nborisov@suse.com>
 <20190221171051.GC2713@desktop>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <d72dcb14-eb87-6173-cf47-0276196b6a72@suse.com>
Date:   Fri, 22 Feb 2019 08:23:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190221171051.GC2713@desktop>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 21.02.19 г. 19:10 ч., Eryu Guan wrote:
> On Fri, Feb 08, 2019 at 01:44:04PM +0200, Nikolay Borisov wrote:
>> Add support for btrfs in shared/298. Achieve this by introducing 2
>> new awk scripts that parse relevant btrfs structures and print holes.
>> Additionally modify the test to create larger - 3gb filesystem in the
>> case of btrfs. This is needed so that distinct block groups are used
>> for data and metadata.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Sorry for the late review.. I find that parsing btrfs extent and dev
> tree is very btrfs-specific, it'd be great if btrfs folks could help
> review the two awk scripts as well!
> 
>> ---
>>
>> V2: 
>>  * Changed the way args are passed to mkfs.btrfs to preserve existing 
>>  options, yet override data/metadata profile settings
>>
>>  parse-dev-tree.awk    |  47 +++++++++++++++++++
>>  parse-extent-tree.awk | 125 ++++++++++++++++++++++++++++++++++++++++++++++++++
> 
> I'd prefer placing these files in src dir, instead of dumping them in
> top dir directly.

Ok

> 
>>  tests/shared/298      |  36 +++++++++++++--
>>  3 files changed, 205 insertions(+), 3 deletions(-)
>>  create mode 100755 parse-dev-tree.awk
>>  create mode 100755 parse-extent-tree.awk
>>
>> diff --git a/parse-dev-tree.awk b/parse-dev-tree.awk
>> new file mode 100755
>> index 000000000000..52f9c0aadc25
>> --- /dev/null
>> +++ b/parse-dev-tree.awk
>> @@ -0,0 +1,47 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2019 Nikolay Borisov, SUSE LLC.  All Rights Reserved.
>> +#
>> +# Parses btrfs' device tree for holes, required parameters passed on command
> 
> I find this description not very useful, would you please describe the
> expected output and format as well?

Ok will make it a bit more verbose

> 
>> +# line:
>> +#     * spb - how many bytes per sector, this is used so that the numbers 
>            ^^^ This is misleading, in shared/298 spb represents "sector
> 	   per block", but here it's really sector size.

Yeah probably should rename it.

> 
>> +# 		returned by the script are in sectors.
>> +#	  * devsize - size of the device in bytes, used to output the final 
> 
> This line is not aligned with above line, it contains leading tab.
> 
>> +# 		hole (if any)
>> +
>> +function get_extent_size(line,  tmp) {
> 
> Would you please document the expected intput and output in comment as
> well? So it's easier to review.
> 
> Also, is the 'tmp' argument really needed?

tmp in this case is really a function-local variable as per:
https://www.gnu.org/software/gawk/manual/html_node/Variable-Scope.html :

"Unlike in many languages, there is no way to make a variable local to a
{ … } block in awk, but you can make a variable local to a function. It
is good practice to do so whenever a variable is needed only in that
function."


> 
>> +	split(line, tmp)
>> +	return tmp[6]
>> +}
>> +
>> +function get_extent_offset(line,  tmp) {
> 
> Same here.
> 
>> +	split(line, tmp)
>> +	gsub(/\)/,"", tmp[6])
>> +	return tmp[6]
>> +}
>> +
>> +BEGIN {
>> +	dev_extent_match="^.item [0-9]* key \\([0-9]* DEV_EXTENT [0-9]*\\).*"
>> +	dev_extent_len_match="^\\s*chunk_objectid [0-9]* chunk_offset [0-9]* length [0-9]*$"
>> +}
>> +
>> +{
>> +	if (match($0,dev_extent_match)) {
>> +		extent_offset = get_extent_offset($0)		
>> +		if (prev_extent_end) {
>> +			hole_size = extent_offset - prev_extent_end
>> +			if (hole_size > 0) {
>> +				print prev_extent_end / spb, int((extent_offset - 1) / spb)
>> +			}
>> +		} 
>> +	} else if (match($0, dev_extent_len_match)) {
>> +		extent_size = get_extent_size($0)
>> +		prev_extent_end = extent_offset + extent_size
>> +	}
>> +}
>> +
>> +END {
>> +	if (prev_extent_end) {
>> +		print prev_extent_end / spb, int((devsize - 1) / spb)
>> +	}
>> +}
>> +
>> diff --git a/parse-extent-tree.awk b/parse-extent-tree.awk
>> new file mode 100755
>> index 000000000000..01c61254cfef
>> --- /dev/null
>> +++ b/parse-extent-tree.awk
>> @@ -0,0 +1,125 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2019 Nikolay Borisov, SUSE LLC.  All Rights Reserved.
>> +#
>> +# Parses btrfs' extent tree for holes, required parameters passed on command
> 
> Same here, please provide more details.
> 
>> +# line:
>> +#     * spb - how many bytes per sector, this is used so that the numbers 
> 
> And replace 'spb' with a more proper variable name.
> 
>> +# 		returned by the script are in sectors.
>> +#	  * nodesize - size of metadata extents, used for internal calculations
> 
> Indention issue too.
> 
>> +
>> +function get_extent_size(line,  tmp) {
>> +	if (line ~ data_match || line ~ bg_match) {
>> +		split(line, tmp)
>> +		gsub(/\)/,"", tmp[6])
>> +		return tmp[6]
>> +	} else if (line ~ metadata_match) {
>> +		return nodesize
>> +	}
>> +}
>> +
>> +function get_extent_offset(line,  tmp) {
>> +	split(line, tmp)
>> +	gsub(/\(/,"",tmp[4])
>> +	return tmp[4]
>> +}
>> +
>> +function print_array(         base_offset, bg_line)
> 
> Document the expected input and output of these functions too.
> 
> And why there're so many spaces before 'base_offset' argument?

Again, those 2 are used as local variables as per early cited documentation.

> 
>> +{
>> +	if (match(lines[0], bg_match)) {
>> +		#we don't have an extent at the beginning of of blockgroup, so we
> 
> Add a space after '#' for comments.

Ok

<snip>

>>
> 
