Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:59984 "EHLO
	mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbcCJXSj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 18:18:39 -0500
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 869BCAC02D5
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Mar 2016 08:18:32 +0900 (JST)
Subject: Re: [PATCH 1/2] btrfs-progs: Remove unnecessary variable devstart
 from cmd_device_scan()
To: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <56E0AC1B.3020405@jp.fujitsu.com>
 <20160310132744.GG18908@twin.jikos.cz>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <56E200C0.3040002@jp.fujitsu.com>
Date: Fri, 11 Mar 2016 08:18:24 +0900
MIME-Version: 1.0
In-Reply-To: <20160310132744.GG18908@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/03/10 22:27, David Sterba wrote:
> On Thu, Mar 10, 2016 at 08:04:59AM +0900, Satoru Takeuchi wrote:
>> It's unnecessary since it's always 1.
>>
>> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>> ---
>> This patch can be applied to devel (commit b2bdd0da8969).
>> ---
>>   cmds-device.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/cmds-device.c b/cmds-device.c
>> index cb470af..78d6535 100644
>> --- a/cmds-device.c
>> +++ b/cmds-device.c
>> @@ -246,7 +246,6 @@ static const char * const cmd_device_scan_usage[] = {
>>   static int cmd_device_scan(int argc, char **argv)
>>   {
>>   	int i;
>> -	int devstart = 1;
>>   	int all = 0;
>>   	int ret = 0;
>>
>> @@ -282,7 +281,7 @@ static int cmd_device_scan(int argc, char **argv)
>>   		goto out;
>>   	}
>>
>> -	for( i = devstart ; i < argc ; i++ ){
>> +	for (i = 1; i < argc; i++) {
>
> Actually it needs to be set to optind before the for cycle, otherwise:
>
>    # btrfs device scan -- /dev/sda
>    ERROR: not a block device: --

Thank you for your comment. I'll fix it.

Satoru
