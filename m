Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw7a-t3e-f4f.wadns.net ([41.185.62.79]:36300 "EHLO
	fw7a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752443AbaFWLrI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 07:47:08 -0400
Message-ID: <53A81393.7000709@swiftspirit.co.za>
Date: Mon, 23 Jun 2014 13:46:27 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        fstests@vger.kernel.org
CC: linux-btrfs@vger.kernel.org, lczerner@redhat.com
Subject: Re: [PATCH] generic/017: skip invalid block sizes for btrfs
References: <1403519280-24216-1-git-send-email-fdmanana@gmail.com> <53A805EF.6060906@jp.fujitsu.com>
In-Reply-To: <53A805EF.6060906@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not subscribed to fstests so not sure if this will reach that mailing 
list...

I feel Takeuchi's instincts are right, even if the analysis *may* be 
wrong. As is it looks like there should be a btrfs) selector inside the 
case.

On 23/06/14 12:48, Satoru Takeuchi wrote:
> Hi Filipe,
>
> (2014/06/23 19:28), Filipe David Borba Manana wrote:
>> In btrfs the block size (called sector size in btrfs) can not be
>> smaller then the page size. Therefore skip block sizes smaller
>> then page size if the fs is btrfs, so that the test can succeed
>> on btrfs (testing only with block sizes of 4kb on systems with a
>> page size of 4Kb).
>>
>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> I consider it doesn't work since this test is not for Btrfs.
> Please see the following code.
>
> tests/generic/017:
> ===
> for (( BSIZE = 1024; BSIZE <= 4096; BSIZE *= 2 )); do
>
> 	length=$(($BLOCKS * $BSIZE))
> 	case $FSTYP in
> 	xfs)
> 	_scratch_mkfs -b size=$BSIZE >> $seqres.full 2>&1
> 	;;
> 	ext4)
> 	_scratch_mkfs -b $BSIZE >> $seqres.full 2>&1
> 	;;
> 	esac
> 	_scratch_mount >> $seqres.full 2>&1
> ===
>
> There is no btrfs here.
>
> This test was moved to shared/005 to generic/017
> at 21723cdbf303e031d6429f67fec9768750a5db7d.
>
> Original supported fs is here.
> ===============================================================================
> supported_fs xfs ext4
> ===============================================================================
>
> I suspect that Lukas moved this test to generic/ by mistake or forgot to
> add "$FSTYP == btrfs" case.
>
> Thanks,
> Satoru
>
>> ---
>>    tests/generic/017 | 8 ++++++++
>>    1 file changed, 8 insertions(+)
>>
>> diff --git a/tests/generic/017 b/tests/generic/017
>> index 13b7254..6495be5 100755
>> --- a/tests/generic/017
>> +++ b/tests/generic/017
>> @@ -51,6 +51,14 @@ BLOCKS=10240
>>    
>>    for (( BSIZE = 1024; BSIZE <= 4096; BSIZE *= 2 )); do
>>    
>> +	# btrfs doesn't support block size smaller then page size
>> +	if [ "$FSTYP" == "btrfs" ]; then
>> +		if (( $BSIZE < `getconf PAGE_SIZE` )); then
>> +			echo "80"
>> +			continue
>> +		fi
>> +	fi
>> +
>>    	length=$(($BLOCKS * $BSIZE))
>>    	case $FSTYP in
>>    	xfs)
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

