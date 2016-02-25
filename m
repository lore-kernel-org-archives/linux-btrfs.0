Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43369 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753293AbcBYAnI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 19:43:08 -0500
Subject: Re: [PATCH 5/5] btrfs-progs: misc-test: Add regression test for
 find-root gives empty result
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1456124397-21403-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1456124397-21403-6-git-send-email-quwenruo@cn.fujitsu.com>
 <20160224121051.GB23746@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56CE4CA9.6080106@cn.fujitsu.com>
Date: Thu, 25 Feb 2016 08:36:57 +0800
MIME-Version: 1.0
In-Reply-To: <20160224121051.GB23746@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/02/24 13:10 +0100:
> On Mon, Feb 22, 2016 at 02:59:57PM +0800, Qu Wenruo wrote:
>> zA}GrL`3QeIdg)w^i(C5r-$jn2OSESOZGFpc5^m2cCgLRjc8Y&wBj@6PxG<e;@Q)<_
>> Mne-=t|1Sdn0?V+~RR910
>>
>> literal 0
>> HcmV?d00001
>>
>> diff --git a/tests/misc-tests/012-find-root-no-result/test.sh b/tests/misc-tests/012-find-root-no-result/test.sh
>> new file mode 100644
>> index 0000000..4951633
>> --- /dev/null
>> +++ b/tests/misc-tests/012-find-root-no-result/test.sh
>> @@ -0,0 +1,20 @@
>> +#!/bin/bash
>> +# Regression test for case btrfs-find-root may print no result on a
>> +# recent fs or balanced fs, whose metadata chunk is the first chunk
>> +# and the only metadata chunk
>> +
>> +source $TOP/tests/common
>> +
>> +check_prereq btrfs-find-root
>> +check_prereq btrfs-image
>> +
>> +$TOP/btrfs-image -r first_meta_chunk.btrfs-image test.img || \
>> +	_fail "failed to extract first_meta_chunk.btrfs-image"
>> +
>> +result=$($TOP/btrfs-find-root test.img | sed '/^Superblock/d')
>> +
>> +if [ -z "$result" ]; then
>> +	_fail "btrfs-find-root failed to find tree root"
>> +fi
>> +
>> +rm test.img
>
> Applied with following fixups:
>
> --- a/tests/misc-tests/012-find-root-no-result/test.sh
> +++ b/tests/misc-tests/012-find-root-no-result/test.sh
> @@ -8,13 +8,17 @@ source $TOP/tests/common
>   check_prereq btrfs-find-root
>   check_prereq btrfs-image
>
> -$TOP/btrfs-image -r first_meta_chunk.btrfs-image test.img || \
> +run_check $TOP/btrfs-image -r first_meta_chunk.btrfs-image test.img || \
>          _fail "failed to extract first_meta_chunk.btrfs-image"
>

Thanks, I just forget that we have run_check suffix to handle errors.

> -result=$($TOP/btrfs-find-root test.img | sed '/^Superblock/d')
> +result=$(run_check_stdout $TOP/btrfs-find-root test.img | sed '/^Superblock/d')
>
>   if [ -z "$result" ]; then
>          _fail "btrfs-find-root failed to find tree root"
>   fi
>
> +if ! echo "$result" | grep -q 'Found tree root at'; then
> +       _fail "btrfs-find-root failed to find tree root, unexpected output"
> +fi
> +
Right, if btrfs-find-root failed to find the tree root matches with 
superblock, it's also a bug.

Thanks,
Qu
>   rm test.img
>
>
>


