Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66663655F5
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 13:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787061160; cv=pass; b=Ze4QocaDV/THKWgpDFSNcn12i+bCTQ5rkRvcT2w5EhEzyEs3zVIFDBGppuRkZ7SqJ1w/TZaROBvP8pr3ssV0P/8ULG3vAp+6QOD7GqQq+9Atb+ToowbOCQtYKpdOJyJLS79xL4BF+KIDrEEuXjGYwmxTaR+7HAY3jr9qieUVHFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787061160; c=relaxed/simple;
	bh=lOpcQPg0x1nrJx6GftlJ8KKHAkt1Ezywo80pyW278M8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j38M9ZCTHqi9VvK5FXlFPIECWyeYmFPpSztXADMxEqY48bpDIaj8sowz9GrPG+8BB0NNTG/asSJC6V4i9dL7smRJU/acrt6JEQ0ImykPHBkvq3iwyFutq8Wdb4c/qDEFsbBj4ZkSnWoB1DiMvmYEG1TreBZhhjRliB0BvN8PxcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BNyLVsCq; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BNyLVsCq"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a156627e22so1590986a12.1
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 06:52:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787061157; cv=none;
        d=google.com; s=arc-20260327;
        b=USHmg5HQAiok9LPxrgGpRoieA7PEmz09+OlV53kh4CFdaTyjB1X2HiEfQ22wzOZFh1
         cbhLDLFmgP2ydnYZe9Jz01c1rPnyFtiS0AZ2d/GnVbaQpI/UTcUTQ189niW9ZdXWtJ/O
         cTmGpNQmaVJhu6MeBUIwxd2jUa5Jxc2yz2hhTUTGLuqrAwPXjO8xwfZuNt0v11io39gS
         PfBFwe4VeFMqutj1/6vE9orSBAiXgYveZIjgzmmcCV1x07als2J39giJnjogDkcVF68p
         l9PyPDEa9RQHYALQUzYRFtM24rMDJZyscPdayWJ19lqpGaSFaSsBAshr0HrLDauhKfAV
         K/9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VBbCUUNXA+VpWaRnlxAsWeFMSgHjcHgRxE1XTM91mtU=;
        fh=mgweVz/EbGjz8ape2vHBEWzOpQwtMgCU9FMsRKXIqJ0=;
        b=PvVf77uBYQsqu6DpkN8Jsm68QohW9XkNaEslwnVjAuRh9iUXfe+1ylwi5xJ9jql6fo
         ojHaohCXu3OnpEhzzDgg67kBNGEXeyIvsP9S6G7+EZDHSFQPe229APLLPnC9O0BjLx+c
         xaWzT65OaIae+sq3uZ4CRzUuUuAOfSrf/MDJds29eNrik51+7Ay6gXeUDLjCRVjuOWUB
         3jJDvfQQPzWuOvi39mbH9DICJRz0mSPAA8MUCBINmB4RUiEX86rMPhPX2j5+ar0ETrom
         fth2jTLqspgMFreYnc9+kU1uYsMcHYEX7eFdXMo8dx27LI79GsHpUlpJcLyR+kVw07FV
         GY9g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787061157; x=1787665957; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VBbCUUNXA+VpWaRnlxAsWeFMSgHjcHgRxE1XTM91mtU=;
        b=BNyLVsCqPFaEllKn2bQ2FYNa1E9PXPWvkzTu9GGNEfK6T7+SDc2wvhghUXAp8ahJNQ
         aEkf9V+hwLvMeAlUprXwuCX+A8Icd5B8IzILxHX2BdHta+QfKc3k7yeNJy7NNxi9P4eE
         cKGWwVj77CTyhAaGKPU+fnTXB0l4m/LeBXunMUy3rMUgeSuCj0OTYhHI1N7AegO5rYv6
         b7dRaUR3ZL32fxVnhFh6gD7enlh6PG0EObSZ3QGvLHJqk6FX5bFLXGbt6YW0lmQDxJtO
         PQ8/2jMvgFCcr38QxKvYDMMCq0ICA14k35ELLZVxFapQaGkf3tvOeJhAbUIZw95Tlsm0
         +sDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787061157; x=1787665957;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VBbCUUNXA+VpWaRnlxAsWeFMSgHjcHgRxE1XTM91mtU=;
        b=TUSifYaB1H4FJwPk3Ja4F1QC7A+uZXbK+iR0SIEpSCAeCu6rWwqzEh3XuiYQZLxMql
         isO6rUftTMfoiWwTn6wGUuftPwWyt3L0wuocZf2G45NeZ4tSIwcapQlUCsKn62fM6xCI
         prHQV3VPvAH4IF0BONMD9yVXB7Mwbnpcb1b/V+ovoVuQVZhzyZJVHE6yC9zlppSndSxN
         yEzK1X6q1/Bgd0fxgfYkb3KZ8aIsypMkW0VIHmOMe//0NJvqpJta/4eVFk6iMnR3AVzp
         ZcDJ4T13B0BO6dpDvlQiG0o2hpbVZoGi4IMQXdlXQ4sWkH8gLIWCJlmMxw0FNsxwvS52
         M+Sw==
