Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794586614;
	b=fNb3ba9t51vehR6gv9ltDxYAPRhrPk9HJm8dKM1mSkLg0xesZck5jAcmX0jW6Xaqa1rq
	 RM2N823n9nKGt3cZCBPdEKeVHipA9OBTFg36XhqcgaB2Iwo50J/ykfKAYLUXfkLNYmVnY
	 QLm2V6Qsm3HPRR7MdOSofp4XlNVO3E6aFKiy/ErWJf9M6DsoNJWXcbNrEMbhxnUUuReOQ
	 EG/CdI1yxxYByXWR78XNmIHRZBQ8N/mBHxKrqMsPvvkfIalKUJc14NVcbyacDZWPJ6q/y
	 huc6nKj3hJCCU/kazj02xTu1C5su5v6c9//WGDhPKMVANjs8joVurWRbyXhyQZRhEDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586614;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:To:Cc:References:Subject:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=J3YzG3qSt0iZUvZWzetuxG/H48C/C78BMhIQaxi9YOQ=;
	b=C4Q9CPCLdqbTZqqe5AT5j5wha9p6kKSx5wt18ZS55zsdIc/U/cRahtz2JZlZGWQupZm1
	 iQCxAIuvxldKgovygNJYDTA8LWWH9Y9+iVIZXpVC3FPrLkDiTtLAsiYKZO/nzVpg9D8lp
	 5upVIiBflmwLEL7X1mPUFP6J1p9pz4XFJFLfPZVmcg6Xys0nLG/h7jPA/SE3COTcDJStz
	 NhTtphK6WkGwK0Le8NbrJQLHDdr9dALIBzajTPSBbvUE/7FX2GeMpOjuIwCBEDw5pQVtD
	 fOxtyMB1P9diu/EqEqPcbz6BlH8+v3+mqtAYuqdhEDKdKWXLOr+rqgqBM2Dz6dYi66A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=p1CQLyDv;
	arc=none smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90066606AE15
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 16:16:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90066606AE15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=p1CQLyDv
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b596afb4c5so1695090a12.1
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 08:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794586612; x=1795191412; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:subject:references:cc:to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J3YzG3qSt0iZUvZWzetuxG/H48C/C78BMhIQaxi9YOQ=;
        b=p1CQLyDvuxWG6/oTVEyOOX31whLJjVxLSHdZt+w0EBh/F+wgf9TofYtsiBEM1z7XsW
         uKyYiu+cWAS5sx0+yPgE9fitSDB3BoEZBl9fO+Wx3Ialq37WmM2aHS9X9jRxyzHsCr0L
         vaxAs+n2AVury59KKjXuCiHIo+T+wy/MSHadeQT9IR0q3biDhF+HSRMO2umSASBHFl3D
         0C/s2ppfp5u6WcYIiQGpi+L/blnumqGJtD7aTjZSZVlJQwDNRJuSg3s+73op2lPEHQps
         LkprrHQnNKXiyPnQX6uj4YzQUkLU2o8OIMovvVQesLzfmvcV4zWe8Z40DCaGKQHTts7Y
         riuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794586612; x=1795191412;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:subject:references:cc:to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J3YzG3qSt0iZUvZWzetuxG/H48C/C78BMhIQaxi9YOQ=;
        b=rNSfB7tx1OomDUkJn/akT03UwVFofYtBda7xmOrjZX4ZdzfwhK8NUrtjLr+snQcQw9
         oO9VTfaT9EH6OqiQs7d2ruj0kQKeHYW6L/z2XeOURaTbfT1tqvIaJSjMAXD+iLaKlgSb
         FLbmN51o4d1UMWRXk4LdQaWJcID4p6Y3tXssSgPfjBcN9WQVkLguIkZ2WsVGZDMSpVdf
         3nzUPgYnNRwz3UGTcVrn00qK7bHivVo0UUtY2PYo+piy5KE+OYONcjy6Iwl19C2zsKX8
         VkEEHwWvoy47jFAmpv3go2aJeejamZh6+05dyUYGKWndrhneV0NmgXMthbTPHewWXIID
         co8g==
X-Forwarded-Encrypted: i=1; AL+hErF7Ea96QBjW8Xbei3EdMkzWrGJKFoRnvPl66OrgfjLtp3t+wZopU4dgIIuF532DdTlP1od7qlswqUpHPA==@vger.kernel.org
X-Gm-Message-State: APuU4Z+lF+OUZQ/TN7nmdqt2Y88CIHJlVLi7DcLP2zGfCEG+4hXfS1Q2
	DfoKUj4ihYJPN5Ifxj3FOvJNA790E8OEa6oTUYG5dmi6j3rAhejD5DcF
