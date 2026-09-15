Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953763DEAC4
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 16:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789488667; cv=none; b=mA8WrcgZXcaiCgQjiLUWbfzuzQeJtRbRfjEd0AOm5KwnSI1dVw5gPnAmjZ9zayH48/2Rn5n7FErRBJqgIccBgSKZmGstYKEgoJ15taiT93S2XunpXgGIS1iHp1Hliz5vWPClzMJO3sfduXvSdVUSweKTmf1iOiUkQj0hQIY8zes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789488667; c=relaxed/simple;
	bh=YlBweoYK2h5/MTTWteAZqyBFoK8k5uWdyo0IGT0mBio=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IufC1lhHAs/JjIPkDISg2267HUnxYD3TerxapTYMvuuVgPkJrMNR/8hyRdyb5xn49mqEScG2n+Np+TXa30AIjoGmgNRU8npa61Hw/lCwtG1/o6jbtUyOXrCATFo6T44IfyC1DTE0KXamrI5SB0U6lMlpEowWIExl1QUconGzPeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fWRuZ+Fm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fWRuZ+Fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA8C1F000FF;
	Tue, 15 Sep 2026 16:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789488665;
	bh=O9SnQtUK7fglr7K9XBSKdpmiCKAm8Zkf3UeRbS5n2A4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fWRuZ+FmaZaJZWIIpzaSlgc7enb53Hlqxv01+ZIcZc6yWMJIBPtWGcjZvnnQUbuRY
	 GZlhUfbyuK2vyVE6X/ojkperg9M5e8b/OZstXenAegUlqvtErolqqjPhZxLlCAczfo
	 Uz645pYQq84eSEH4m5gSPNbfM8ajDaGmLl4iyWx6MCXB+rvjPwveZT28/jvrd6/DBr
	 MYx2C6GSKWypr0Uh2yZocTLyfvAANcybnrzzzaOYx4Sbh8qklV/uYyK2UZSiJOEoyK
	 86kzHBZhro4ZdDjdOaP+VRhD3lqSPhsPLZs+pJY4RsSXRcLabqn08Vm3a8Lg4qWpVI
	 8Hr1MnfnwpRiw==
Message-ID: <847b96c6-9e39-4eef-889c-3985f7eb4e3a@kernel.org>
Date: Wed, 16 Sep 2026 00:11:01 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] btrfs: derive f_fsid from on-disk fsuuid and dev_t
To: dsterba@suse.cz
Cc: Dave Hansen <dave.hansen@intel.com>, sashal@kernel.org,
 linux-btrfs@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
 David Sterba <dsterba@suse.com>, "Macieira, Thiago"
 <thiago.macieira@intel.com>
References: <cover.1772095546.git.asj@kernel.org>
 <fdea3f42827f512fcaa82f4dabe475e191d7ff2f.1772095546.git.asj@kernel.org>
 <be0c08f5-2f31-40f5-8a3b-f2f58b3e00ff@intel.com>
 <dc5401d6-19ec-4588-bc9c-a7a0084b299a@kernel.org>
 <20260911172313.GA54722@twin.jikos.cz>
 <d0bd13fa-9126-4efd-9166-ed6c1c08c24d@kernel.org>
 <20260914131455.GH54722@suse.cz>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <20260914131455.GH54722@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14/9/26 21:14, David Sterba wrote:
> On Sat, Sep 12, 2026 at 06:19:21PM +0800, Anand Suveer Jain wrote:
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -1836,8 +1836,12 @@ static int btrfs_statfs(struct dentry *dentry,
>> struct kstatfs *buf)
>>         f_fsid.val[0] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root)
>>>> 32;
>>         f_fsid.val[1] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root);
>>
>> -       /* Hash dev_t to avoid f_fsid collision with cloned filesystems. */
>> -       if (fs_info->fs_devices->total_devices == 1) {
>> +       /*
>> +        * Hash dev_t to avoid f_fsid collisions with cloned filesystems.
>> +        * Only do this when a clone is present so the original filesystem
>> +        * (mounted first) maintains backward-compatible f_fsid behavior.
>> +        */
>> +       if (fs_info->fs_devices->temp_fsid) {
>>                 __kernel_fsid_t dev_fsid =
> 


> This should fix the most common case where people don't have any cloned
> filesystems at all, so I guess this is good as a fix. Please send it so
> I can add it to this -rc pull request. We can try to catch next week's
> release of stable trees.


The fix is already on the ML.

https://lore.kernel.org/linux-btrfs/16069a6fc651168bfcd2394d6e57ce63a50231ed.1789235482.git.asj@kernel.org/

> Related to the cloned filesystems, it can get complicated if the
> original filesystem gets unmounted and mounted again, now it would have
> the temp_fsid set, right?

No, it won't. Once unmounted, there is no longer an active fs_devices
using that original UUID in the system, so the next mount will claim the
original UUID without needing temp_fsid.

> I don't see the temp_fsid documented (btrfs-progs) other than in the
> changelogs and briefly in the sysfs file. This should be more visible as
> a separate feature and with the known use cases.

Agreed. Do you think btrfs(5) is a good place to document temp_fsid?




