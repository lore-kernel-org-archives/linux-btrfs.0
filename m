Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12502 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751550AbcLNAxf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Dec 2016 19:53:35 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 64A6C4670486
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Dec 2016 08:52:47 +0800 (CST)
Subject: Re: [PATCH 3/3] btrfs-progs: convert-test: trigger chunk allocation
 after convert
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
References: <20161213094415.30912-1-quwenruo@cn.fujitsu.com>
 <20161213094415.30912-4-quwenruo@cn.fujitsu.com>
 <3f0a48ad-9e38-1919-530c-537acf342b5a@jp.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <397f8ce3-428d-798f-f79e-f1d72476d760@cn.fujitsu.com>
Date: Wed, 14 Dec 2016 08:52:46 +0800
MIME-Version: 1.0
In-Reply-To: <3f0a48ad-9e38-1919-530c-537acf342b5a@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 12/14/2016 07:51 AM, Tsutomu Itoh wrote:
> On 2016/12/13 18:44, Qu Wenruo wrote:
>> Populate fs after convert so we can trigger data chunk allocation.
>> This can expose too restrict old rollback condition
>>
>> Reported-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  tests/common         | 4 ++++
>>  tests/common.convert | 3 +++
>>  2 files changed, 7 insertions(+)
>>
>> diff --git a/tests/common b/tests/common
>> index 571118a..4a1330f 100644
>> --- a/tests/common
>> +++ b/tests/common
>> @@ -486,6 +486,10 @@ generate_dataset() {
>>  				run_check $SUDO_HELPER ln -s "$dirpath/$long_filename" "$dirpath/slow_slink.$num"
>>  			done
>>  			;;
>> +		large)
>> +			run_check $SUDO_HELPER dd if=/dev/urandom bs=32M count=1 \
>> +			of="$dirpath/$dataset_type" bs=32M >/dev/null 2>&1
>> +			;;
>
> Too many bs=.
>
> Thanks,
> Tsutomu

Oh, right.

Thanks for pointing it out, I'll update it soon.

Thanks,
Qu
>
>>  	esac
>>  }
>>
>> diff --git a/tests/common.convert b/tests/common.convert
>> index a2d3152..8c9242e 100644
>> --- a/tests/common.convert
>> +++ b/tests/common.convert
>> @@ -160,6 +160,9 @@ convert_test_post_checks_all() {
>>  	convert_test_post_check_checksums "$1"
>>  	convert_test_post_check_permissions "$2"
>>  	convert_test_post_check_acl "$3"
>> +
>> +	# Create a large file to trigger data chunk allocation
>> +	generate_dataset "large"
>>  	run_check_umount_test_dev
>>  }
>>
>>
>
>
>