X-Gm-Gg: AYBFou38mW3lh7OeZviRFEliwSuf+M0E5vvzwvV5qcV2dLYuyVN8HOuhP6DDJSsWfC8
	xJrp1O63TVjJVD53YfffjI+RuyBh13Z5uBl+h9xKpLry1IvvOrsSAXlBIkbwla4xqm0uz8wT7Mf
	RiwLXADoUqFfWljxQU77lB+nXjGhnql/LDs/aF8sKj/1VlLoAnjYpxlJClBZFFxn7VApmFKuE65
	q6VqyjgcmZ7NnB7WSW0qIO9ymKd1hF0BXlTrA+cEKXw6DW2XOdhIBZZuhkYSh2oDTQaYBBEXn6E
	dxeWF9DGeBBEVuin2T4k6o0eKG8MHfeecVs7fYQCforcWJgYlFH2hRR83ioAZN0vty1JqUNp/oh
	SNO4prLaWZyyHJHqL2H074WhYf3GKhU45hQbniwn0qP3gscUKgSWH0aGikyN47gmaE8H805ZQ+q
	zoetCt7JYeM4v6HwHngfKM0Ijwub9BR2xgrq4C1mnqbSck8QJQUJ/aW+abP3e97TRMpMZ5JGu6/
	yCNTyakRQfBQBuIwiQK6hsV2OwEpAsk7R5lSEzr+/azhrHHD1RX+yHOps3d6sb1+ZxeVqd1M7WT
	2yFb1kNxIYKINVpEadXg2Q/08tCxZxieh93RcIKnhw==
X-Received: by 2002:a05:6402:a513:10b0:6b5:6ba3:5860 with SMTP id 4fb4d7f45d1cf-6b7c0c12b08mr1873816a12.17.1794586611681;
        Fri, 13 Nov 2026 08:16:51 -0800 (PST)
Received: from [192.168.7.65] ([94.142.237.221])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c23dde49sm1216604a12.23.2026.11.13.08.16.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 08:16:51 -0800 (PST)
Message-ID: <e3261fe5-4b98-47e6-ae66-d4af05caa621@gmail.com>
Date: Fri, 13 Nov 2026 17:16:50 +0100
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: johannes.thumshirn@wdc.com
Cc: a2jphilipp@gmail.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
 naohiro.aota@wdc.com, zhudongjiang@fygo.io
References: <20261110080932.1205332-1-johannes.thumshirn@wdc.com>
Subject: Re: [PATCH v3] btrfs: zoned: don't release active zone reservations
 for conventional zones
Content-Language: cs
From: =?UTF-8?Q?Martin_=C5=A0koda?= <mar.skoda@gmail.com>
In-Reply-To: <20261110080932.1205332-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello,

I would like to report another case of Btrfs zoned filesystem failures 
on a Western Digital host-managed SMR drive. My symptoms appear very 
similar to those being discussed in this thread.

*System configuration:*

  *

    Distribution: Ubuntu Server 26.04 LTS

  *

    Affected drive: WDC WSH722870ALE604, 27 TB, host-managed SMR

  *

    Filesystem: Btrfs zoned, single-device filesystem

  *

    Zone size: 256 MiB

  *

    Kernel versions tested: Ubuntu 7.0.0-34-generic and 7.0.0-42-generic

*Observed failures:*

On kernel 7.0.0-42, writing large media files repeatedly produced:

|BTRFS error (device sdg): cow_file_range failed ...: -28 BTRFS error 
(device sdg): failed to run delalloc range ...: -28|

These errors occurred despite several TiB of free space being reported.

On kernel 7.0.0-34, I also observed a transaction abort on November 7, 2026:

|BTRFS error (device sdg): error while writing out transaction: -11 
BTRFS warning (device sdg): Skipping commit of aborted transaction. 
BTRFS: Transaction aborted (error -11) BTRFS: error (device sdg state A) 
in cleanup_transaction:2060: errno=-11 unknown BTRFS info (device sdg 
state EA): forced readonly|

At that time, Btrfs filesystem usage reported:

|Device size: 24.56 TiB Device unallocated: 10.65 TiB Device zone 
unusable: 251.31 GiB Free (estimated): 10.86 TiB|

All Btrfs device error counters were zero, including write, read, flush, 
corruption and generation errors.

Both dynamic and periodic reclaim were disabled, and the reclaim 
counters were zero.

The issue has occurred repeatedly. The filesystem becomes read-only 
after the transaction failure, and normal write operations cannot continue.

I have currently disabled writes to this drive through mergerfs to avoid 
further data loss. The filesystem contains important data without a 
complete backup, so I cannot safely test experimental kernels or perform 
destructive recovery procedures.

Could you confirm whether these symptoms match the active-zone 
reservation/accounting issue addressed by this patch series? If so, is 
there a recommended stable kernel or an Ubuntu backport that includes 
the necessary fixes?

I can provide additional kernel logs, filesystem statistics and 
read-only diagnostic information if useful. I would also be interested 
to know which fixes are planned for stable kernels and whether a 
backport to Ubuntu's 7.0 kernel series is possible.

Thank you for your work on Btrfs zoned support.

Martin Škoda

