Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32C22D0C9D
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2026 07:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776412483; cv=none; b=HMxK+hyf/nmAhuN6mOgfyZw/I1qArqohEbzcgaQOfMhtcd7y37LzYVHRiB2EhHADLJ/iKF+SoVZM26ljISpCa/uxUdUCcOhQTSbEGhi4n8UcVxmzieUQiID/Zhp7XrW1BGZ3jhz7E+YLbyrWIRjRzXFbM6PsZw+qMNI+RPQYOdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776412483; c=relaxed/simple;
	bh=ELNnSD5V6GV8UAxMfCfYcH5TJ/QE+NC4gZ8Gl1X69ew=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kz52XD5IXh9Bra/CgEENjy1f0uwRs1aWupWdpD9CFLGi86ektOksXtTKYSZCScSy+K7ewYnY7p9dA+M+4niBlI5TzCzkJ4mWk3eer60q7erZEh+nk02Q8Jg9GFDdS1JovqvjTdEL43o5H8L88fe4yaahiaim8Ai9GOic9RFZ2uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rp8Vbia7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rp8Vbia7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A60C19425
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2026 07:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776412482;
	bh=ELNnSD5V6GV8UAxMfCfYcH5TJ/QE+NC4gZ8Gl1X69ew=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Rp8Vbia7UluOGFkpWIdXNY+CSq2FnlVuydRr8V+B3yrFXmIZMlAc5BSvMYBb44OOA
	 PO0l4QSklFlMB1n/vlqBNMlWnqzE5pw+jvw7Jo1kfvpF/StT1t1YNpDe3694fzazBK
	 OQZoKAxJrnSol3hw1y3Vfj4iP9tW7NXdiJmn1UUH83rtP+ZImNGWivXtkScomPWnBu
	 mI7y7NhOFr7kBNBdqUcmK0Dii7VgTMYW6J25J7wQEvc1Bj3/PddTu5Qzct1CcTjsXG
	 3JDWxJJ8BTEoYDXh5+7AFPXF1cWACk3Rja4839Yze/0j/ht7XFmL2w8kdUx6EN2P0g
	 xJ1RHZHBoghqA==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b982b0889d8so60325066b.2
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2026 00:54:42 -0700 (PDT)
X-Gm-Message-State: AOJu0Yxl1o8QWK1+6KP0u26fiDVLmqETHfgXvGW5HzinxqCLd410d/aT
	pgAw94LpySqbdk9Xt0RJbgPywLZ61I/1LldCawE6Cv3xq3AYa7aFlPmXtimEzkKPAGwgqxRS7Ll
	uAO6tmgFOZOc2+U0QYLu4suRhQnOgIeQ=
X-Received: by 2002:a17:906:c10d:b0:b88:6164:6421 with SMTP id
 a640c23a62f3a-ba419559a3bmr85593166b.16.1776412481057; Fri, 17 Apr 2026
 00:54:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776278490.git.fdmanana@suse.com> <20260417021639.GW12792@twin.jikos.cz>
In-Reply-To: <20260417021639.GW12792@twin.jikos.cz>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 17 Apr 2026 08:54:03 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5hdPAGxSYqsCJ4QMoO6a-5KE18t1d6Kr3X_+YoRs3zFw@mail.gmail.com>
X-Gm-Features: AQROBzBsW_TqWVDYIjhkBXdfMDJzNyTF0YHTtLme5diRXHO7m37g7-gn5gBjmnc
Message-ID: <CAL3q7H5hdPAGxSYqsCJ4QMoO6a-5KE18t1d6Kr3X_+YoRs3zFw@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] btrfs: reduce memory consumption for block groups
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 17, 2026 at 3:16=E2=80=AFAM David Sterba <dsterba@suse.cz> wrot=
e:
>
> On Wed, Apr 15, 2026 at 07:44:38PM +0100, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > Reduce the amount of memory used by block groups by using kmem caches
> > and reducing structure sizes, plus a few cleanups. Details in the
> > change logs.
> >
> > V2: Add one extra patch that was missing, to further reduce the size
> >     of struct btrfs_free_space_ctl (patch 7/10).
> >
> > Filipe Manana (10):
> >   btrfs: use a kmem_cache for block groups
> >   btrfs: reduce size of struct btrfs_block_group
> >   btrfs: use a kmem_cache for free space control structures
> >   btrfs: remove start field from struct btrfs_free_space_ctl
> >   btrfs: remove unit field from struct btrfs_free_space_ctl
> >   btrfs: reduce size of struct btrfs_free_space_ctl
> >   btrfs: remove op field from struct btrfs_free_space_ctl
> >   btrfs: remove block group argument from copy_free_space_cache()
> >   btrfs: remove unnecessary ctl argument from __btrfs_write_out_cache()
> >   btrfs: remove unnecessary ctl argument from write_cache_extent_entrie=
s()
>
> Reviewed-by: David Sterba <dsterba@suse.com>
>
> We're planning to remove the free-space-cache in the future and
> hopefully majority of users have been using the FST so I'm not sure the
> optimizations will have much impact.

I know we plan to remove the free-space-cache, but none of this is
specific to the free space cache.
The btrfs_free_space_ctl structure is used for both the free space
cache and the free space tree; it is the structure for the in-memory
cache per block group.