X-Forwarded-Encrypted: i=1; AHgh+RrC/+ToozWyhp7u58gxVYHZ33YHDfQAGm1DoI36WUGCHjOImeU1m/W+R86qCRg+tfsCXkG++GwljgfBoQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywrbg+NE8H8WPMXFUO3Q56PXTOq5vZxN9xThPv8XPv/sjiEmecL
	hUvyuFZI1i82YQIic9xP0QWjk7q8dEB1r0W6NwBKQOUCp4qCVttfGL3dKXqGBUoIVMGdKqClzyh
	8wWO8/3SIwtBbLkym9wzxQO4HsLJU3iuIiOdQZT8=
X-Gm-Gg: AR+sD12Ql+KiDeyehdvEPNflBy+MYvversnr9+fDOhVQ/TAxAXN05dYGL5JgRre3n08
	urVRhm1b0PFkCFpeC8DFSkgMoumJZbLrvfySaE4218IGeiSRtXZjikBkVNtSmpapYEUUEtfIMZ3
	6Xm/+3I1HZNtMuxLPROFNCZMl4+WStHH8tj54ZPO23HVckfcA34/fxT5YR0yVvQuIeNgRDv4EP6
	a6phTJ9ILo5CxL+fHromz8BJKJe+wLAabN9M9lPRi5+0MDfrzhP9xwfW8lY7KO3THDyTmxnwv35
	PfIbCGUF7vsdSUaoCyyI9Z6M5ZPfV6n2B+6HjFMZvTBHoAYzqIhZ9bVIrXma7Zo4btLT+AbygWd
	1LXEO3TjVimUnKjeH2ZjuldcIQcxqJixjXXeJKGU2paoVFWqz838RSL3/EGlaxjNjX2+Ox5tWXt
	2ynmKWtSHbeFxA
X-Received: by 2002:a17:907:94d3:b0:c21:7c98:d9ec with SMTP id
 a640c23a62f3a-c218b06cae2mr406712466b.5.1787061156758; Tue, 18 Aug 2026
 06:52:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAB1LBmsQ2xFHQeEDFspwpFSNkiFUefBCn559EJsfEz5ZUAXYiA@mail.gmail.com>
 <20260818121131.GD54102@twin.jikos.cz>
In-Reply-To: <20260818121131.GD54102@twin.jikos.cz>
From: Laurent Lyaudet <laurent.lyaudet@gmail.com>
Date: Tue, 18 Aug 2026 15:52:25 +0200
X-Gm-Features: AcwNN1Un4Cz0lxH-OlAq0gD15ZPA8gpCunTi1UPj6CHFGcJ5AmUp0t0xKFoZ9BM
Message-ID: <CAB1LBmvFnJz-Gx4xncyGUhztKs6r=JP0i0qFXurxba-+ZaVo7Q@mail.gmail.com>
Subject: Re: [RFC] "final" flag for a directory
To: dsterba@suse.cz
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Thanks for your reply.

