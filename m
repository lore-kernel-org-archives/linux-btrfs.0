Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B87E332614;
	Sun, 20 Sep 2026 11:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789904968; cv=none; b=HmYV2yrExqvcemByl5ykVS4PyMyUh3monnGX2CWI7OFhW1c5fOcjFvjBA9xA3VwFgJC6zoq6V79lA1NDF+nkluh9hS2QUcRX7CuZldTfpwcvza6NlzEeHdcjEQ17yu93qWfHD6n8OrA5fFSVYH+I7Hr14QrO6N/2BV3x0yyWe+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789904968; c=relaxed/simple;
	bh=MHqN6m8g7bz/LG2xEatDhpZMscQMAyM0gkQ9eMK0lc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FOF6aqFxF9YuAlHsHUvNacR9jqPjkk5JhXo1NQHawzhefjK1yTEYGyHXwtGfcz7Sw2CgJjEgXSOyJ24G6VM1OiMVjwdUbLvqv/Jqkxu8N/uNXDpP5R6i6tDQ0424MP9upJKCtUHMp8+97FAEM5pwcWL8V6kWUE35NVjgQJoluvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fS8Wd289; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fS8Wd289"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E1F1F000FF;
	Sun, 20 Sep 2026 11:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789904967;
	bh=u+eqXugeE8+wko1Lwz359hsu8/ttXP8vDa8GEDnI4OI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fS8Wd289uZPvZg1em+stbj1IaVaPiq5tGaNZrVxLCSw/O7fNjRD/Wo6ZQwE2UdEXS
	 n7FQ0GdA2Wcg2vaL4olvs0qxn9Hi4I7YkXqBPuM+r9DCIsaKMx/hHVbetSgx4bE2SZ
	 6LHPNC+pOpY/jb0zvFB34TvS6eRwiliU07Qc/eW0hLwvNyF/1rXXltwm+XH4BZJXtd
	 XS8TEIMOXFMt6dekB4IDy6DT4N8pwDhknCaza3qH4xzONs+6Az8tfcLP8Kr24lpqV+
	 76I240GDqQT6kNz/SqcwTUoivRtLkUb2Mf9yYiSwtdVc6+KCJ1Xo1Msa/lyIQ/WWWl
	 uvQYunI6JgB+A==
Date: Sun, 20 Sep 2026 19:49:21 +0800
From: Zorro Lang <zlang@kernel.org>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] btrfs/255: add _cleanup function to kill the balance
 stress process
Message-ID: <aq_IJyTS8q4ByIqv@zlang-mailbox>
Mail-Followup-To: fdmanana@kernel.org, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <a6bc4f66b0217153cb55ea987c26de70c50eba48.1789660025.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6bc4f66b0217153cb55ea987c26de70c50eba48.1789660025.git.fdmanana@suse.com>

On Thu, Sep 17, 2026 at 04:52:56PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Currently if we interrupt the test and balance stress process is already
> running, it keeps running after the test is interrupted, requiring the
> user to manually kill the balance stress process before it can run any
> fstest that uses the scratch device. So add a _cleanup function that
> ensures the balance stress process is killed when the test is interrupted.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---

Makes sense to me, thanks!

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  tests/btrfs/255 | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/btrfs/255 b/tests/btrfs/255
> index 14c12904..fbcbf57c 100755
> --- a/tests/btrfs/255
> +++ b/tests/btrfs/255
> @@ -12,6 +12,15 @@
>  . ./common/preamble
>  _begin_fstest auto qgroup balance
>  
> +_cleanup()
> +{
> +	cd /
> +	rm -rf $tmp.*
> +	if [ -n "$balance_pid" ]; then
> +		_btrfs_kill_stress_balance_pid $balance_pid
> +	fi
> +}
> +
>  _require_scratch
>  
>  _scratch_mkfs >> $seqres.full 2>&1
> @@ -40,8 +49,6 @@ for ((i = 0; i < 20; i++)); do
>  	$BTRFS_UTIL_PROG quota disable $SCRATCH_MNT
>  done
>  
> -_btrfs_kill_stress_balance_pid $balance_pid
> -
>  echo "Silence is golden"
>  status=0
>  exit
> -- 
> 2.47.2
> 
> 
