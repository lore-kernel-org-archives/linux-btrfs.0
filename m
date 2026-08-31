Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F8637DEBF
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 22:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214851; cv=none; b=YJc9EcfTPh9nVBd5O78pN2NRa7PMPD2NoIQ38Y9Rfe/hm4sMe0kp0AhMuiMpsMIwTOQJxm5Xkrm+XMnaHXP5fkWGEVNz2VD4SESuJ4IExm3kogjzsfsKOBD2AvH5kWLGZx5ghL/DWNI/QgErm2CzlSKGRZxqr8h1QSkZ2wph56E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214851; c=relaxed/simple;
	bh=a66VyJenc7QAtTf02m02uf/jBVqGafCFsK5oPKcERzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S2biNskAc7xloj2L1bSrTZFmPu1VcLmkbMvWZwYX6Q0lJ9wudENKVM60I2tIv55p1A4y8LgVj2hbhT9BZMgmnzsOJCIlQSOaMVWZn6oIw3rCv6G2+iytrYoy9E14PlCrVVY7cA8fulllUchyGjF0hmIUAP4t8gK0kevze87so2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=PnGgFMsI; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=e7TJvklA; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="PnGgFMsI";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="e7TJvklA"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 8F9FAEC01FF;
	Mon, 31 Aug 2026 18:20:49 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 31 Aug 2026 18:20:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1788214849; x=1788301249; bh=jivO4ENIZS
	3NBWQyKZVtpal53ffkZN08Ul472IN3T9k=; b=PnGgFMsIYXlahpvcrnZ7i4wd7j
	ZcPyCPJAd+HiIi3AdtwRApVzr+kmB82/j3H/JkNJGuzHzMIjzLsJ0fAqdUeb3IVv
	ZNIL83YHVgfP/HwEbW/OBUcWliFKcE2xNsQI+I73NLkE9SGwi5lKwFOKor/uAEv5
	etVcnz4d/BxGD5PK8BwRylzBi8TSUo3ttRv7qRSX2u2rlNUli9sSnsdO+ROUh+uq
	nktdfSG1egxvG1u7Hl/1du2IDF90LnOG3ajMSTx06h4RsG0PhmlLSuyJihzuwZiV
	HuMJyk32s/Jyfi4a128gLaXTbFy8i6r+0z7kAnFDdFREjyFpzdm/z61KmBkg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1788214849; x=1788301249; bh=jivO4ENIZS3NBWQyKZVtpal53ffkZN08Ul4
	72IN3T9k=; b=e7TJvklAgZZQBF5T+IiKlnD/MW1PggcuvtFojHo0tLtBnIafpqt
	xysKf/+29if07/BObLuf0iDojlC1+Jfi72JMW57FSzAFwlqMftg8VxNB9tSmWTh9
	TIVgQmjO7P17RN38BdgJZG+52WVk6aPguUcr29/xjOqlA7vEy+AJ9XNxL//tEHHO
	1bvRJ+WXy4CcKw9ToFUBPOi0wJjGZ/K/buYGofIv4btrK3xmjhHZF6vm5Jdykktx
	RZQryM7ddK+5LC9qwpubpUyYnYw8H6XvN4ze0YDSNmgTQfuzVGOUiuttl5QYCHSn
	kHvh1CvtTRhSHW1E3EV9vUg3X4ugwhzUWMw==
X-ME-Sender: <xms:Qf6VagzHHCGqO43XZORXmv6Idgt_tEq8FEY0e_7G5K0GivjHu5L5oA>
    <xme:Qf6Vakd-bg_AwEQvJosSn-Gm9VLlYJSI67y-HS12FDVfFI5GlED4OLALcINgGp1zj
    c964Tp61P2Z3ZpxF8-cKPMzPlQEGhoKjkk56pKzUdURH2THhlkkdLji>