Le mar. 18 ao=C3=BBt 2026 =C3=A0 14:14, David Sterba <dsterba@suse.cz> a =
=C3=A9crit :
>
> On Mon, Aug 17, 2026 at 04:26:31PM +0200, Laurent Lyaudet wrote:
> > I had an idea about adding a boolean flag "final" on directories in an
> > advanced filesystem.
> > In the same way, the "final" keyword on a class in OOP can be added to
> > declare no subclass can exist,
> > the "final" boolean flag on a directory could be added to say that the
> > directory has no/must not have any subdirectory.
>
> Do you have an existing use case for that?

Yes, I have two use cases :
- For directories that are used for "technical" reasons.
It is very frequent for cache subdirectories to be final.
You add a cache subdirectory (for example in /tmp),
and it's meant to receive a lot of small files.
If you look also at the directories used in a DBMS like PostgreSQL,
you will also see a lot of final directories.
Etc. The examples are numerous.
- For directories that are created manually by users,
there are usually many more final directories.
The depth of folders in the home of most users is kept low most of the time=
.
In fact, it could be a feature that all folders that are created under
/home/@somelogin@/
and that are not under some hidden directory like .config
have a (sticky/recursive) flag "auto_must_be final".
So far it means 4 boolean flags, if I add the one you suggest below:
>
> > So here we see that 2 flags could be added:
> > - a configuration flag "must_be_final" forbidding to create a subdirect=
ory,
>
> I see two possible semantics of that:
>
> - final, no subdirectories exist and new ones cannot be created
> - no new subdirectories can be created, but some may exist
>
or one enum of 3 values on 2 bits, and 2 other boolean flags:
1. "must_be_final" and "no_new_subdirectory_can_be_created" (pseudo_final),
2.  "auto_must_be final" -> flag/enum 1. has been set automatically or manu=
ally
3. "is_final"
And when the user creates a folder in some Window environment like Gnome or=
 KDE
under its home directory,
then Nautilus for example would set "must_be_final" with  "auto_must_be fin=
al".
If the user then goes in the properties of the folder,
he could unset both or switch  "auto_must_be final" to  "manual_must_be fin=
al".
Then when the user tries to create a subdirectory in this directory,
if the current directory is "auto_must_be final",
then "must_be_final" and  "auto_must_be final" are both unset without
any user action on top of creating a subdirectory.
But if the user tries to create a directory when "must_be_final" and
"manual_must_be final" are set,
then Nautilus pops up a warning with confirmation required.

> Also given how other attributes behave once set they can be unset. This
> is up to the user, and possibly a restricted operation.
>
> > - a status flag "is_final" telling that no subdirectory currently exist=
s.
>
> When the filesystem tracks the number of subdirectories already, then
> it's an easy check. Otherwise a full search must be done, atomically wrt
> creating new subdirectories.
>
I agree that a count on subdirectories is a better statistic.
I think there should be both data:
- a subdirectories count when the filesystem agrees to keep such statistics
  (along with files count, symlink counts, etc. this could be a whole other=
 RFC)
- a "is_final" flag for wider adoption and precise cases of optimization.

So, if we look at the configuration status of a folder,
we have an enum:
- must_be_final_manual,
- must_be_final_auto,
- must_be_pseudo_final_manual,
- must_be_pseudo_final_auto,
- no_subdirectories restriction
with final =3D> pseudo_final
With flags :
F must_be_final
P must_be_pseudo_final
A/M 0 auto, 1 manual
I is_final
is_pseudo_final is always true,
and brings nothing without a precise subdirectories count

                                                          F   P  A/M    I
- must_be_final_manual,                   1   1  1        1
- must_be_final_auto,                        1   1  0        1
- must_be_pseudo_final_manual,     0   1  1        0 or 1
- must_be_pseudo_final_auto,          0   1  0        0 or 1
- no_subdirectories restriction           0   0  0        0 or 1
Already 8 combinations of flags have precise meaning.
The following combinations are invalid:
F P A I
1 1 1 0
1 1 0 0
1 0 1 1
1 0 1 0
1 0 0 1
1 0 0 0
0 0 1 1
0 0 1 0
And there are no other combinations left.

Have a nice day, best regards,
     Laurent Lyaudet
