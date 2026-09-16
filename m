Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E065221DB;
	Wed, 16 Sep 2026 16:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789575679; cv=none; b=Okb27e1v1eBKLxtTxDv9T8Y9zzlb4ScbbUPVXeMF3ea6WvxWb5PwCco+6zssIyiMbafOaJzuBIXOQ3TbczoWxF43EEX62chM1/Wwz10esmcAlNMTYpTeQo/YdJoBBqowFk/rsgd7sXmSrGE2BXNM7HnDzTuW8xysDBApS7dcBpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789575679; c=relaxed/simple;
	bh=Ggt5lYz2ut+5jVN4uLiCQ1OUSeVeJyn+g/6w0QtWXp4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PJ6BNSoEQASF6xeatx1dkEN1sVvJjIO7Enmxt9nqZF+Fx4/wCNeRnO5oJLofEgyAhw/2/WFpew7T+gelz2Hr0GwCvMcwk/pTx1R8y1F6omU7Jqfz+Qncj3EUVUxe85fJBJFK3b//KEC9Wxmx7T+32ZXRv1xMN8ik6Kg+nCrdVFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gmo+SKjE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gmo+SKjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6711F000FF;
	Wed, 16 Sep 2026 16:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789575675;
	bh=MNacnTptV7O+2l7w3nUG4Y4VfCMbDYw+g2EkkmSc/mg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=gmo+SKjErnLa3XM9CDqYLbVzwXDKJPDVOPzplb3Z7KMzjFhAdWRqhFkMxL9LeUiM2
	 9krgE4cigxJv0Zo/BMbvyE6S+8XJO1jzWKbZjYmbHlDjK/fmfXTc+EYrZkEUmItYOr
	 mXa6gwNe8NnROlPhcG7oepLlF1KQjLCmiKGQVxycWpwZcxLX1JDDWqAZWwilYuFlkx
	 GcT6qLwKvrM0+tlWLJn8KilVOwXxiZ4OMaX1UyjbsYJM/sEqpz4bW/j0JK4spPCrl0
	 E52hQ8QrSvy8TEUQIam2SaMGZSQnng0rGid/1bqfANBdPwX7n8A3cMhP2lw3a4kClk
	 IYFogXL9LLKMw==
Message-ID: <3c7970372211aaddf5c127e4c3cef0f462b060a6.camel@kernel.org>
Subject: Re: [PATCH fstests] btrfs: test graceful ENOMEM handling in
 synchronous dirops
From: Jeff Layton <jlayton@kernel.org>
To: Filipe Manana <fdmanana@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, Anand Jain <asj@kernel.org>, Filipe
 Manana	 <fdmanana@suse.com>, linux-btrfs@vger.kernel.org,
 fstests@vger.kernel.org
Date: Wed, 16 Sep 2026 12:21:12 -0400
In-Reply-To: <CAL3q7H4P32sBFHoUkD6NhxhJs=aLGMFKqB9ZGO0716Vx3r5vag@mail.gmail.com>
References: <20260915-btrfs-enomem-v1-1-ca07610ebcad@kernel.org>
	 <CAL3q7H4P32sBFHoUkD6NhxhJs=aLGMFKqB9ZGO0716Vx3r5vag@mail.gmail.com>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-09-16 at 17:03 +0100, Filipe Manana wrote:
> On Tue, Sep 15, 2026 at 5:33=E2=80=AFPM Jeff Layton <jlayton@kernel.org> =
wrote:
> >=20
> > Recently, we added some patches to allow btrfs to handle -ENOMEM errors
> > in dir-morphing codepaths [1]. As part of that, we added fault injectio=
n
> > knobs to a few functions so we could test that error handling.
> >=20
> > Add btrfs/354, which uses the fail_function facility to inject -ENOMEM
>=20
> Please don't add here the test number, as this is very likely to be
> changed at commit time as we have already 2 other pending test cases
> with that number.
> Just say "Add a test case...".
>=20

ACK, will do.

