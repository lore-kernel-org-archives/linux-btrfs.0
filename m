Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44297 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaETGhc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 02:37:32 -0400
Message-ID: <537AF8DD.6080703@oracle.com>
Date: Tue, 20 May 2014 14:40:29 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: label should not contain return char
References: <1400519071-5580-1-git-send-email-anand.jain@oracle.com> <537A3C6F.60608@redhat.com>
In-Reply-To: <537A3C6F.60608@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




On 20/05/14 01:16, Eric Sandeen wrote:
> On 5/19/14, 12:04 PM, Anand Jain wrote:
>> From: Anand Jain <Anand.Jain@oracle.com>
>>
>> generally if you use
>>    echo "test" > /sys/fs/btrfs/<fsid>/label
>> it would introduce return char at the end and it can not
>> be part of the label. The correct command is
>>    echo -n "test" > /sys/fs/btrfs/<fsid>/label
>>
>> This patch will check for this user error
>
> Wouldn't it be a lot better to just strip the "\n" if it
> exists?

  yes. Thanks Eric.

>> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
>> ---
>>   fs/btrfs/sysfs.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
>> index c5eb214..63c2907 100644
>> --- a/fs/btrfs/sysfs.c
>> +++ b/fs/btrfs/sysfs.c
>> @@ -374,7 +374,7 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
>>   	struct btrfs_root *root = fs_info->fs_root;
>>   	int ret;
>>
>> -	if (len >= BTRFS_LABEL_SIZE) {
>> +	if (len >= BTRFS_LABEL_SIZE || strchr(buf, '\n')) {
>>   		pr_err("BTRFS: unable to set label with more than %d bytes\n",
>>   		       BTRFS_LABEL_SIZE - 1);
>
> so if I do:
>
> # echo "mylabel" > /sys/fs/btrfs/<fsid>/label
>
> I'll get:
>
> BTRFS: unable to set label with more than 255 bytes"
>
> which would be pretty confusing, IMHO, given the short
> label I tried to create.
>
> Just strip out the \n ...
>
> -Eric
>
>>   		return -EINVAL;
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
