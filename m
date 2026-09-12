Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2008353EF7
	for <linux-btrfs@vger.kernel.org>; Sat, 12 Sep 2026 10:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207845; cv=none; b=Y7kyVDLJOjSMU/SiaKuU2UhwMnYk9xE2LUiND1evxcYr/vThe+zv0j7XB6YQnraudK1QDiG4h/2Zjbrl7dvQ/rUACL4ZXMLdR1E64DLej779Z+JxuqTK96UAu3ohqDj0F+Oh9rm7iArjfH2IfdfJxL1RPboBYdFPn/4CiUoFbgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207845; c=relaxed/simple;
	bh=Ft0zE4sQMmIq1iHYGrj6OR5CdKydEK9EtUb4vUPwYgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ayYkg3ryKVA+qVOJl2Adht5ZI+EgtmUrTJjJcXcCG5/eCZqaFB78rb7KGV4bGlXtAfgAkHXfGQ4NGv1vTAAx9fYk9snsyJa7xd6+p23dPNlhEFjs04tBhrnDrxVfdxyk09N+mzRKk5oFBUBrGc6QAAXb0bQSjmHAn1Rf4CHUJco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=De+O/xYo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="De+O/xYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4266C1F000FF;
	Sat, 12 Sep 2026 10:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789207843;
	bh=HTQaa1bTN7gZqzzA7mCEFC4r1PUJPdX3CrPF5yXKNyY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=De+O/xYojRVLdBPeRI2AHx8W8bJmMcpxihkvaXbhvVGjXOv+SmRqJA/kvpO8YHqGk
	 1ZaqyqBeaaD/XhEjxaSbmEPKzvGsinFTBev+3KuISqOWICnmFJTuAz7zEvxtr9aqh9
	 OUO9rqklgwNkzfXufPn5hHynjcugK35OBfMVkoou2FOGDOZd6vlSMejP7HxATwEzUM
	 /4yP+UjepHI/S2ngRBx6I3O9h0IjFLPe1ZW00gStn33upiZWhtCYUo9qFmtOUGTTHS
	 i5c6wAUbfH5MzQmfoAK8YIr0fMSCUlOwxHKU0TSOQNjoB6829x7OlYCOpqQIGg2bEZ
	 PxTyDARPvYZLw==
Message-ID: <573e174a-0834-4d6c-8e12-2cbc15493ca1@kernel.org>
Date: Sat, 12 Sep 2026 18:10:40 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] btrfs: derive f_fsid from on-disk fsuuid and dev_t
To: David Woodhouse <dwmw2@infradead.org>,
 Thiago Macieira <thiago.macieira@intel.com>,
 Dave Hansen <dave.hansen@intel.com>
Cc: sashal@kernel.org, linux-btrfs@vger.kernel.org,
 David Sterba <dsterba@suse.com>
References: <cover.1772095546.git.asj@kernel.org>
 <be0c08f5-2f31-40f5-8a3b-f2f58b3e00ff@intel.com>
 <dc5401d6-19ec-4588-bc9c-a7a0084b299a@kernel.org>
 <qH1wH2-sQO2cdJ17lf_wvw@intel.com>
 <68DEEB96-40BA-45B1-8C9F-BD45E19F72F8@infradead.org>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <68DEEB96-40BA-45B1-8C9F-BD45E19F72F8@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/9/26 02:12, David Woodhouse wrote:
> On 11 September 2026 17:07:29 BST, Thiago Macieira <thiago.macieira@intel.com> wrote:
>> On Friday, 11 September 2026 07:51:16 Pacific Daylight Time Anand Suveer Jain 
>> wrote:
>>> I wish I had more clarity on how OpenConnect uses the FSID before I
>>> comment. Do you know? Can you shed some light on this?
>>
>> It's openconnect's option --key-password-from-fsid. It uses the FSID encoded 
>> in hex format as the key's passphrase.
>>
>> To reproduce, take any key without a password and do:
>>  openssl rsa -in unencrypted-key.pem -out encrypted-key.pem
>> And paste your FSID as the password.
>>
>> This is not real security, we all agree. David W can probably remember better 
>> why this option exists, but I would suspect it was an IT mandate that a) the 
>> key not be left unencrypted on disk and b) be specific to a given machine, 
>> avoiding reuse by being copied to another. Ideally, we'd use TPM these days, 
>> but there are still a lot of systems without it where Linux runs, and 
>> especially a lot of legacy set ups.
>>
>> But very simply, it's the fact that the FSID has been used as a stable 
>> identifier and no longer is if the device in question is not itself stable. 
> 
> Right. This was never "security" per se. 
> 
> In the early days of OpenConnect we were required by Intel IT to match the level of security of the Windows key store. Which basically meant that it would not prevent an *attacker* but would prevent a genuine user who hasn't read (or chooses not to obey) the security policy and wants to copy certificates from one machine to another... for at least five minutes (downloading Jailbreak, in the Windows case, and re-encrying the key, in the Linux case).
> 
> It's not high security but it *does* mean that a key file can't *trivially* be copied from machine to machine. Or recovered in useable form from a backup.
> 

Got it.

> Encrypting it with the FSID of the file system it's stored on did a reasonable job of what it was intended to achieve. And the FSID is supposed to be *stable* and not break on a kernel upgrade. (Isn't it part of the NHS FH too, or is that derived entirely differently?)
> 

Are you referring to NFS file handles? That already works fine
for non-cloned Btrfs. The whole point of this patch was to keep
fsid consistent across mounts for cloned filesystems too, but
it turned out to break backward compatibility for the original
filesystem.

Besides, I don't think your approach works with XFS or F2FS
either or at least it hasn't been tested with dynamic disk
discovery? Both of those derive fsid from dev_t MAJ:MIN,
which isn't guaranteed to stay stable across reboots.

> Of course, you *should* have moved on to using a TPM by now; I don't buy the excuse that it isn't available. But still, the kernel shouldn't break userspace *even* if you deserve it for still using this hack in 2026.
Fair point the patch definitely isn't ready for Stable
kernel as-is. I'll get a backport-friendly fix out asap.

Thanks
Anand
