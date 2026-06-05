Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE482EEE6B;
	Fri,  5 Jun 2026 16:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780675583; cv=none; b=DPn1sNma7b0MlXqKHf+8Yp/7M+TOdh6KjgPVlpBujWnHq8dkDuuMSg1WM2v4wSh6jMhjo9PqCu8Eol5vhvm5NtIE4IACCs4NVTSY9NTxxW5MFyAgFsL2NkWEhCEuWlxHwozSJLOuUihXXZTrM6umD/9LSPY5YzE8MhEoyz4VEQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780675583; c=relaxed/simple;
	bh=PKDSgnpxy81X35TX/J+M0r0vRPvmWXqSP9uvpWnE9xk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oMJdz9T//HRU4zI6MhXP5Haoah7qmbOFNKvLWd170CPjnP20iefDZg24jQ+tjpdmae9l+aNAhVfOR9nzs68QRmX25ynCdic8Sym9s3uOsbyh2yVXGuZrEvbVJ5DPUN8pv0UOiU/l1Kiy+0m78JRsg85uzx1MKju1huJjXyecyDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uym920AJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uym920AJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C1A1F00899;
	Fri,  5 Jun 2026 16:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780675581;
	bh=0u2b+aNfpRAeJWiOdG+Jx53oUDcqFuldoPdg+Zn2h88=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Uym920AJTbpNMRxtr3TxL9czrArSeb/mqEbDbS8gPv8b8oCOLj9vNItS6k4SB2KLd
	 RgWn9kkNxpqvv84oT0RaxWRxXV1QrVslZQPhCDR/T2CkauwCSG4DU8nOMGslG/m+lf
	 bd6fxqPhwta8xHJVGQTqYRRjI/OwwgC+BYEicIIENzJxz/xksAXUedrbukwXZhocWw
	 y+jSTzaRVtuG4M7POFl1YMFzo1lBC6NqblRgyu9SJjXyjn4in1ZF/xStxBC1n072gM
	 CNRM36zg+L0yKJqEwAqQZHXH1lOMNOGa6+zjpQDY2OArQSMgdK6rIa09+XslpBkCMQ
	 0r6FGMPkPWwRg==
Date: Fri, 5 Jun 2026 09:06:17 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Tejun Heo <tj@kernel.org>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Drop WQ_PERCPU from ordered_flags in
 btrfs_init_workqueues()
Message-ID: <20260605160617.GA3477552@ax162>
References: <20260601-btrfs-fix-wq-warning-qgroup-rescan-v1-1-aff9a1128f27@kernel.org>
 <aiFKsSlaq-_VBGtZ@gmail.com>
 <20260604215811.GB3915915@ax162>
 <aiKNJN8w9Zq2s-Zy@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiKNJN8w9Zq2s-Zy@gmail.com>

On Fri, Jun 05, 2026 at 01:48:24AM -0700, Breno Leitao wrote:
> On Thu, Jun 04, 2026 at 02:58:11PM -0700, Nathan Chancellor wrote:
> > Could you please pick up this patch for -next to clear up this warning?
> > Not sure if this was on your radar since it is a btrfs change.
> 
> Why not getting this through the btrfs tree, given this is a btrfs
> change?

The warning is only visible after commit 21c05ca88a54 ("workqueue: Add
warnings and ensure one among WQ_PERCPU or WQ_UNBOUND is present") in
the workqueue tree. If it goes via the btrfs tree, there could be a
period during the merge window where the warning appears if the
workqueue tree is merged before the btrfs tree. Not the biggest deal
since it is a runtime warning but there are already other patches in the
workqueue tree that avoid warnings and David already provided an Ack, so
I don't see a reason to deviate from the proper process here. Up to
Tejun and the btrfs folks though.

-- 
Cheers,
Nathan
