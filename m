Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929F51C75F9
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 03:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789357378; cv=none; b=QXxq6YQjTbOxRx7CnREIIXFabfEaVPLLR/l2ibhtZtKLLREIikjsmu16KCaAOBoZ1EjDz6yvGnFlxWLFWG/z0vtbNMBHRoOcUKi3uI+goFXzj/DYBt95L+6SbiRtjzALi2jjxOLgCO6uanv1Dy6G8GcSpWfk6JqlPdr7w4QlwFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789357378; c=relaxed/simple;
	bh=WiEo/wilJeo+NX9SSpbfLpSiJwd0DCbuu0suVIA9ZUo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=BCm5uFvq4mMp5AgzzMPc+jpM72ezOskvIpLN8aC7iypJbeRgPxGMFfi0onGzvY6pbIgdBYrsG8pXYzSVXW4DVUPYdIo+QlKjK9cJky7Z7FYmmjV21XBMnF/4bE92hMb+oP6GEzbwbe42QhOpsgRFFaxYeiFskpgm5GMF1Qobfqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VOeUKbJN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VOeUKbJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F781F000FF;
	Mon, 14 Sep 2026 03:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789357375;
	bh=4p0mfVDNnOoh3qWWH7HnfieoFbtsP4K/Exl8L+3DQ3c=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=VOeUKbJNBqfUMxu1zLkohj+SsnCKkM2O025WykMo5vVIG/LTHD2pxBYB44Ha5R6kr
	 lA3/AiNQGsKsclQpNehX9wMpS38c3nG2O9OkPa35UaTbyy6BmL/fHYXQejPT+B+kYd
	 VtBKUpEPw1GyEhLylxwlq/VZZlLpV5jHQOvYH0bIDPierFr8RUS/QbdnnQY6IXrw5y
	 Qa99RCZx8Gc1RjcpXszOzR/or66L98Wtg/7oP8/UufWz/iUAdRlse0w3m1kcvu20O0
	 pz1r7akoUUSgyMtwAsJ7aTXorBJZALPR0F0D4ep/uNTvfaCB4d2NGiAMGSYu+OeFUR
	 7wMLEVnClBjSw==
Message-ID: <0691a903-cc82-4ad7-8264-cddbf146d00e@kernel.org>
Date: Mon, 14 Sep 2026 11:42:51 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: derive f_fsid with dev_t only when temp_fsid is
 active
From: Anand Suveer Jain <asj@kernel.org>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Cc: dwmw2@infradead.org, thiago.macieira@intel.com, dave.hansen@intel.com
References: <16069a6fc651168bfcd2394d6e57ce63a50231ed.1789235482.git.asj@kernel.org>
Content-Language: en-US
In-Reply-To: <16069a6fc651168bfcd2394d6e57ce63a50231ed.1789235482.git.asj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



This issue and its current fix (below) have been on my mind, as I wasn't
fully satisfied with the approach even though it works.

Now, I think I have a better idea.

The core issue isn't that the new f_fsid derivation is wrong (recap:
f_fsid derivation changed from f(UUID) to f(UUID + dev_t)). Rather, the
problem is that f_fsid changes unexpectedly after an upgrade.

So we need to address the upgrade behavior, not how f_fsid itself is
derived.

My new proposed solution:

 . Put the new f_fsid derivation behind a compile-time config flag (an
incompat/opt-in flag).
 . For stable kernels, this flag will keep the new f_fsid derivation
disabled by default.

The only drawback I see with this approach is that it adds yet another
incompat flag, making the incompat feature list even longer.

Please let me know what you think. I can send out v2 with these changes
on Tuesday.

Thanks, Anand


On 13/9/26 02:06, Anand Jain wrote:
> Commit c2a74ed0494c ("btrfs: derive f_fsid from on-disk fsid and dev_t")
> mixed dev_t into f_fsid for all single-device setups to avoid f_fsid
> collisions with cloned filesystems.
> 
> However, doing this unconditionally breaks backward compatibility.
> statfs(2) f_fsid changes after a kernel upgrade, and also can shift
> across reboots or dev re-attaches as dev_t values change.
> 
> Fix this by only mixing dev_t when temp_fsid is active.
> This means for non-temp_fsid setups or the original mount, we use the
> old method of deriving fsid based on the UUID.
> 
> So in the case of a cloned Btrfs filesystem, we won't be able to
> maintain the same fsid across mount recycle if the mount order
> changes.
> 
> Fixes: c2a74ed0494c ("btrfs: derive f_fsid from on-disk fsid and dev_t")
> Reported-by: Dave Hansen <dave.hansen@intel.com>
> Closes: https://lore.kernel.org/linux-btrfs/be0c08f5-2f31-40f5-8a3b-f2f58b3e00ff@intel.com
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  Dave (Hansen), I wonder if you could verify whether this fixes the issue
>  on your end. I have run some limited test cases from fstests as of now,
>  and they passed.
> 
>  fs/btrfs/super.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 464129b1b0d4..ddb620ac241b 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1836,8 +1836,12 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	f_fsid.val[0] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root) >> 32;
>  	f_fsid.val[1] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root);
>  
> -	/* Hash dev_t to avoid f_fsid collision with cloned filesystems. */
> -	if (fs_info->fs_devices->total_devices == 1) {
> +	/*
> +	 * Hash dev_t to avoid f_fsid collisions with cloned filesystems.
> +	 * Only do this when a clone is present so the original filesystem
> +	 * (mounted first) maintains backward-compatible f_fsid behavior.
> +	 */
> +	if (fs_info->fs_devices->temp_fsid) {
>  		__kernel_fsid_t dev_fsid =
>  			u64_to_fsid(huge_encode_dev(fs_info->fs_devices->latest_dev->bdev->bd_dev));
>  

