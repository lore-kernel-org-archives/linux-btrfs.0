Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-01.prod.phx3.secureserver.net ([184.168.200.138]:50044
        "EHLO p3nlsmtpcp01-01.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751643AbcITQaF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 12:30:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 20 Sep 2016 10:28:59 -0600
From: lakshmipathi.g@giis.co.in
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH]btrfs-progs: Post btrfs-convert verify permissions and
 acls
In-Reply-To: <fb74fa46-43b2-80e3-a6e5-0026d8831e19@cn.fujitsu.com>
References: <20160905192736.GA2999@fedori>
 <fb74fa46-43b2-80e3-a6e5-0026d8831e19@cn.fujitsu.com>
Message-ID: <65cc4ab6e7601296c7054384c9e465f2@giis.co.in>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-19 20:17, Qu Wenruo wrote:
> Hi Laksmipathi,
> 
> At 09/06/2016 03:27 AM, Lakshmipathi.G wrote:
>> Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
>> ---
>>  tests/common.convert | 95 
>> +++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 94 insertions(+), 1 deletion(-)
>> 
>> diff --git a/tests/common.convert b/tests/common.convert
>> index 4e3d49c..67c99b1 100644
>> --- a/tests/common.convert
>> +++ b/tests/common.convert
>> @@ -123,6 +123,38 @@ convert_test_gen_checksums() {
>>  		count=1 >/dev/null 2>&1
>>  	run_check_stdout $SUDO_HELPER find $TEST_MNT -type f ! -name 'image' 
>> -exec md5sum {} \+ > "$CHECKSUMTMP"
>>  }
>> +# list $TEST_MNT data set file permissions.
>> +# $1: path where the permissions will be stored
>> +convert_test_perm() {
>> +	local PERMTMP
>> +	PERMTMP="$1"
>> +	FILES_LIST=$(mktemp --tmpdir btrfs-progs-convert.fileslistXXXXXX)
>> +
>> +	run_check $SUDO_HELPER dd if=/dev/zero of=$TEST_MNT/test 
>> bs=$nodesize \
>> +		count=1 >/dev/null 2>&1
>> +	run_check_stdout $SUDO_HELPER find $TEST_MNT -type f ! -name 'image' 
>> -fprint $FILES_LIST
>> +	#Fix directory entries order.
>> +	sort $FILES_LIST -o $FILES_LIST
>> +	for file in `cat $FILES_LIST` ;do
>> +		run_check_stdout $SUDO_HELPER getfacl --absolute-names $file >> 
>> "$PERMTMP"
>> +	done
>> +	rm $FILES_LIST
>> +}
>> +# list acls of files on $TEST_MNT
>> +# $1: path where the acls will be stored
>> +convert_test_acl() {
>> +	local ACLSTMP
>> +	ACLTMP="$1"
>> +	FILES_LIST=$(mktemp --tmpdir btrfs-progs-convert.fileslistXXXXXX)
>> +
>> +	run_check_stdout $SUDO_HELPER find $TEST_MNT/acls -type f -fprint 
>> $FILES_LIST
>> +	#Fix directory entries order.
>> +	sort $FILES_LIST -o $FILES_LIST
>> +	for file in `cat $FILES_LIST`;do
>> +		run_check_stdout $SUDO_HELPER getfattr --absolute-names -d $file >> 
>> "$ACLTMP"
>> +	done
>> +	rm $FILES_LIST
>> +}
>> 
>>  # do conversion with given features and nodesize, fsck afterwards
>>  # $1: features, argument of -O, can be empty
>> @@ -133,15 +165,68 @@ convert_test_do_convert() {
>>  	run_check $TOP/btrfs-show-super -Ffa $TEST_DEV
>>  }
>> 
>> +# post conversion check, verify file permissions.
>> +# $1: file with ext permissions.
>> +convert_test_post_check_permissions() {
>> +	local EXT_PERMTMP
>> +	local BTRFS_PERMTMP
>> +
>> +	EXT_PERMTMP="$1"
>> +	BTRFS_PERMTMP=$(mktemp --tmpdir btrfs-progs-convert.permXXXXXX)
>> +	convert_test_perm "$BTRFS_PERMTMP"
>> +
>> +	btrfs_perm=`md5sum $BTRFS_PERMTMP | cut -f1 -d' '`
>> +	ext_perm=`md5sum $EXT_PERMTMP | cut -f1 -d' '
> 
> When running test case 005, the test script hangs here.
> And EXT_PERMTMP seems to be empty, so md5sum is waiting input from
> stdio, causing the hang.
> 
> Any idea to fix it?
> 
> Thanks,
> Qu
> 

Hi Qu,

Can you confirm whether in-place 'sort' command used convert_test_perm() 
is creating appropriate sorted file and doesn't create empty file?


$ sort --version
sort (GNU coreutils) 8.22


Cheers,
Lakshmipathi.G