> > into btrfs_prealloc_delayed_dir_index() and confirms that a
> > dir-modifying operation returns ENOMEM to userspace without aborting th=
e
> > filesystem:
> >=20
> > - mkdir fails with ENOMEM (not EROFS),
> > - a subsequent create succeeds (fs is not read-only/aborted),
> > - a mount cycle runs orphan cleanup and the automatic fsck confirms
> >   consistency.
> >=20
> > The injection is global, so any other btrfs dir-entry creation can
> > consume it first -- including the test's own $tmp redirection when /tmp
> > is itself on btrfs. Pre-create that file and retry until the mkdir take=
s
> > the error.
> >=20
> > Add generic _require_function_error_injection / _inject_function_error =
/
> > _uninject_function_error helpers to common/inject for driving the kerne=
l
> > fail_function interface.
> >=20
> > [1]: https://lore.kernel.org/linux-btrfs/20260825-btrfs-enomem-v4-0-b93=
63fa8714a@kernel.org/
> >=20
> > Assisted-by: LLM
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  common/inject       | 50 ++++++++++++++++++++++++++++++++
> >  tests/btrfs/354     | 83 +++++++++++++++++++++++++++++++++++++++++++++=
++++++++
> >  tests/btrfs/354.out |  2 ++
> >  3 files changed, 135 insertions(+)
> >=20
> > diff --git a/common/inject b/common/inject
> > index 6b590804d1ea..da78c1931135 100644
> > --- a/common/inject
> > +++ b/common/inject
> > @@ -111,3 +111,53 @@ _scratch_inject_error()
> >                 _fail "Cannot inject error ${type} value ${value}."
> >         fi
> >  }
> > +
> > +# Requires the kernel fail_function facility (CONFIG_FUNCTION_ERROR_IN=
JECTION
> > +# and CONFIG_FAIL_FUNCTION) and, if a function name is given, that the=
 function
> > +# is annotated with ALLOW_ERROR_INJECTION().
> > +_require_function_error_injection()
> > +{
> > +       local func=3D"$1"
> > +
> > +       test -d "$DEBUGFS_MNT/fail_function" || \
> > +               _notrun "$DEBUGFS_MNT/fail_function not found; CONFIG_F=
AIL_FUNCTION not enabled"
> > +
> > +       if [ -n "$func" ]; then
> > +               grep -qw "$func" "$DEBUGFS_MNT/error_injection/list" 2>=
/dev/null || \
> > +                       _notrun "$func is not registered for error inje=
ction"
> > +       fi
> > +}
> > +
> > +# Inject a fixed return value into a kernel function via fail_function=
.
> > +#   $1 - function name (must be ALLOW_ERROR_INJECTION annotated)
> > +#   $2 - return value to inject (e.g. -12 for -ENOMEM)
> > +#   $3 - number of times to fail (default 1)
> > +_inject_function_error()
> > +{
> > +       local func=3D"$1"
> > +       local retval=3D"$2"
> > +       local times=3D"${3:-1}"
> > +
> > +       # Writing the function name to "inject" creates its per-functio=
n dir.
> > +       echo "$func" > "$DEBUGFS_MNT/fail_function/inject"
> > +       # The retval file is an unsigned hex attribute (DEFINE_DEBUGFS_=
ATTRIBUTE
> > +       # "%llx"), so a negative errno like -12 must be written as its =
unsigned
> > +       # 64-bit (two's-complement) hex form; a bare "-12" is rejected =
with EINVAL.
> > +       printf '%#x\n' "$retval" > "$DEBUGFS_MNT/fail_function/$func/re=
tval"
> > +       echo 100 > "$DEBUGFS_MNT/fail_function/probability"
> > +       echo 0 > "$DEBUGFS_MNT/fail_function/interval"
> > +       echo 0 > "$DEBUGFS_MNT/fail_function/space"
> > +       echo 0 > "$DEBUGFS_MNT/fail_function/verbose"
> > +       echo "$times" > "$DEBUGFS_MNT/fail_function/times"
> > +}
> > +
> > +# Stop injecting errors into a kernel function set up by
> > +# _inject_function_error().
> > +_uninject_function_error()
> > +{
> > +       local func=3D"$1"
> > +
> > +       echo 0 > "$DEBUGFS_MNT/fail_function/times" 2>/dev/null
> > +       echo 0 > "$DEBUGFS_MNT/fail_function/probability" 2>/dev/null
> > +       echo "!$func" > "$DEBUGFS_MNT/fail_function/inject" 2>/dev/null
> > +}
> > diff --git a/tests/btrfs/354 b/tests/btrfs/354
> > new file mode 100755
> > index 000000000000..9b9e601d6405
> > --- /dev/null
> > +++ b/tests/btrfs/354
> > @@ -0,0 +1,83 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2026 Jeff Layton.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 354
> > +#
> > +# Verify that an -ENOMEM in the synchronous directory entry insertion =
path is
> > +# returned to userspace without aborting the filesystem.
> > +#
> > +# btrfs pre-allocates the delayed dir index before modifying the btree=
, so a
> > +# failure in btrfs_prealloc_delayed_dir_index() must surface as -ENOME=
M from
> > +# mkdir()/create()/etc. rather than a transaction abort. Use the fail_=
function
> > +# facility to force that allocation to fail and confirm the fs survive=
s.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick
> > +
> > +. ./common/inject
> > +. ./common/filter
> > +
> > +_require_scratch
> > +# For the automatic fsck at unmount, which confirms the orphaned inode=
 left by
