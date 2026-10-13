Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8212D4B95A3
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 23:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791933993; cv=pass; b=QNedNypFe8iC4gIKyNzflAGAr5ihJQTcBS0c+fuAj6YAhJOUg2Np0vgKK9xXTCwmGMIXd/kr7HATerMnInJLACejVJGCKRvTmsbRz7INXmUA+QPq6/+9719nbBocf7MIiwKVN9XH2Eq61WMDJyQ8Q1yvfODdyXuoOAHU3pGTQtg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791933993; c=relaxed/simple;
	bh=8Uq0x9UqVfBkwbkSh/dbBEjcj23bL2NZoWkq/GoZ/Ik=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f18cuTOvNQ/5nFESXqUpN4atJylzVJiQrbmM+HP0JdKbwvCcSS9rl/I/f7PLgltgYXJZ5xNnBhukrnEWTb1FUgSre1ak6+YT3gv/NEhBTmEbwZUXI3teeFH5s5pUC77CcA4unopQH8eIk42rDvT7nfEHtqoVRdUoMtlCoIGywB4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=studiomoob.com; spf=pass smtp.mailfrom=studiomoob.com; dkim=pass (2048-bit key) header.d=studiomoob-com.20251104.gappssmtp.com header.i=@studiomoob-com.20251104.gappssmtp.com header.b=Lr49M6dL; arc=pass smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=studiomoob.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=studiomoob.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=studiomoob-com.20251104.gappssmtp.com header.i=@studiomoob-com.20251104.gappssmtp.com header.b="Lr49M6dL"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93e55db58cfso355764985a.1
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 16:26:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791933990; cv=none;
        d=google.com; s=arc-20260327;
        b=j2Wq0QqGbLfm83AAMziTlChLNILREPRwD4pzCxSORL5mi4T5HmhQPES5u1aTFBiqgk
         ld6r5AKFvoXVbQxSv9SCKFBsTfDrEzLeGv4hGLJGL2uGgsQNbpwiffOkz+NNz9zmwIIJ
         iR9JK89yyGXjbaRM6Q13Q5wVagVRBaoZklnNWGHhRBGi0YIcR//Ukp2oZESiJdPyWz7y
         aMMN4RM91Sj7obfmTyOGPhYWSXzFGCYS9qXrM8Qf9jJ7MXlnQ/V31o/6RgWrpCTbGfLg
         6+j4IW2De6mlrkoLVuGsgExwXoEPvJTbqk56N7Wnn7XWt+MWwqWNve2nIM9O/rDXQxDF
         U0Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=8Uq0x9UqVfBkwbkSh/dbBEjcj23bL2NZoWkq/GoZ/Ik=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=hFkQ8vsWHewlZoTuc3Rnc47IOfF9FNuJxs7ok1NcVrGfcP9qwMMU4dAm67mM5VWv3k
         nFO+S2n9brhISnZqCUemPXugoAwvS/2zv3vk5g+kMxVyPmhE8UMsQLt00QT50bNw0ewy
         8Y1f1FhA8nWEq5+6h/O64peaNk2OSAz7km7OU26ZMmcnn7TsHoKyJEIdI7OfVTGfRRUM
         dAmSdvbr7De2E/ITJ0MNsKxGEb9C3aGVtYLHMEy7TibRslT7SXyq6hQHeeFS5O4Cjaez
         uGj37/rqm2Iv5mHwCAplrSVujiYSU31jah17CZ7ncZzOr4y0rpIL7Pe2FUKDZF1Q33py
         n0Og==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=studiomoob-com.20251104.gappssmtp.com; s=20251104; t=1791933990; x=1792538790; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8Uq0x9UqVfBkwbkSh/dbBEjcj23bL2NZoWkq/GoZ/Ik=;
        b=Lr49M6dLg/rDujyVkmcSkfU062TQqudcR1fVsW0Yx3pfsveMyjdeMkO33ZxJVR/Mjb
         I+dN0otZJSeTSdIOzK9jPBhTI9I46IF4r4HvZJ/7id7Ikf9mwm9N1x46tWvfRY34rRiL
         RC/3NVZUDJUj097wOlCtn0AsM3GyPotRc7pO9IemowpoIsA2oVOtz0vc6x23Nep9TVmZ
         1toJm/P32/6W9N98LmAXoZu1OeAbxCDmUUoeNKbMB3T4sLzJfCyrF72Y/yM4Z/KVHEUf
         GHzpKCNcKdPhmE4pshPEjod47ORZHQOvZX9lEVOAVs1IyJiBcOjEz4mdz8FAgQdVIWaq
         IANg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791933990; x=1792538790;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8Uq0x9UqVfBkwbkSh/dbBEjcj23bL2NZoWkq/GoZ/Ik=;
        b=V892skEBHx7BqZBJKn0dneabBmcN2FaW5fyvKCSr0SgCwLxzdAt4YzZ0o5Q+zYRakm
         zFBxKjHdyjnXAWq0BgtTjHDmx8pr69uTfPbE+AaU44TUoO1wXwL+CoK2jEmW5wVG97eI
         cas574Js6RLqxAdSBxkxY3J+c7gF1NVW3mms1FaiJt5D6iQSMvhdVIDqz8dsELQ4jIrD
         7r+cAiAeCdO2lz12pfMu6Tqe3zqtCoNRmDislKxvys/Tzg7r7EfjQc5td4B0TO7azIt8
         W+yuwFv0N/4a1UBjyVXKXtgWS7jUaTvbBeBecPYAwWm7zlHIbimn/wnGD8Sh5Vsithj0
         JWwQ==
