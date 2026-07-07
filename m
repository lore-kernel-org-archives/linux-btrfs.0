Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F3B3B5306;
	Tue,  7 Jul 2026 09:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783417502; cv=none; b=cgbmIYRv1e0CUrWpUEf1NkNo34zHx7Qjg3RlYb9aUmYD4E8/OgcIdioLg80jQTPiv8NzWqX0+Yvsq17Flrb3FRoNGpMReZgc6WMw3LPMo0/TieMQEc9MP3+KcbtohfSa6YKeyOFEcH83HV+BeNjR39zd7Ueh20iXNN4V+57ziz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783417502; c=relaxed/simple;
	bh=2S9yd9fLAO85LsOBO7roqAB0derg/n3kyJ+bXKqa0+k=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tbP/jJbAWO0Kqic0Dv2+7YDhQcrBbJqLQmCbaKBR47FPIOfGPuSRJqCeEE/ebbzx5+h0yo9oiiMUUDCZLNX2o3RqINS40Utt54rxNY0AV4DOrJRQ7WrbdKPMv+5F5U/Vd4QXKCWCODFncoNRtQ1Wdtn2oL73nG9rzehNZ4JGl9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mNeiJR45; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNeiJR45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93331F000E9;
	Tue,  7 Jul 2026 09:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783417500;
	bh=kiDc7shEh7OxRVl3ZerxDgGIpR2Va9iAm1QgqF51tTc=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=mNeiJR45zZPlPgkjVCgbc9hz/toQwssGu4qIke2fVijFvN5ZcSwYZ7pos3AvnNlH9
	 4X/riPB13yc46GfJkX3eoILg0wfLOw+oX7fyO/dEDEZMmxEW/n9JOnQsRhZMYR3JPT
	 JkIy5PVnua/R91X2bB8QjVJMdjDtqIbsQy0c6cPm8bXkO+xkxYiUkQlJUSY3kJ7LPQ
	 nUdwUWjwOxtvHjEb/SY/EIQrvD9b+6+mFOZFbOlII8MpeZkO1Q5qHkex7fwK8uqLKN
	 nApfhxBe7kqy0J/cBvVjTr80x84n3275C/o0ad47fNwn/leLE7FJULgIxuhBoxjm6k
	 o8auZ1ZlUSxeg==
Message-ID: <8aa304b0-99bb-4940-923a-27abf9bd6b9b@kernel.org>
Date: Tue, 7 Jul 2026 17:44:57 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fstests: btrfs: new test case for leaking
 BTRFS_FS_STATE_REMOUNTING flag
To: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org,
 linux-btrfs@vger.kernel.org
References: <20260704085208.86039-1-wqu@suse.com>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <20260704085208.86039-1-wqu@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/7/26 16:52, Qu Wenruo wrote:
> This is a regression test for the patch "btrfs: fix leaking
> BTRFS_FS_STATE_REMOUNTING flag", where conflicting mount options can
> cause btrfs leave BTRFS_FS_STATE_REMOUNTING set.
> 
> Such set BTRFS_FS_STATE_REMOUNTING will interrupt several features, and
> the test case will use "btrfs qgroup rescan" to catch the
> BTRFS_FS_STATE_REMOUNTING flag.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  tests/btrfs/352     | 53 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/352.out |  2 ++
>  2 files changed, 55 insertions(+)
>  create mode 100755 tests/btrfs/352
>  create mode 100644 tests/btrfs/352.out
> 
> diff --git a/tests/btrfs/352 b/tests/btrfs/352
> new file mode 100755
> index 00000000..2ccf7fab
> --- /dev/null
> +++ b/tests/btrfs/352
> @@ -0,0 +1,53 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 352
> +#
> +# A regression test to make sure failed remount won't leave
> +# BTRFS_FS_STATE_REMOUNTING flag set, which can interrupt several features,
> +# one of them is btrfs qgroup rescan.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick remount
> +
> +_fixed_by_kernel_commit XXXXXXXXXXXX \
> +	"btrfs: fix leaking BTRFS_FS_STATE_REMOUNTING flag"
> +



We can replace this section with the existing helpers or,
even better, with a new one as shown below. I am not too
particular about creating a new helper, that is up to you.
However, the use of existing helpers such as
_require_btrfs_fs_sysfs and _require_btrfs_fs_feature
will be better. Thanks


> +rescue_opts="/sys/fs/btrfs/features/supported_rescue_options"
> +if [ ! -f "$rescue_opts" ]; then
> +	_notrun "No supported_rescue_options sysfs interface"
> +fi
> +
> +if ! grep -q "ignorebadroots" "$rescue_opts"; then
> +	_notrun "\"rescue=ignorebadroots\" mount option not supported"
> +fi
> +


diff --git a/common/btrfs b/common/btrfs
index 30288f07b61a..57453fb39893 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -100,6 +100,29 @@ _require_btrfs_mkfs_uuid_option()
 	fi
 }

+# Check for the availability of a specific option within a btrfs
feature set
+# Arguments:
+#   $1 - Feature attribute of /sys/fs/btrfs/features/
+#   $2 - Option string to verify inside that file
+_require_btrfs_fs_feature_option()
+{
+	local feat=$1
+	local feat_type=$2
+
+	if [ -z "$feat" ] || [ -z "$feat_type" ]; then
+		echo "Missing argument(s) for _require_btrfs_fs_feature_type"
+		_exit 1
+	fi
+
+	modprobe btrfs > /dev/null 2>&1
+
+	_require_btrfs_fs_feature "$feat"
+
+	if ! grep -qw "$feat_type" "/sys/fs/btrfs/features/$feat"; then
+		_notrun "Feature type '$feat_type' not supported by the available
btrfs version"
+	fi
+}
+
 _require_btrfs_fs_feature()
 {
 	if [ -z $1 ]; then
diff --git a/tests/btrfs/352 b/tests/btrfs/352
index 2ccf7fabdb71..14e357dbaa37 100755
--- a/tests/btrfs/352
+++ b/tests/btrfs/352
@@ -14,15 +14,8 @@ _begin_fstest auto quick remount
 _fixed_by_kernel_commit XXXXXXXXXXXX \
 	"btrfs: fix leaking BTRFS_FS_STATE_REMOUNTING flag"

-rescue_opts="/sys/fs/btrfs/features/supported_rescue_options"
-if [ ! -f "$rescue_opts" ]; then
-	_notrun "No supported_rescue_options sysfs interface"
-fi
-
-if ! grep -q "ignorebadroots" "$rescue_opts"; then
-	_notrun "\"rescue=ignorebadroots\" mount option not supported"
-fi
-
+_require_btrfs_fs_sysfs
+_require_btrfs_fs_feature_option "supported_rescue_options"
"ignorebadroots"
 _require_btrfs_command quota rescan -w
 _require_scratch
 _scratch_mkfs >> $seqres.full


