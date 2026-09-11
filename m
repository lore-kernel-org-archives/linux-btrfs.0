Received: from mail-vs2-f27.google.com (mail-vs2-f27.google.com [74.125.227.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F503F326C
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 18:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789152632; cv=pass; b=HpC2sHol6M00WyPFpBQeA/Qy7H/wUEV7xs3qh9pU6bHUvMo8zUi6P+7sMNBiz87O51mFmOeFEwEHy4qXg6tF1BS7qFlhhfCHnec2O6HztuMkbBkBZdRj/L+LmnyCe7Aj65rm5i+qpvplrjuAxCTd4cXoXABmKbJysuIwslyp+PM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789152632; c=relaxed/simple;
	bh=3KvOhxNm0CE5YxCoN9gJrLaYGWlZurxjm2gpi9Iw+PA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FUD4/8FbNkJeOcluBW+zOK74yNyq/BGS6jDfL9pCrvxxiYNVexo4uOe4s76Or1Wez6NyWR99T8p27LI1cVZkJ04q+yHEfuyjNA3JCHxQm4I7JBhKvqD3TftKyXqHu1FhHPZ/C7LNg2ooCEubc4sbEA991EbgvB9vEAjwLdC4aTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pZcloMXJ; arc=pass smtp.client-ip=74.125.227.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pZcloMXJ"
Received: by mail-vs2-f27.google.com with SMTP id 71dfb90a1353d-5c963d7503fso38703e0c.0
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 11:50:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789152630; cv=none;
        d=google.com; s=arc-20260327;
        b=GPIK4q4lOqC1ALrdEddnuTxFFvp/qiBcheloqBWR7ABrtglB+xjzPZfEOFl/yZOCoy
         q1PiL5n6VuSvH1Nt99sk10Uar2XSE6FX+KwNzrlzKeWVNBKs9w1vBNmpx+nzB/U/gmBU
         qY7yyVZ2EoLYJWqj1L3PjVhfdJMcpwbqEvXUVH1CLdcrBaiELyyeoverpoUalqOE668F
         mpnf+gGOhzhLT3NOPzkAKH0yHMml2Kc65A9T1HkaRGF+gwSyToBSR1Y45BiyCsTm7T8N
         Z9COqDr7DCaooE36uLacvzsvzf7qe905qWvtXZhwJkNofp4wWlBfv7fZNjP9ZxC4U6Fr
         LsaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k7Ebif+V/8GnwYOzbevbeoMta8WL2O5tmRjG7YpGVGM=;
        fh=IyRT1j+I4mDzy8IH9Z5IGEpzSVqbJqWIhPUGDdudT04=;
        b=Y0OMTzL3OnKTk1KbHhtXe3k84/rNlYubmKJMJZXL62F5FpTJs2NkP9O5xgYeVFJQSt
         k32K1TOAD8+75+ySlq5qrl+GHe4we2L5ae7/73+PJImsB7/jkrITETmpecsDdSjbV7C0
         no2L4q0aTtfT9NjPZob3v1mzRHakih1u6kSUdQgtTRZqb50fnhEhL9UnL5Pt4OwovpI4
         fkHngzEWeLHD3yOh53IbF6LeEEnqWC1MFYKtYlQ37NOYKn5rsQysFonwpewApSLofchW
         JrFumc7r+rsTIJVNCpTzU1tdxTOvY2Dp6/gwNzirestjkEghCW+9AL0vC0vL0TzO/wJW
         oY8g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789152630; x=1789757430; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k7Ebif+V/8GnwYOzbevbeoMta8WL2O5tmRjG7YpGVGM=;
        b=pZcloMXJ5cYBatjZ7UI3RpDFcwmwg/j9oB5lzU+swftc6TNlFcEov+VFfK4BO52FGB
         ea0TL+hj+TrhIap2vr0AHzjV1UCYIrobL9mzh/UqGlAWxwAkUVtaSwLyJ2fwj9vLcL3i
         UQ/lvWkSKfYryv8fQvZf4CFIpzNXCgZ0bbCVxT1xOC+2XcKn1K5cRPGXciVb4RAHF3Wo
         anIqJjnkGdB0c/Mehidmmgko4QPbwip5jGQZDCzdq3x6a0plD3E1O/rr0+Q8VpRGgAXj
         p7XHn4eh7qikh9Gr7YJOIf9aduOA73ko6yu+NchWjQJn+1Knwazk1PFEqeVtN10++Pf7
         lfVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789152630; x=1789757430;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k7Ebif+V/8GnwYOzbevbeoMta8WL2O5tmRjG7YpGVGM=;
        b=KcMcW44dOl6HV0HGunWcCjS9+adQtTYgNUuIBL99cuXU7S8s7ihBcrurZN5Tp1zbLP
         czRHVdaMerJYrOfodNyE6Xb0mpfVq7V+u43FOO2KdT0k2w7a7ii0yp60uXwZZWfx3Zq+
         8m0QtRcgoNOy9CnKZD+lYmToURXhEHsM4v8dbzSzWGtPBQOyuvW8qail00KN82CsFTGe
         wU5FIV8mSQUacHKZKZbOXCvqOZM5fhZK6kMFoX7l+tuCyE8BdYa8Wtcz/xv7zG0yn5tm
         BNO5gbTAnsfN7z+UkyOybgs9rtuD3nw8IQ8D7SddkylPPZm8GL0qJxkavvThevKyc8IV
         jnfQ==
X-Forwarded-Encrypted: i=1; AKwUvBxSPEU2v8rk87dwK/JnFo+Wvp1RMp6GN35W7L3yQ/lg/u+7U34QZGAiqrI9T8LQoyxFP5i5zfnSbxdr/A==@vger.kernel.org
X-Gm-Message-State: AFuF++n4MGZw75ybIauBzXBbuVBEe5IpenBmBg1NqOgCV+uix0hPBFz3
	LZUds9P8+wy7sud0Ti94zExigR+Cok0QCyLuG3P7AZ/78TnDaeFV363QdOSwzyBXuTUk7qWWzk3
	Na/3Q/d8oZ1xk0uV1MbipqnfFtdF6jkOWUQ==
X-Gm-Gg: AYBFou2i0VQl08MdokfYKaLdrAUtQUSNA7qblR0x8xhVhTJd30LwAAGqvOi5INsUY0a
	kCP1iSIaq65gx76UBMnWIEHDQ3EwKBB5/kAhsoiBv8BCyKOXx5X6jJgEsf4dMTt+OfINidvfwMz
	XUt0Cp2Y0IBaoQ2ctFtVe5/8bRdEp0WON1WWNO9vfeYYUOeUMhqT9mnSA//n4RXF3VOL3uR/lwK
	PFakfiNyCIaUEDPPeT6kz+HbQN4lf/op0dr7UvHPf/tIq2XSuht8pj3r4oHGcl/7kMFfj2OAwWW
	vW7G/v3z9v7IBfRRfP1g7HGH29HKqrpaZR1Tl9WTe1Sl2ZHlTCgZ9iITXnr7gV1ADSdrnCiQcI8
	e4/VL3o+hN2KyxZpapDSCKnz/ISFiBvcn5+UUOdlKt5BsUQ==
X-Received: by 2002:a05:6102:330d:b0:783:f3bf:f9aa with SMTP id
 ada2fe7eead31-792ac9e510amr2037393137.8.1789152629798; Fri, 11 Sep 2026
 11:50:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKLYgeL7nrA4nXcewdv9Fqg_s=3GS=vmoypnEiZBKQ7rySZFuQ@mail.gmail.com>
 <20260909002506.GF9053@twin.jikos.cz> <6a5c2d41-b10b-44cb-969e-b4a56d002ceb@gmx.com>
 <4c5117f7-1ddd-4596-8917-da47379506fd@leemhuis.info> <20260911182125.GE54722@twin.jikos.cz>
In-Reply-To: <20260911182125.GE54722@twin.jikos.cz>
From: Alex Romosan <aromosan@gmail.com>
Date: Fri, 11 Sep 2026 20:50:18 +0200
X-Gm-Features: AcwNN1UW1FBEQBXsPkjPpE7JnH1VnJKY_2TIGIr7JWZ82tYw8hH3-PTdsGDmOLw
Message-ID: <CAKLYgeLAXC5qbNAWnS3KNCijuRT9mF_hz4e1fUexx+D-J5Bs4g@mail.gmail.com>
Subject: Re: commit 108cc873398932af589c295f78c348513b8d70d9 breaks
 update-grub on btrfs root filesystem
To: dsterba@suse.cz
Cc: Thorsten Leemhuis <regressions@leemhuis.info>, Qu Wenruo <quwenruo.btrfs@gmx.com>, 
	linux-kernel@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>, 
	Linux kernel regressions list <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

i agree it's a regression. one question (and i am not very familiar
with the underlying principles), how do the other filesystems deal
with this? shouldn't the registering of devices be abstracted out
since i would assume every fs does it or is this something btrfs
specific?

On Fri, Sep 11, 2026 at 8:21=E2=80=AFPM David Sterba <dsterba@suse.cz> wrot=
e:
>
> On Thu, Sep 10, 2026 at 12:39:25PM +0200, Thorsten Leemhuis wrote:
> > On 9/9/26 03:13, Qu Wenruo wrote:
> > > =E5=9C=A8 2026/9/9 09:55, David Sterba =E5=86=99=E9=81=93:
> > >> On Tue, Sep 08, 2026 at 11:59:43PM +0200, Alex Romosan wrote:
> > >>>
> > >>> [...] Since version 7.3-rc1 i haven't been able to to a grub-update=
,
> > >>> instead i get this error:
> > >>>
> > >>> /usr/sbin/grub-probe: error: cannot find a device for / (is /dev
> > >>> mounted?).
> > >>>
> > >>> 7.2 is fine. a git-bisect identified commit
> > >>> 108cc873398932af589c295f78c348513b8d70d9 as being the culprit.
> > >>> reverting this commit from 7.3-rc2 allowed me to run grub-update
> > >>> again.
> > >>>
> > >>> this is not the first time i reported grub-update being broken on
> > >>> btrfs. i reported exactly the same problem on jan 8, 2024
> > >>> (https://lkml.iu.edu/hypermail/linux/kernel/2401.1/00596.html). may=
be
> > >>> the discussion that followed would help come up with a fix that wil=
l
> > >>> make everybody happy.
> > >>
> > >> I remember debugging that one, https://bugzilla.kernel.org/
> > >> show_bug.cgi?id=3D218353
> > >> Reverting 108cc8733989 ("btrfs: fix a lockdep caused by path resolut=
ion
> > >> during device scan") would bring back the lockdep warning and there =
is a
> > >> locking problem.
> > >>
> > >> The commit says it's fixing 2e8b6bc0ab41 ("btrfs: avoid unnecessary
> > >> device path update for the same device"), the difference is in lines
> > >>
> > >> (https://bugzilla.suse.com/show_bug.cgi?id=3D1230641)
> > >>
> > >> -       } else if (!device->name || strcmp(device->name->str, path))=
 {
> > >> +    } else if (!device->name || !is_same_device(device, path)) {
> > >>
> > >> Which gets changed to (by 108cc8733989):
> > >>
> > >> -       } else if (!device->name || !is_same_device(device, path)) {
> > >> +       } else if (!device->name || device->devt !=3D path_devt) {
> > >>
> > >> Each change is reaction to a bug, I don't see a clear fix which will
> > >> make it work in all cases.
> > >
> > > And I want to add that, the previous path based comparison is also
> > > problematic for namespaces/weird block device names.
> > >
> > > Although not common, it's definitely possible to map weird block file
> > > name into a namespace.
> > >
> > > Thus the path based comparison is not reliable in the first place, no=
 to
> > > mention the later lockdep problems.
> >
> > Well, but our #1 is "no regressions". And the recent change while fixin=
g
> > bugs clearly causes one, as Alex's report is afaics at least the third
> > about it; the two earlier ones can be found here:
> >
> > https://lore.kernel.org/linux-btrfs/dfbe1e27-dab8-4d55-8cf3-0b28eeac5df=
4@gmail.com/
> > https://lore.kernel.org/linux-btrfs/018a9738-1d4a-43a0-9352-a56d1e54136=
4@gmail.com/
> > Plus a repost of the latter here:
> > https://lore.kernel.org/linux-btrfs/dfbe1e27-dab8-4d55-8cf3-0b28eeac5df=
4@gmail.com/
>
> I'm going to treat this as a regression. And for the record Qu and me
> are in disagreement on that. My target is to make the systems boot again
> first, the fix may leave some problematic case (like mentioned, devices
> in namespaces), but that is probably a lesser problem.
