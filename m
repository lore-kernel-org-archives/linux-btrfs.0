Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770932C0285
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2026 13:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775654528; cv=none; b=f0ElB3N8JcmO2pItLwpupbrSj7lVxBWRVzODYZKidYxUXfhm1DBqJNgKFpJwKOD0X8uU0GWFwqNe6FwpyZBMXUU8+EDzJ+VuHxBdIcy/ITXjj45K7oPDrUrEnEKw5HknPVE+ely4gBXEmtYuVLnO1BEblmwZ+VwmfWNEV3TFXrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775654528; c=relaxed/simple;
	bh=J1IPLRxIF/tUODVDNXIvW/cJ95J54X3KCOb/LvdZh44=;
	h=Message-ID:Date:Mime-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uj4rfzhMOLD/UnMBN/ZSe0L7GxFJbDSZBCLrcdXHTDoTO47LJ6ZepbKnfydldFadzlnTxj6/ePlSR+bN89r5/OKMOzJVMjdyQTiUXoJC9u1cVUkhy3GsmM5rclTdK6jKOJfcTUceGR27Jd+2tmgwSmF3/UrPiT27LX7n8Irr9Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=PQJcxJp6; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="PQJcxJp6"
Received: from [IPV6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2] (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature RSA-PSS (2048 bits) client-digest SHA256)
	(Client CN "hellas", Issuer "burntcomma.com" (verified OK))
	by mail.burntcomma.com (Postfix) with ESMTPS id 6A0F231AB25;
	Wed,  8 Apr 2026 14:22:05 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1775654525;
	bh=Gt90nx8FXGk1GnKPncbxZfdwVJhDF5vb2z2eZUX6URc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PQJcxJp69eraSWyBk7nxhMCUdEB1yHsgRtnozeuHaD6HVBikWJa+1WSGi81/teiCn
	 /VzA6WnZHQVoYBQhWDDmfFdZ/V06lYc3a36p3lYlXWRoRBfSJ5PhTl4HL9/W/vD6zA
	 Fw2a0IT3G54F2PsM6Ar+DB/374GXbPG1TbNRyWkg=
Message-ID: <4050e342-88fb-4b0f-b00c-0dcf154c2ad8@harmstone.com>
Date: Wed, 8 Apr 2026 14:22:05 +0100
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org
References: <07cf5ebc-ac52-4fd9-82c5-404c0f4d6056@gmx.com>
 <3ad267b6-cc59-495f-b385-9b4b4686a473@gmx.com>
 <39496ce5-74c2-4300-ba39-032edace4cfe@harmstone.com>
 <a1675480-628b-46ba-95c7-f5ee29d6bf14@gmx.com>
 <97ff76b9-5c07-4083-a020-3499ff595460@harmstone.com>
 <e6b4ae42-8b83-487c-92b7-6f91c70e1b6f@gmx.com>
 <20260403224449.GA1806609@zen.localdomain>
 <2bb3df33-a9e0-48fc-bff4-957c7d7cb8eb@gmx.com>
 <a40afd17-bfb6-486d-8632-9663d6cf7ce3@harmstone.com>
 <7c2377be-ceca-44ce-8bcb-e201d142b4f8@gmx.com>
 <20260407221322.GA1579772@zen.localdomain>
 <2a47c0b6-4a40-4b19-9832-5ab6fcba0f9b@gmx.com>
Content-Language: en-US
From: Mark Harmstone <mark@harmstone.com>
Autocrypt: addr=mark@harmstone.com; keydata=
 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
In-Reply-To: <2a47c0b6-4a40-4b19-9832-5ab6fcba0f9b@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 07/04/2026 11.39 pm, Qu Wenruo wrote:
> 
> 
> 在 2026/4/8 07:43, Boris Burkov 写道:
> [...]
>>>> We absolutely can't give non-root users csums to arbitrary data, that's
>>>> definitely a security breach.
>>>
>>> If getting csums for random logical is a security breach, I do not 
>>> think the
>>> new GET_CSUM ioctl is any better.
>>>
>>
>> Isn't it better because you have to use a file we do permissions 
>> checks on?
>>
>> So it's not an arbitrary logical, it's a logical used by a file you have
>> access to? That might still be insecure against some attack, though, what
>> do I know.
> 
> OK, that makes sense now. Although I'm still not a huge fan just to 
> combine two different tree search operations into one, just to fulfill 
> the privilege check requirement.

The privilege check is important, we are running non-root mkfs to create 
(I think) VM images. And doing two tree searches is still massively 
quicker than userspace reading the data from disk and calculating the 
csums manually.

Plus there's other potential uses for this ioctl in the future: 
something rsync-like, for instance, or for deduplication.
