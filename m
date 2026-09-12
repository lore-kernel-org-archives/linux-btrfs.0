Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDD637FF60
	for <linux-btrfs@vger.kernel.org>; Sat, 12 Sep 2026 10:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208366; cv=none; b=KsBtYUeo3oSyV2eKUS3JkJOt4DaplYpQP6ZQFHfn4iqcgLgTf/U0TMKNoYjZ6zd3k27MdAUC9alNDFiWiEbiXvQ0qj9vMQQ/v8fLQNE11GWLlvOIarLat+wZakd6V/xKURS++7TSwAgqxqG79hb1Sb5/yADCn7pvwyWngmjc9+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208366; c=relaxed/simple;
	bh=ka8exv4g1uAhKDa4XTBmhjkJ5no7QXlpoIC3Jfx4/Hc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DQSc700qRU3PR9RB2coLb5wIHBq7gThyWgbcnx46tmNlkKV7kzvCsMiDLO01QhNK18k3x2JrVBLJ/1fgx/KbQEpep3TX06T8zVatMUJdrZQJvkGdn7cbIiHKdZLLRwMKNjLz8u+5Mzxf6ytpdQNzoFRd+cu/111ixLxgiKf9zm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZJ4Wg7BX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZJ4Wg7BX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D4B1F00893;
	Sat, 12 Sep 2026 10:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789208364;
	bh=MBOThWsOg/geEgQ1/pWFEGYZV6CAwRKDz1CdWrbnFMM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZJ4Wg7BXZ2B+46pKnipw8cEQdj29BkbizWFHwPFKA4BjXSSN82bImUCn+GjWfccG6
	 uM7npYpu/JmaeL859lF/abIw3eCXjf1LlKtXzlnDsCpVdSCoIqdvyHApw+KV3Q0dSd
	 Lj9toEV07VLQLCX/uWaxNuEPnkU3HkjhxWUlCtJN7z72FDZ2ohkDUJOuldQFqysgap
	 tvwyJdRMSnz2BegTjIj17d9Hw0YP6JVRtD1Exp9xpg87A7dCri2OevbrF1oXwY3+Wk
	 QbdLefRXJbiteGy/LOMDZZUe9jIa2LR+N7AKI/jfvrpnrbqo2uSrLdNKuk9gBaY6EP
	 7QUoA8GhQY44Q==
Message-ID: <d0bd13fa-9126-4efd-9166-ed6c1c08c24d@kernel.org>
Date: Sat, 12 Sep 2026 18:19:21 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] btrfs: derive f_fsid from on-disk fsuuid and dev_t
To: dsterba@suse.cz, Anand Suveer Jain <asj@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, sashal@kernel.org,
 linux-btrfs@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
 David Sterba <dsterba@suse.com>, "Macieira, Thiago"
 <thiago.macieira@intel.com>
References: <cover.1772095546.git.asj@kernel.org>
 <fdea3f42827f512fcaa82f4dabe475e191d7ff2f.1772095546.git.asj@kernel.org>
 <be0c08f5-2f31-40f5-8a3b-f2f58b3e00ff@intel.com>
 <dc5401d6-19ec-4588-bc9c-a7a0084b299a@kernel.org>
 <20260911172313.GA54722@twin.jikos.cz>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <20260911172313.GA54722@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/9/26 01:23, David Sterba wrote:
> On Fri, Sep 11, 2026 at 10:51:16PM +0800, Anand Suveer Jain wrote:
>> On 11/9/26 20:32, Dave Hansen wrote:
>>> On 2/26/26 06:27, Anand Jain wrote:
>>>> Currently, f_fsid depends on fs_devices->fsid. For cloned devices, this
>>>> value is dynamic and fluctuates across mount cycles. This inconsistency
>>>> breaks persistence for subsystems like IMA.
>>>>
>>>> Switch to a stable derivation using the persistent on-disk fsuuid +
>>>> root id + devt of the block device for the single device filesystem.
>>>> This is consistent as long as the device remains unchanged/replace
>>>> (excludes btrfs device replace secnario for now).
>>>
>>> This commit evidently hit 7.2 and is causing end users some real pain.
>>> Real software uses the FSID to encrypt/decrypt their VPN key files:
>>>
>>>    https://github.com/NetworkManager/NetworkManager-openconnect/
>>>
>>> When this gets applied, those users suddenly can't connect to their VPN
>>> any more. Having a stable derivation does seem like a good idea, of
>>> course. Is there any way to make this transition without breaking
>>> existing userspace and existing users?
>>>
>>> It looks like this is also getting -stable backports.
>>
>> I wish I had more clarity on how OpenConnect uses the FSID before I
>> comment. Do you know? Can you shed some light on this?
>>
>>
>> Also, a couple of quick checks:
>>
>>  Is the underlying device MAJ:MIN changing before and after the upgrade?
>>
>>  Are the original and cloned Btrfs filesystems mounted simultaneously?
>>
>> Patch v3 (1/2) keeps the FSID persistent from the on-disk superblock and
>> stops exposing the internal random FSID. However, if OpenConnect relies
>> on statfs.f_fsid, patch v3 (2/2) now derives f_fsid from the underlying
>> MAJ:MIN.
> 
> You've sent the fsid patches [1] to fix some IMA and fanotify problems,
> so I guess there's a use case. This report shows a clear breakage in a
> different use case, I'm thinking about a quick revert as it seems to
> have worse consequences. A fix to make both work would be good but I
> can't estimate when it'll be ready so for now I'd go for a revert and
> then forward it to 7.2 stable tree.
> 
> [1] https://lore.kernel.org/linux-btrfs/cover.1772095546.git.asj@kernel.org/

Dave,

I'm currently testing the changes below, which limit the new fsid
behavior (deriving it from dev_t) strictly to cloned Btrfs.

If all goes well, I'll post the patch or will update how it goes
by EOD . Thanks!


------------
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 464129b1b0d4..ddb620ac241b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1836,8 +1836,12 @@ static int btrfs_statfs(struct dentry *dentry,
struct kstatfs *buf)
        f_fsid.val[0] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root)
>> 32;
        f_fsid.val[1] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root);

-       /* Hash dev_t to avoid f_fsid collision with cloned filesystems. */
-       if (fs_info->fs_devices->total_devices == 1) {
+       /*
+        * Hash dev_t to avoid f_fsid collisions with cloned filesystems.
+        * Only do this when a clone is present so the original filesystem
+        * (mounted first) maintains backward-compatible f_fsid behavior.
+        */
+       if (fs_info->fs_devices->temp_fsid) {
                __kernel_fsid_t dev_fsid =

u64_to_fsid(huge_encode_dev(fs_info->fs_devices->latest_dev->bdev->bd_dev));



