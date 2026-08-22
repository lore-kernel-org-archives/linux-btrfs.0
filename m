Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10AB2F616B
	for <linux-btrfs@vger.kernel.org>; Sat, 22 Aug 2026 04:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787374643; cv=none; b=fqORuZ+wKgPHvjpQyYL/ExJ7npr3f9dJ0l3KOehdzN1UCOfQHCuHooZzx8eHiZiZpfceXE4ewDVhcyl5005A019k1Z0P5BPk/yL+n7lqJhEUKbkbxlWLH99GjKZFzdKA3KIuetbiKsgGxIlj2UNslwEdt9kK1DBmGKR1W9Y5SjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787374643; c=relaxed/simple;
	bh=VanUjKeNAZEPgQBnEjkQ37NMwGMaBcsxCWOhYmHg7ho=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rEBNwqeyY2AUHomrnBmmMDVji3tyD8VcUbMEp8hSiKdUFea82xjXKkwTPPO6vkKV9BtyJJ3Q3msEogktZDGq1+UAr/tQdbUY8nptSA14Dom2EK1C62+HGfagIKjI25Z7DykpyJNpFwaP52OI6fWX5qINHUAh5LR1+aksv+kq0uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QcFWkKtS; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QcFWkKtS"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-495437bb891so10058005e9.1
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 21:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787374640; x=1787979440; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v4PibLJPwswVRuRK8+G860V3WJH/gWrO0hZuqSUKKPk=;
        b=QcFWkKtSLQ3OA+BV7lSfz45r6OrcUV9TCiPEaj4yLTVMQzRNY3DTRMTdsxvzBV2ikh
         jks6C0HRTSdeFe0a9/8IuSI6phFXPofB4uzB+NjyShluhY7f/0dxW7cg47ow4KoCJy8c
         QVnyHZxHuVaNdSnRemlBXczGLTpdnt2/FDrb5bRDr7Xqq2nDmdWg7Uw378CbcDpDfAP+
         JHueUPaMsZkKt7rNbFex50UqaUt0a4XCKQkzuNprlQqXFsHKWbMf3coPvxfFHe3Hbt6D
         0DfWP9gX7PvXPWqU/zilx68rX0wMhvN6qxgaYQpXsyx4iCqeH+7V70BgYS2aDfS8VJJH
         L4fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787374640; x=1787979440;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v4PibLJPwswVRuRK8+G860V3WJH/gWrO0hZuqSUKKPk=;
        b=n93Vem7a1X9xmGZkscQnniU9QqYc0h8WIqF3UjK/8S8A7XDZUb6HYd8KmpP4DwwTdS
         ie+2jx2rfFroJgkJ2VFMIb+diPLm0vAk+Yk563PpNISP+qIQpD2fRPT+/xyBUYJlbzHJ
         Svjs6v+5AfB/5uaIY2PjIMrqm4F3pL1G/Fz2xexnJQhES9Ea7jPgpCQeyRCY1LRL7bke
         032on2Mccfj+bti90/af3tu5eCABHUpBAYO8sOXaC3sk1AjpCObKe9/ZulW0tFlnxrK3
         r00NespsiFOtDiic9yFgGrSHVdINI1ozffnVBHJKpP9EJ6qhmjf9J+ywcibDKCd5kL1+
         kYqA==
X-Gm-Message-State: AFuF++kWIeAY1BCJ3WzR36Ob+YmBd43JHCedoCRdzsdvhLcdG0Ufd5da
	xJfhwtjJZ2OvE8gLtguFu07iNuCpxEtjZwK9Y/MDg8Bf7mSyceUUebZWIZxZ6J02PV8CcPAC9XU
	XNVik2Tc=
