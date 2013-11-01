Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060Ab3KAU5G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Nov 2013 16:57:06 -0400
Date: Fri, 1 Nov 2013 13:56:59 -0700
From: Zach Brown <zab@redhat.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH 01/13] btrfs: add ioctls to query/change feature bits
 online
Message-ID: <20131101205659.GQ19383@lenny.home.zabbo.net>
References: <20131101170654.164867629@suse.com>
 <20131101172240.170283465@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131101172240.170283465@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> +static int btrfs_ioctl_get_supported_features(struct file *file,
> +					      void __user *arg)
> +{
> +	struct btrfs_ioctl_feature_flags features[3];
> +
> +	features[0].compat_flags = BTRFS_FEATURE_COMPAT_SUPP;
> +	features[0].compat_ro_flags = BTRFS_FEATURE_COMPAT_RO_SUPP;
> +	features[0].incompat_flags = BTRFS_FEATURE_INCOMPAT_SUPP;
> +
> +	features[1].compat_flags = BTRFS_FEATURE_COMPAT_SAFE_SET;
> +	features[1].compat_ro_flags = BTRFS_FEATURE_COMPAT_RO_SAFE_SET;
> +	features[1].incompat_flags = BTRFS_FEATURE_INCOMPAT_SAFE_SET;
> +
> +	features[2].compat_flags = BTRFS_FEATURE_COMPAT_SAFE_CLEAR;
> +	features[2].compat_ro_flags = BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR;
> +	features[2].incompat_flags = BTRFS_FEATURE_INCOMPAT_SAFE_CLEAR;
> +
> +	if (copy_to_user(arg, &features, sizeof(features)))
> +		return -EFAULT;

If these are all constants shouldn't that just copy out of a static
built flags array?

#define cpp4ever(suff) \
	BTRFS_FEATURE_COMPAT_#suff, BTRFS_FEATURE_COMPAT_RO_#suff, \
	BTRFS_FEATURE_INCOMPAT_#suff

	static struct btrfs_ioctl_feature_flags features[3] = {
		{ cpp4ever(SUPP) }, { cpp4ever(SAFE_SET) },
		{ cpp4ever(SAFE_CLEAR) },
	};

	if (copy_to_user(arg, &features, sizeof(features)))
		return -EFAULT;

?

- z