> > +# the failed operation is cleaned up and the fs is consistent.
> > +_require_check_dmesg
> > +_require_function_error_injection btrfs_prealloc_delayed_dir_index
>=20
> Please add here somewhere a call to  _fixed_by_kernel_commit so that
> when test case fails on an unpatched kernel we get an informative
> message.
>=20
> Otherwise it looks good, thanks.
>=20

Thanks!

Should I wait until v7.4 merge window opens before resending this so
that the kernel commit IDs are stable?

> > +
> > +func=3Dbtrfs_prealloc_delayed_dir_index
> > +
> > +_scratch_mkfs >> $seqres.full 2>&1
> > +_scratch_mount
> > +
> > +# Pre-create the stderr file. fail_function has no usable task filter,=
 so the
> > +# injection is global, and $tmp may well live on a btrfs filesystem it=
self. If
> > +# the shell had to create this file it would insert a dir entry and sw=
allow the
> > +# injected failure before mkdir() ever ran.
> > +touch $tmp.err
> > +
> > +# For the same reason any other btrfs dir-entry creation on the system=
 can
> > +# consume the one-shot failure, so retry until our mkdir is the operat=
ion that
> > +# takes it.
> > +err=3D""
> > +for i in $(seq 1 20); do
> > +       rm -rf "$SCRATCH_MNT/dir"
> > +
> > +       # Force a single -ENOMEM (-12) into the prealloc path.
> > +       _inject_function_error $func -12 1
> > +       mkdir "$SCRATCH_MNT/dir" 2>$tmp.err
> > +       res=3D$?
> > +       _uninject_function_error $func
> > +
> > +       # mkdir succeeded, so something else consumed the injected fail=
ure.
> > +       # Note we must not leave the directory behind, or the next atte=
mpt
> > +       # would fail with EEXIST rather than the injected error.
> > +       if [ $res -eq 0 ]; then
> > +               continue
> > +       fi
> > +
> > +       err=3D$(cat $tmp.err)
> > +       break
> > +done
> > +
> > +if [ -z "$err" ]; then
> > +       _notrun "injected error did not reach mkdir"
> > +fi
> > +
> > +# The error returned to userspace must be ENOMEM, not EROFS (which wou=
ld mean
> > +# the transaction was aborted and the fs went read-only).
> > +echo "$err" | grep -qi "cannot allocate memory" || \
> > +       { echo "unexpected error from mkdir:"; echo "$err" | _filter_sc=
ratch; }
> > +
> > +# The filesystem must still be usable: a create with injection disable=
d must
> > +# succeed. On an aborted (read-only) fs this would fail with EROFS.
> > +mkdir "$SCRATCH_MNT/dir2" || _fail "filesystem unusable after injected=
 ENOMEM"
> > +
> > +# Cycle the mount to run orphan cleanup for the inode left behind by t=
he failed
> > +# mkdir, then keep using the fs to be sure it is healthy.
> > +_scratch_cycle_mount
> > +touch "$SCRATCH_MNT/dir2/file"
> > +
> > +echo "silence is golden"
> > +
> > +status=3D0
> > +exit
> > diff --git a/tests/btrfs/354.out b/tests/btrfs/354.out
> > new file mode 100644
> > index 000000000000..afe30ed36fea
> > --- /dev/null
> > +++ b/tests/btrfs/354.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 354
> > +silence is golden
> >=20
> > ---
> > base-commit: a370dcbed43563f0462801e889e0eceb93c7cfad
> > change-id: 20260915-btrfs-enomem-e70077862117
> >=20
> > Best regards,
> > --
> > Jeff Layton <jlayton@kernel.org>
> >=20
> >=20

--=20
Jeff Layton <jlayton@kernel.org>
