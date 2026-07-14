Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38589191F94;
	Tue, 14 Jul 2026 01:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783992072; cv=none; b=rpUcJ1Obv4pcjLiC4uTGTDe4xaqfcZr1uMBCft395nN4zxmWFHp+xywZSTUqreu/CvQCgOVCPma8S4GtgxdQKOa/GJtKwxsa25VB9mlklyJkk4QA/Ct8MWXQlgWGJ9cx0hKmvVHXhqslUqGOk7ZbwLq71hpATvRlyTWq+iUyKBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783992072; c=relaxed/simple;
	bh=ebe55yTClWmXEW1qp9LWtrf7GlunDSZWhg58LNuPHPc=;
	h=Message-ID:Date:From:MIME-Version:To:CC:Subject:References:
	 In-Reply-To:Content-Type; b=Ko/T9QSpqsuIE2Ee2I2/yHpAnIDFVKcJuspz4k9Q+PDxzrBz8iRZK9TXbSKCkzTSkOem5UW4pQacFmotJBrZWeEf982rV0rV8nDa8JAAZV+yv9HdU9C2GaM/RcX85fCh17tngLp18pKUV8hhBj7wrnSCuiEBXc219Th3802bJ/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=MFt0lCTA; arc=none smtp.client-ip=220.197.31.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="MFt0lCTA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:From:MIME-Version:To:Subject:
	Content-Type; bh=KZqOAnjakKb0uH6SE+q7WBJPo2oa712Z32Se4gsnY3Y=;
	b=MFt0lCTA4AP1BUe8Q9i6OhnDk2PvURWXHzqAWK47HrPqGJWJuVlNRowZ0DLzeu
	mrB3m7BNmjXhRO3iebsoGXErTQErVVkfNlnwXBRhm5IpyKw8w7HyraTdNwY3ePjY
	cnponlew8o0hAVFQENIrVw1TFly27+BkkMF2QZpJCjUJQ=
Received: from localhost.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCkvCgDn77PijlVqyXmCCA--.45890S2;
	Tue, 14 Jul 2026 09:20:35 +0800 (CST)
Message-ID: <6A558ED2.2020902@126.com>
Date: Tue, 14 Jul 2026 09:20:18 +0800
From: Hongling Zeng <zhongling0719@126.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: dsterba@suse.cz, Hongling Zeng <zenghongling@kylinos.cn>
CC: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Add missing sctx check in cleanup path
References: <20260707091604.207222-1-zenghongling@kylinos.cn> <20260713183508.GA8426@twin.jikos.cz>
In-Reply-To: <20260713183508.GA8426@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCkvCgDn77PijlVqyXmCCA--.45890S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF1xCr4rJrWrZFWkKr4xCrg_yoW8JFWrpa
	1rA3W5Ga1vq3s3Ja4xXa1rur1Fqrs8K3y3CrZ2yr43Arn3JF18tFWqywsYgF17Ar92yw4S
	vryjqwn8C3WDZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jI0PfUUUUU=
X-CM-SenderInfo: x2kr0wpolqwiqxrzqiyswou0bp/xtbBoAPLnGpVjuNT9gAA3D


在 2026年07月14日 02:35, David Sterba 写道:
> On Tue, Jul 07, 2026 at 05:16:04PM +0800, Hongling Zeng wrote:
>> Add sctx NULL check in the sort_clone_roots cleanup path for
>> consistency with other cleanup paths in the function.
>>
>> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
>> ---
>>   fs/btrfs/send.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
>> index 3ae480c7474b..2d81fac03a3d 100644
>> --- a/fs/btrfs/send.c
>> +++ b/fs/btrfs/send.c
>> @@ -8250,7 +8250,7 @@ long btrfs_ioctl_send(struct btrfs_root *send_root, const struct btrfs_ioctl_sen
>>   		free_orphan_dir_info(sctx, odi);
>>   	}
>>   
>> -	if (sort_clone_roots) {
>> +	if (sctx && sort_clone_roots) {
> The check for sctx is indeed missing but in the else branch the
> condition is inside the for loop:
>
>    for (i = 0; sctx && i < clone_sources_to_rollback; i++) {
>
> It would be better to place it there for consistency.
>
> Overall in the function many of the sctx checks can be removed if the
> allocation is moved to the beginning.
  Thanks for the review.

   You're right, putting the sctx check inside the for loop condition 
would be more
   consistent with the else branch pattern. I'll send a v2 patch with 
this change.

   Best regards,
   Hongling Zeng