X-Gm-Gg: AR+sD11/3tJsKxWY7NYSCNVBeWZ/PcNjQymd0MgSRdX65lmU0LFh1eATjjcqJQQV8uk
	7K8Bxd3gOo26VHkJcpuUivSrD83vov5JExj8839TbDeDrqf5YqA+Bw8rl57aWMCibiMxDg7fuD8
	TFzldCZuyVzNhFXk66bM3xLpIJNzNRYyCeCJMMSDlPMQOuqlxLTOrnPKN9JcD2ROfMlGvISAfj4
	PxhPhQs5ls3Bx7L7DI/0+fGUjcOtAEYkzmXq1aLvsYv34ZCxI6iuuUtmBPzMs5F9f4izoCHX5fu
	XxmOsPH4gb82xC4r4lFgIZnpxgXOcH5rPpUJKwJxbwfzGK/2PSzKuGNbpIibxhBQvy6HSJaDFq2
	cNC4FRd9pPvK32R2AXBb5v3s6APfKtOA/1+Slw1EuIKDoyVFYdhUWts3EiIcmOsGPTLD8wBnQRd
	Dwrv4S7MaluauIl2voUbOKicXm6gFLeS9lqCGGDceQ/UE1Uy/ZdRvdTA==
X-Received: by 2002:a05:600c:c114:b0:499:71d6:359a with SMTP id 5b1f17b1804b1-499b070c272mr237863515e9.8.1787374640107;
        Fri, 21 Aug 2026 21:57:20 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14186173199sm3454006c88.9.2026.08.21.21.57.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 21:57:19 -0700 (PDT)
Message-ID: <ffae86d9-e2b3-4cf0-9f4f-3fcd412ed7e6@suse.com>
Date: Sat, 22 Aug 2026 14:27:14 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] btrfs: delay mounted sysfs attributes until mount
 is ready
To: Jiacheng Xu <stitch@zju.edu.cn>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20b09e24.16b27.1a01f23ee08.Coremail.stitch@zju.edu.cn>
 <698e5039.16b92.1a0278ef67b.Coremail.stitch@zju.edu.cn>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <698e5039.16b92.1a0278ef67b.Coremail.stitch@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/22 13:11, Jiacheng Xu 写道:
> Here is a potential fix following Wenruo's idea.
> 
> btrfs_sysfs_add_mounted() currently publishes the writable label and
> feature attributes before the transaction kthread is created. A concurrent
> sysfs write can therefore dereference a NULL transaction_kthread in
> wake_up_process().
> 
> This series follows the suggested lifecycle: create only the required
> subdirectories during early mount, publish the fsid attributes after mount
> initialization, and remove them before the kthreads are stopped. The
> feature attributes are included because their store callback has the same
> transaction_kthread dependency as the label callback.
> 
> Patch 1 factors the fsid attribute handling into dedicated helpers. Patch 2
> moves their publication and removal to the safe mount and unmount stages.
> On unmount the cleaner is parked before attribute removal so it cannot
> recreate the feature group through sysfs_update_group(). Both patches are
> required for stable backports.
> 
> The resulting fs/btrfs/sysfs.o and fs/btrfs/disk-io.o were build-tested.
> 
> Changes in v2:
> - Delay creation of both the root and feature attributes until mount setup
>    is complete.

You don't need to bother feature attributes for now, there is already a 
patch addressing it by completely removing the write support for feature 
attributes:

https://lore.kernel.org/linux-btrfs/8a598d76555b5944d34bb08fa8dbeea28fc05db9.1787307129.git.wqu@suse.com/

Considering it's only extended_iref, removing it should be much simpler.
Until that is determined, you only need to bother the label one.


Furthermore, among all the attr files in the fsid directory, there is 
only label that is writable, it would make more sense to split 
btrfs_attrs into two parts, one for those read-only members, and one for 
the only writebale label one.

Otherwise the series looks much better.


> - Remove those attributes while their kthread dependencies are still
>    valid.
> - Split helper extraction from the lifecycle fix for stable backports.
> 
> Jiacheng Xu (2):
>    btrfs: sysfs: factor out mounted fsid attribute helpers
>    btrfs: delay mounted fsid attributes until the fs is ready
> 
>   fs/btrfs/disk-io.c | 18 ++++++++++++++++-
>   fs/btrfs/sysfs.c   | 50 ++++++++++++++++++++++++++++++----------------
>   fs/btrfs/sysfs.h   |  2 ++
>   3 files changed, 52 insertions(+), 18 deletions(-)
> 
> base-commit: 0f23d56f17fdfc7db69d51f64c8b91bbab947aa9