X-ME-Received: <xmr:Qf6VakLXzfoJEdltjHa2oCJucy39t3ZvNp3FIe_PO3L0-5vf8LgJSYvFjs3gCFZgAlbgIc12wkpUhIcJREneQE15R9k>
X-ME-Proxy-Cause: dmFkZTGuyi6hYnEP7wuYE0suzm3l+LUS1fPI7rP/Bkw64uc5g5ORM9Wqc/cOjbvgabQRTJ
    ZFaIRwrQ3EhP67uEvTd/na7eGNJiCxjIFeq3KvTtnCUTDnLchkVqBDHJ6TyBAonVfJdTLW
    KfhChJeAHclkxvIfHIzpxpZkztwGJNz796dC3Ee70dG/bzxxYGcOj6LoGUS0pFdCappVKT
    Krc/7xYmP4xXvH0unIYzkqZvtR81Hij/cqrxvR+ZVxQHCK+dx9/AQPOzncsEwaBhb9AvKD
    eJ+F0H9fSlyggz7x7sLjzLR4gwr/yYG2+nCXuhhl+oR12XxaDtZvrx7nyOagLYlfNgCjYt
    FYXIs+G/4dSTk8HMMagJFnDvUP3Vvtn1XTpcU7iwARkrd3vfw3+1t8lP+VVG9uUsoMsJmc
    ChyuuIJ5GT5EIsSLuF6KskJ3r/EH84xsi84CZffodAdQssoNpewdlmmGgVKOxOSO0DZJsE
    Z5SCw5nt/McmBl/gKGq8qxgi9X/EqlpCjldd50GW+3EW8w4NZEHQQT6anVqwFbeYAnl7hD
    Leibx3CaxdS0+ybX4w+NQ01um0pTufDpGbn/3YE2ttBNDGSL8a5BnjzEUmipPmcu17B4t1
    vkB9SD/cKJiJvWYKlNOznAU43Vt1ORHXc+mRVc+eDwEIXiup+IS3p8Wq1fhA
X-ME-Proxy: <xmx:Qf6VatFwqE8xYGbOdOvEvxcWN_ELMosSlAQEKd7J0B6lipKnSvgFpg>
    <xmx:Qf6Vamq6Vxy97PlILT_n4O22LZCiA6GTv_4PCgZ4RkWjdAsXxRDCeQ>
    <xmx:Qf6VauRNIoTX1bVTUCYeXzpTnIh6JosRU2RJZ8HJs7Z7dAuJxgZbqg>
    <xmx:Qf6VarP5l0yUQFfn2fLx4DPZ0TKkAPhuOI6V4PNHXMkZf-4Oi_9jSg>
    <xmx:Qf6Vasj4xL4l7YV8-HycAknmAMjtz_hADCet6GmDvDtvOnXL98n1tTgV>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Aug 2026 18:20:49 -0400 (EDT)
Date: Mon, 31 Aug 2026 15:20:09 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove runtime tweakable feature sysfs interface
Message-ID: <20260831222009.GH325502@zen.localdomain>
References: <8a598d76555b5944d34bb08fa8dbeea28fc05db9.1787307129.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a598d76555b5944d34bb08fa8dbeea28fc05db9.1787307129.git.wqu@suse.com>

On Fri, Aug 21, 2026 at 07:42:10PM +0930, Qu Wenruo wrote:
> There are 2 features that are marked runtime tweakable inside
> /sys/fs/btrfs/features/
> 
> - acl
>   Which is a mount option, and it will not show up in
>   /sys/fs/btrfs/<fsid>/features/ directory anyway.
> 
> - extended_iref
>   This feature can only be enabled, but not disabled at runtime.
>   Furthermore it's already the default behavior since 3.12.
> 
>   So it means this feature is always enabled and cannot be disabled for
>   modern btrfs.
> 
> So there is no need to maintain the ability to modify btrfs' runtime
> features through sysfs.
> 
> And furthermore, the existing btrfs_feature_attr_store() is race-prone,
> it relies on fs_info->transaction_kthread, but our sysfs interfaces are
> enabled before transaction_kthread.
> 
> Meaning at mount time a sysfs write can trigger NULL pointer dereference
> if the transaction_kthread is not yet initialized.
> The opposite is also possible during unmount.
> 
> Thankfully that race is not possible in the real world, as the only
> supported feature is already enabled.
> 
> But it also means we do not really need to keep the race-prone
> infrastructure, so just remove it completely, and make the per-module
> and per-mount features files to be completely read-only.
> 
> Even with the sysfs tweakable features removed, we can still enable
> extended_iref feature through ioctl.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

