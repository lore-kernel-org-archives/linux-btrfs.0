Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793122228;
	b=Q5PzUfQ/l79x5AAX8O4q9ufWxtq7ro5hSf13g62Fgu8wseWrMMfMTNpP7HNIjUKNa+bL
	 nQ1y03iUcvoiGSggvfudCcSPE+MIVH5e417Gk7Vdsf3H5+wLximsShACzCM6YGBJpVQw4
	 8sOQU1zpOeG4OgpKIkeSBFXUZZ2jTar/UjeS6gtS6Q3iaZrfGk0g21wcermuEdvRh3BcY
	 wfx5r0wbykbFiBBq6hhqs0jYvgkeExlRMRjLtLbg+YLLwE7vwMX5lP2L7Lr25dG5byri8
	 fEkdqLxf2GH1QGIe+fR0u5ksTr++pZFuy78fslbeEKwhUmqvh7SbcMIdxGFq0w/A8gw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793122228;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=7gQ+97vReKa4toS9130cb0MEUCUe5fofr2ehSKz/dNw=;
	b=SwrbA6XEgx61oGl+YLXHBUtL4DBWArYOukbHfpm1iOe2Hfq/XrEJmkPGtbNvTAd3vfLA
	 RqP5Iw1sjAWEOdHM2vHcWxHE6B+D/VpqzEchJYDsvFomtgBAADLofkUVgv7KEDW49V1A1
	 66jKzkfLl3GJP4d8GwzGfnYTOU2R1GHz3w5wUgQaxm/4eVL1oiUnAwn5Sh5iCj5C7XROv
	 Hhio4nBUTWNGZ1XlGnuS4C0MgeoNT3vGdKI13ejfdkfMCtC7n8eDzPekE/KoThzSWcGt6
	 r+JC6KpcdlzOsQOk8UDyyL7ut66dgN2WWQrroqPa5SUyhlDcMyCqyffysgt7SXloULg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=AH5XVSYu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918D9606A324
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 17:30:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 918D9606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=AH5XVSYu
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c49b431f022so10357266b.1
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 10:30:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793122222; cv=none;
        d=google.com; s=arc-20260327;
        b=hZdWoggj4p53uVi//ksSKuziGvNepww+BASHgI934AxKkjSgR1p6UtPv2kJWXw/Y6V
         pO1ydZuxUVhFoud0TohOPgTcN0Ssc2MbCNxa8sdugWEqrdsRwxtsGP96UqIe76CaIVJk
         9EMFVbr/bRFUaICjlyVvEq+AEM+ZKT14XwjHMs4YlntNsG/1mr0cKk3JsBB/E8cJGQnC
         aL8xW7jxXK2DYYxqFRfg49ZAbxSQkOaEoIgtoIL4ARUbQVJi16m7iPIZVkzyanu1E9jN
         YbkmNuDG8Rq0c4a+YhU0SqtCBWG9QBOi3r6jIyJszjyKFlZxcbyogqu0sm40NNstphpz
         APTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7gQ+97vReKa4toS9130cb0MEUCUe5fofr2ehSKz/dNw=;
        fh=nO8NQ34pUvNJpRpjgri5rXnzTFVe+Pluh7PeAg5G1vY=;
        b=B3AaUXtTtXrY32+scxDDsHpP2ORube8vBT8Mu4piQpuYfAkue6TpUa1UdxJYTr5zsl
         pgvg49JMXcWXOjGsXQFRSOvbU6Oxv0Us51wUa+BrhIRxhaPyPYFAWw9hfhRAcwzP3K0H
         fINXm88RPMW7mqkkqvCTvMIaHF+rXTVGeGPxBatOqJOXJ1NlW1itb1tem6zpoNpGfT9H
         jUVkY+FxEkB3m88MxXBEwZNUrFlFsTFoV5i8/YVdQDWJBPkuam8DOTRFVBKIOSJ8HBci
         HPDjN9a4HMYzHEyKlgYhRXi9g/iVf5zUO0AdQi3MM3NTBHUhknI3npmGskIbHlSFpxn5
         mgiw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793122222; x=1793727022; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7gQ+97vReKa4toS9130cb0MEUCUe5fofr2ehSKz/dNw=;
        b=AH5XVSYuq6HUx6QejcrLzJHXiZbWI9DboIxOz+yByNgh84gxZAIKBuzZHV99EG6rqB
         sL71z4Wm6MSPA3Nnza0i731ilrImuFj3jUTow6hkS/0r7bYzxQobbOzdeIyt6ASGeEbF
         yTa0PHt944q+HSgG6NrCVe3wZJYFAVwhpzaLqX011nHEVLqO4I7UJy1zd5cfMTXQHdaA
         BSUKBBxl7R08MamwKyO7Ss8mI2wGFLi7Y2RxS2XZ75lMQCOMaDZ6YNjy/Um35SI/BQEx
         H9A/IMXo16KCWMivgQdBOKUL0g+UWglSQzebhEs3U4Ckl7bH2Y72gGHNDHSXACje/sxH
         22yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793122222; x=1793727022;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7gQ+97vReKa4toS9130cb0MEUCUe5fofr2ehSKz/dNw=;
        b=EG9RsquZcsv2PYi2FVgSRg1YUHN0BGAPFR+sL+Ku8lXyfsDWQduAeYEYh2n42ffZc+
         7Ep3o//iIRSp1lgz5D1kllH7pEY61Ew9+mzJnm+5UcVXiTTSpFG/r2GYvWWKN4C+VJem
         RpfyHM2ROoYIBKoiyXSQv/67v8/zcGCBZdDbhUZ+EYXd3EGSZ2Qb7+Wb+/antunY3g9U
         BdgtO+CHZJvxNY+kcOwTnfjot4MqFfnWAjSsZFpBYQUiGffGTVlWQIAYSzFSDJtDSCKe
         Rkox/0MN8+TDoeywraplSLh1+OO4qD3QjdrKdsyADgrMc6A+nhG4Mp7NJ6sgcRNihH5H
         m01A==