X-Gm-Message-State: AFq9FYJYWN6l/jN6Ytkltg1+yKxqEyl/KyvESp3x7H+KDjMwpgv40shI
	YXHcjH33qdToEZ0Orm5Vy8fNdH3ypqD9hG2aizU9CcC9fb1HMLiv8KO00fS9nopeZnTV0xh/fye
	L4FpsdiqPfef5a9GS1J4kJ3IWEmRDUkbAniQbC05KV7ouX9/nS8uKKJs=
X-Gm-Gg: AYBFou1zSdZVHTYGtMjIr5nPaco7B8WnyWEHlCx7pQM4bnwDnRYGDfhmGLXA7sOFhZw
	gN5jDt+IeNfne3dWNxTYCz0O8SyQBR3TK4Xdtv3iCIFz7shFKwS4R/SscHBQPNqWEbi4y4jyxC2
	IUYVTVEL7+BKfkwPWw+Uts230vkfLKLNQGW0lQyKGXcEtQvNU5NQAbb2irWFn9DjOfbhajDd+ZO
	uo9P7K6nYPXG4OLFhNqrUjnZFK82idwtTTfRzX4SgxGjTKuTKnXfQrQXufw5RR455LlnyeZmh0I
	1fUAhZmCKUze0wob/nShWGg5PlVrfGmD5yZWLbrXhEU3NVwDz/hSHcpU8yNRwGYDjGPVqutaQdu
	XMzSOyRT1PKQX
X-Received: by 2002:a05:620a:461e:b0:937:6de8:b40 with SMTP id
 af79cd13be357-93ebd1b713amr2511443385a.15.1791933990224; Tue, 13 Oct 2026
 16:26:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACU5Mh9KdABHuGXFTY3=s1DiPSPUSLabhWZnQRrYjnjK5PGPSg@mail.gmail.com>
 <a29f5513-1483-4064-bd8a-aa2399076bb7@suse.com>
In-Reply-To: <a29f5513-1483-4064-bd8a-aa2399076bb7@suse.com>
From: =?UTF-8?Q?Cl=C3=A1udio_Fernando_Pinto?= <claudio@studiomoob.com>
Date: Tue, 13 Oct 2026 20:26:18 -0300
X-Gm-Features: AclHuK9qNA9P3gxuzO65OXpVaXqn6tloPjWEindZkR9upr87oTxpw805Uo0jatk
Message-ID: <CACU5Mh85r_7x48Rh4b6kC6_-tm0LJz=PZiJ6NBfOvcWxve0iBA@mail.gmail.com>
Subject: Re: [RFC] Stacked fs keyed by lower i_ino: detecting a nested
 subvolume root
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 13 Oct 2026, Qu Wenruo <wqu@suse.com> wrote:
> I'd say that's btrfs specific, and should not be considered as a generic
> solution using that 256 magic number.
[...]
> In fact st_dev is the common practice. As that's exactly the way to
> distinguish different volume/filesystems.

Thank you, that settles both questions.

I will drop the inode-256 test and compare the device that getattr
reports instead: on a directory lookup, vfs_getattr() on the lower
child and on its lower parent, and EXDEV when stat.dev differs. That
treats a subvolume as the separate filesystem it is, costs a getattr
only on directory lookups, and is not btrfs-specific.

One thing I would like to confirm rather than assume: every inode
inside one subvolume reports the same st_dev, so checking directories
alone is enough to know which subvolume a file belongs to. Is that
right?

Thanks again,
Claudio