FYI, I have been gating some behaviors like dynamic/periodic reclaim on
sysfs files not in features/ and I imagine there are some more out there
(like bg_reclaim_threshold). That has two relevant implications:

- We do still do "runtime feature setting" not through ioctl/mount opt.
  If we want to converge on only ioctl for that, I am open to it. Mount
  options only end in tears in my experience (have to be very careful to
  handle all remount scenarios as has played out with free space tree
  and async discard at least).

- Some features are not at whole fs granularity (like above
  per-space-info features) so it doesn't make sense to have this generic
  features/ mechanism anyway.

So with all that said, I support getting rid of this, but I apologize if
my stuff makes life more complicated for our "what is enabled" model
even with this patch.

Reviewed-by: Boris Burkov <boris@bur.io>

> ---
>  fs/btrfs/sysfs.c | 121 ++---------------------------------------------
>  1 file changed, 4 insertions(+), 117 deletions(-)
> 
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 39cb01ee441a..1f78bb1cf813 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -83,8 +83,7 @@ struct raid_kobject {
>  #define BTRFS_FEAT_ATTR(_name, _feature_set, _feature_prefix, _feature_bit)  \
>  static struct btrfs_feature_attr btrfs_attr_features_##_name = {	     \
>  	.kobj_attr = __INIT_KOBJ_ATTR(_name, S_IRUGO,			     \
> -				      btrfs_feature_attr_show,		     \
> -				      btrfs_feature_attr_store),	     \
> +				      btrfs_feature_attr_show, NULL),	     \
>  	.feature_set	= _feature_set,					     \
>  	.feature_bit	= _feature_prefix ##_## _feature_bit,		     \
>  }
> @@ -130,132 +129,22 @@ static u64 get_features(struct btrfs_fs_info *fs_info,
>  		return btrfs_super_incompat_flags(disk_super);
>  }
>  
> -static void set_features(struct btrfs_fs_info *fs_info,
> -			 enum btrfs_feature_set set, u64 features)
> -{
> -	struct btrfs_super_block *disk_super = fs_info->super_copy;
> -	if (set == FEAT_COMPAT)
> -		btrfs_set_super_compat_flags(disk_super, features);
> -	else if (set == FEAT_COMPAT_RO)
> -		btrfs_set_super_compat_ro_flags(disk_super, features);
> -	else
> -		btrfs_set_super_incompat_flags(disk_super, features);
> -}
> -
> -static int can_modify_feature(struct btrfs_feature_attr *fa)
> -{
> -	int val = 0;
> -	u64 set, clear;
> -	switch (fa->feature_set) {
> -	case FEAT_COMPAT:
> -		set = BTRFS_FEATURE_COMPAT_SAFE_SET;
> -		clear = BTRFS_FEATURE_COMPAT_SAFE_CLEAR;
> -		break;
> -	case FEAT_COMPAT_RO:
> -		set = BTRFS_FEATURE_COMPAT_RO_SAFE_SET;
> -		clear = BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR;
> -		break;
> -	case FEAT_INCOMPAT:
> -		set = BTRFS_FEATURE_INCOMPAT_SAFE_SET;
> -		clear = BTRFS_FEATURE_INCOMPAT_SAFE_CLEAR;
> -		break;
> -	default:
> -		btrfs_warn(NULL, "sysfs: unknown feature set %d", fa->feature_set);
> -		return 0;
> -	}
> -
> -	if (set & fa->feature_bit)
> -		val |= 1;
> -	if (clear & fa->feature_bit)
> -		val |= 2;
> -
> -	return val;
> -}
> -
>  static ssize_t btrfs_feature_attr_show(struct kobject *kobj,
>  				       struct kobj_attribute *a, char *buf)
>  {
>  	int val = 0;
>  	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
>  	struct btrfs_feature_attr *fa = to_btrfs_feature_attr(a);
> +
>  	if (fs_info) {
>  		u64 features = get_features(fs_info, fa->feature_set);
>  		if (features & fa->feature_bit)
>  			val = 1;
> -	} else
> -		val = can_modify_feature(fa);
> +	}
>  
>  	return sysfs_emit(buf, "%d\n", val);
>  }
>  
> -static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
> -					struct kobj_attribute *a,
> -					const char *buf, size_t count)
> -{
> -	struct btrfs_fs_info *fs_info;
> -	struct btrfs_feature_attr *fa = to_btrfs_feature_attr(a);
> -	u64 features, set, clear;
> -	unsigned long val;
> -	int ret;
> -
> -	fs_info = to_fs_info(kobj);
> -	if (!fs_info)
> -		return -EPERM;
> -
> -	if (sb_rdonly(fs_info->sb))
> -		return -EROFS;
> -
> -	ret = kstrtoul(skip_spaces(buf), 0, &val);
> -	if (ret)
> -		return ret;
> -
> -	if (fa->feature_set == FEAT_COMPAT) {
> -		set = BTRFS_FEATURE_COMPAT_SAFE_SET;
> -		clear = BTRFS_FEATURE_COMPAT_SAFE_CLEAR;
> -	} else if (fa->feature_set == FEAT_COMPAT_RO) {
> -		set = BTRFS_FEATURE_COMPAT_RO_SAFE_SET;
> -		clear = BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR;
> -	} else {
> -		set = BTRFS_FEATURE_INCOMPAT_SAFE_SET;
> -		clear = BTRFS_FEATURE_INCOMPAT_SAFE_CLEAR;
> -	}
> -
> -	features = get_features(fs_info, fa->feature_set);
> -
> -	/* Nothing to do */
> -	if ((val && (features & fa->feature_bit)) ||
> -	    (!val && !(features & fa->feature_bit)))
> -		return count;
> -
> -	if ((val && !(set & fa->feature_bit)) ||
> -	    (!val && !(clear & fa->feature_bit))) {
> -		btrfs_info(fs_info,
> -			"%sabling feature %s on mounted fs is not supported.",
> -			val ? "En" : "Dis", fa->kobj_attr.attr.name);
> -		return -EPERM;
> -	}
> -
> -	btrfs_info(fs_info, "%s %s feature flag",
> -		   val ? "Setting" : "Clearing", fa->kobj_attr.attr.name);
> -
> -	spin_lock(&fs_info->super_lock);
> -	features = get_features(fs_info, fa->feature_set);
> -	if (val)
> -		features |= fa->feature_bit;
> -	else
> -		features &= ~fa->feature_bit;
> -	set_features(fs_info, fa->feature_set, features);
> -	spin_unlock(&fs_info->super_lock);
> -
> -	/*
> -	 * We don't want to do full transaction commit from inside sysfs
> -	 */
> -	set_bit(BTRFS_FS_NEED_TRANS_COMMIT, &fs_info->flags);
> -	wake_up_process(fs_info->transaction_kthread);
> -
> -	return count;
> -}
> -
>  static umode_t btrfs_feature_visible(struct kobject *kobj,
>  				     struct attribute *attr, int unused)
>  {
> @@ -269,9 +158,7 @@ static umode_t btrfs_feature_visible(struct kobject *kobj,
>  		fa = attr_to_btrfs_feature_attr(attr);
>  		features = get_features(fs_info, fa->feature_set);
>  
> -		if (can_modify_feature(fa))
> -			mode |= S_IWUSR;
> -		else if (!(features & fa->feature_bit))
> +		if (!(features & fa->feature_bit))
>  			mode = 0;
>  	}
>  
> -- 
> 2.54.0
> 