X-Forwarded-Encrypted: i=1; AKwUvBy/HNQlIinSbj44T2nXOtQEeOjxRPyvpUva3Mzp3QCtUMxbQ9hv2vMkULGJEN7iqucpD7ve9qn8EikUMg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJKDHoWDK6hhjGJlH1Cn3yAVAT4yXFuDTOL5Z8c2ygQXp707EoE
	frNc4Yz6s7gAkOv48Z/KJ9+4fHWXJ2sUbKvZWwgeqX4G9pb/pD9z//U1Fto8CjzYEa8HJaYmVcd
	vSj0b+FKmuAogGIdmaOLClRh4D4NdHernlqiUGbXS
X-Gm-Gg: AYBFou0J6iGjTsy3Xz2o2ZvHs46u3aZd/6+4kRT8DE/pEW7rd4yEv+8rpD+bxb2Ag6N
	85fiR/aySbvz6vynOgcx72kLfBLWM2NyQ0wexs71F864l6bRAoq/7493rk5Ci8GxTT1Ajafx01K
	f9tOi2Z7zBBmXNZuVJsIllAFnopMdBxy7bzDXgTcCCly0kP2wzlHBYYzo2l0gHUjxd6p1kiJDUC
	o7fcxQbKJxhMc1BP+A66G/xfPdmE5b35JFyXKXjw/gSWFFM7NrNmbZaL1O4Mb+oNNOz1pySA89M
	RMgcdMDjcuhh0C1hiKrhy8Dkx7Sgqg9ecUkgPzav+dHniZvxA6G1YGul0pSItSvkzVB9ap0akYY
	9FPcx/YJceeC6WmNXAhK1pXFNxxVX7ZEKmzNkVBTqM+TE09X2yPKJ/kELtme65RxhnmYkGg/AqR
	rJMKkeV9rNT8HZuP6i90Ho29x+phpSv+1jNaLPljMviOPWwdsc0iVkmNugAuB1qzy2+JYM32oAl
	PjGtNCC6vrsSf6+g/phkHPRxC15U4gOYA==
X-Received: by 2002:a17:907:80c:b0:c46:6a50:40c2 with SMTP id
 a640c23a62f3a-c46bdee2675mr1178260566b.39.1793122221137; Tue, 27 Oct 2026
 10:30:21 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com> <14f5f919-55bd-47c6-a1c8-6f1445cce733@app.fastmail.com>
