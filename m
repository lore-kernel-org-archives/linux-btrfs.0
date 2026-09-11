Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1045B387341
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 14:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138281; cv=none; b=XDCtmv/u7xLafKvA5iNFVEBr27AGZvsDu7G3YRf3AHCdX64kmgoJ3I77ZaL3JuA2F7icGPhnsTVdi+9Z/xf9ZTH9G7PXnuTmhxW73Uq/QozsCQaEcPrEY/4Af7UhIpQovIsko/SmKsp/lOUZGFuNRLTFyXmGCmMgulQNLTdvhoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138281; c=relaxed/simple;
	bh=gLC/AqB/EKAkLfSOfvzmCFo4LS7Q7xj+NU1YOjdsuR0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=XNq79Tm605m1CQ3dPiYGDPP9D1VV5JyaBhzPIa4kcUyv3MgwdANCIbFpFvfUS4n+eYXI5W6Rm3jTEvjnFgEzi0Gsf9ij9JWzVtyn9T0EKjd/2BAocrLzySF2ZiUGjisU1OQXMNONSi0Q/QTd6uE351jLHFIQFqr7qxql9zWDJFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OZV+t9Sa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OZV+t9Sa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD7B1F000FF;
	Fri, 11 Sep 2026 14:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789138279;
	bh=7+ScKLQ/WdL2S9MFVqlgNfMIMEsmsijc4mcz/mfN2iQ=;
	h=Date:Subject:To:References:Cc:From:In-Reply-To;
	b=OZV+t9Sa+rk1N10EAFjrJDIQ28TU6HCj0HwRdRbVoOi1FMZ1OdmsHIXukFD7QP+tw
	 y4YR0GSHjvDco4f2GnOZLo/WHZb3iQRNh09xGYCeM1W6bNGXRMRcQS8XbuVgTS3l+x
	 JpzS5+JzbhQT5/gZ2k9fFLMkJZXAkxtNIVd/XeWjaT/9BNCSw+1rbcGxzhiosWOGG5
	 fXpt7/ci3pQce+dz0Wpy65VnxmEiNnRWOR2z9/0OSwXz0fGDA801IynUo2fTLfJ7fY
	 1vFeJlP3k7/RAqfySi6PCoAiGXSDp3U/ZEE7rYORF2QNrN7cfH57gpnSQpqqHRKV6H
	 yW8IMM4H8nxBQ==
Message-ID: <dc5401d6-19ec-4588-bc9c-a7a0084b299a@kernel.org>
Date: Fri, 11 Sep 2026 22:51:16 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] btrfs: derive f_fsid from on-disk fsuuid and dev_t
To: Dave Hansen <dave.hansen@intel.com>
References: <cover.1772095546.git.asj@kernel.org>
 <fdea3f42827f512fcaa82f4dabe475e191d7ff2f.1772095546.git.asj@kernel.org>
 <be0c08f5-2f31-40f5-8a3b-f2f58b3e00ff@intel.com>
Content-Language: en-US
Cc: sashal@kernel.org, linux-btrfs@vger.kernel.org,
 David Woodhouse <dwmw2@infradead.org>, David Sterba <dsterba@suse.com>,
 "Macieira, Thiago" <thiago.macieira@intel.com>
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <be0c08f5-2f31-40f5-8a3b-f2f58b3e00ff@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/9/26 20:32, Dave Hansen wrote:
> On 2/26/26 06:27, Anand Jain wrote:
>> Currently, f_fsid depends on fs_devices->fsid. For cloned devices, this
>> value is dynamic and fluctuates across mount cycles. This inconsistency
>> breaks persistence for subsystems like IMA.
>>
>> Switch to a stable derivation using the persistent on-disk fsuuid +
>> root id + devt of the block device for the single device filesystem.
>> This is consistent as long as the device remains unchanged/replace
>> (excludes btrfs device replace secnario for now).
> 
> This commit evidently hit 7.2 and is causing end users some real pain.
> Real software uses the FSID to encrypt/decrypt their VPN key files:
> 
>    https://github.com/NetworkManager/NetworkManager-openconnect/
> 
> When this gets applied, those users suddenly can't connect to their VPN
> any more. Having a stable derivation does seem like a good idea, of
> course. Is there any way to make this transition without breaking
> existing userspace and existing users?
> 
> It looks like this is also getting -stable backports.
> 
> 

Dave,

Thanks for the report.

I wish I had more clarity on how OpenConnect uses the FSID before I
comment. Do you know? Can you shed some light on this?


Also, a couple of quick checks:

 Is the underlying device MAJ:MIN changing before and after the upgrade?

 Are the original and cloned Btrfs filesystems mounted simultaneously?

Patch v3 (1/2) keeps the FSID persistent from the on-disk superblock and
stops exposing the internal random FSID. However, if OpenConnect relies
on statfs.f_fsid, patch v3 (2/2) now derives f_fsid from the underlying
MAJ:MIN.