In-Reply-To: <14f5f919-55bd-47c6-a1c8-6f1445cce733@app.fastmail.com>
From: James Houghton <jthoughton@google.com>
Date: Tue, 27 Oct 2026 10:29:43 -0700
X-Gm-Features: AclHuK_V7ZmMdE83iy-wOvaliSqHMUcbKVcnfqQwnRgRgjPYRFDHKTZOMwXOk5E
Message-ID: <CADrL8HXQdzcroeGN-ACjyy-jSAdBNHiT1_BCVVe0P+Y8ZueiyA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] uaccess: Refuse and warn on user accesses when
 current->mm is NULL
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <kees@kernel.org>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 26, 2026 at 5:13=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrote=
:
>
> On Mon, Oct 26, 2026, at 22:52, James Houghton wrote:
> >
> > This series comes out of a set of bugs that were found in KVM where the
> > kernel can sometimes write to a random process's user memory[1]. The KV=
M
> > fixes at [1] are still required, even with this uaccess series, as note=
d
> > by Sean here[2] and below in this cover letter. The beginning of this
> > series includes fixes for similar bugs found through static analysis
> > with Claude Opus 5.5. I don't think any of these bugs are more severe
> > than the KVM bugs[1].
> >
> > We hit one of the KVM bugs in production, and it was challenging to
> > debug. This series makes such bugs, where the kernel is doing uaccess
> > without an mm, much more obvious.
>
> Nice work!

Thanks!

> > Such an access does not reliably fail. The user portion of the address
> > space belongs to whatever mm happens to be lazily loaded, if any. If
> > the access faults, the fault handler refuses to handle it and the copy
> > fails, but if the page is already mapped, the access silently reads or
> > writes another task's memory.
>
> This sounds like the problem depends a lot on the architecture,
> and to what degree they implement lazy mm switching. If an architecture
> makes all user pointers invalid for a kernel thread, this does not
> actually happen, right?
>
> E.g. on arm64 with CONFIG_ARM64_SW_TTBR0_PAN, the page table base for
> the current process is only set in user_access_begin() and would
> not point to any task here. Without ttbr0_pan, it should be
> covered by cpu_set_reserved_ttbr0() turning off all user space access
> for kernel threads.
>
> Should this perhaps be addressed in architecture specific code
> instead of in a common place?

You're right that whether corruption can actually occur depends on the
architecture and config. I'll write a note about this in the v2 cover
letter.

That being said, I still think the right thing to do is to have the
new check(s) in common code. Instances of improper uaccesses are still
bugs, even if no corruption occurs.

> > =3D=3D The New WARN =3D=3D
> >
> > The rest of the series makes the generic uaccess helpers WARN_ON_ONCE()
> > and refuse the access when current->mm is NULL:
> >
> >  - Patch 6 adds uaccess_should_fail(), which combines the existing
> >    should_fail_usercopy() fault injection check with the NULL mm check,
> >    and uses it in place of should_fail_usercopy(). This covers
> >    copy_{to,from}_user() on all architectures (including the masked
> >    user access paths, which never call access_ok()), the
> >    __copy_{to,from}_user() variants used by KVM's guest memory
> >    accessors, the user-backed iov_iter copy routines and
> >    strncpy_from_user().
> ...
> > The checks are deliberately limited to generic code. Accesses
> > implemented entirely by architectures (get_user(), put_user(),
> > clear_user(), and direct users of user_access_begin() or
> > masked_user_access_begin()) are not covered. Please let me know if the
> > new check should be placed elsewhere.
>
> I would think that user_access_begin() is a more natural place
> for the added checks, as this should be called exactly once for
> any function that accesses user space and also stays out of the
> way of the copy_from_kernel_nofault() etc.

user_access_begin() isn't used in a lot of places that I want to
catch, including the KVM case. Roughly:

  kvm_write_guest_cached() --> __copy_to_user() --> raw_copy_to_user()

There's no user_access_begin() in there. :/

I do think user_access_begin() should have the new check though, so
I've added it in the v2.

Thanks for the feedback, Arnd. :)
