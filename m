Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793715990;
	b=LKbPIEzYV15+A9/ZxHL7oTftX9ywSmCvd+0H9mdT5joYElue0d5NvRLoGJqOnqJAKPz7
	 CvSucVbM2z8GTC3/Tpm9+1nTa1Qy+rZyt4o3Sx1s9t0XRz8GV1l6Q9qCfoTx+HldGylZY
	 TclK/l5mS+wIHz+gVh8fxhWt+cK0XtHrCDPXByCOAp9lgFS36eOdcnDcqkAbxVQE3tUF9
	 3mbh2a+sZXBiWG6ndiczxW4riw7dnfkAblZf8x9lm3F5eNHx5p9FFB1/FMEkSMmFc9YHQ
	 32XqG+ALF/x3wwi41AZ4NDKsXbBaanbAqMLiod9dCB8D8ZPRtjjZ+l9UFPYcLeHFQ9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793715990;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=D5G/50omSp7/mD5rb6s++o7dUChrUTFtIax9i7Ivc7o=;
	b=4n6m+35tHDffTeEJo46lFpgLYb0DpD2XL4Xudbd845bLpoDN225yJUwpHO4SeeXxuGmj
	 jT8yrxpgvwKEymIWsnsJM/GeVnHn8we2vJ2z1xHS/+xto0+g6U8a8MAImIWl4/AFdM8Vp
	 qFoXyEFxMgKnqlyeSRkxFaQTwY/LqbIP80DM8b+VYIvrmYWf5tcQgJpkyukGukilPoqfb
	 8/ULvROnFi7lYU2eQL3jx/O6dRdhCVC4xZ+Pddwf+2a3zRYoK45RJiqmLiI3HRL7tCX6O
	 2/4ZmguYHjZ+YRSlv8LUOjxFm4z05i+N9QMXAUcxdEbEzJWYjCAnHzh3yFv2SvvqV/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Ph2xKPM/";
	arc=none smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7134606A326
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 14:26:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7134606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ph2xKPM/
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b1aa2848d2so5957108a12.3
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 06:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793715988; x=1794320788; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=D5G/50omSp7/mD5rb6s++o7dUChrUTFtIax9i7Ivc7o=;
        b=Ph2xKPM/z1tb6mVgwX/njtTiWXH5JOPuHCXd5djRJeWfn7NRNWwm++jZYTP8Vhbtn9
         ElzJPGZ8RAQrw3X3Ngi5H4k9jsNEP7nRbcHkqFJPwNzHcp3Z8+H5Q63zg4ZgvjOxDGcU
         1NwN5rGo5opsvCb+LjOuE+E1PkjLkNlLO2cqOVyt/G/p41ClphGORoaXffTj/8RWYI47
         asg0sYAwXPfguSxrddXuJ0/p3uwwz5sqmO1Tz3lztZx4nJxRMUS3cBQiIgtJfbbWOLvd
         XZ+NskXJi+Tnfq2qftzUUxToxYD3s/PLaG2+rNgglPAvIg4Df4HZS5jgU8R2rEE8qZRi
         oNoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793715988; x=1794320788;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=D5G/50omSp7/mD5rb6s++o7dUChrUTFtIax9i7Ivc7o=;
        b=xZ+1IbtT4S2M9Pw4hYxSpHR6+FClrcQUG6Kf1oMrxbhsN2tegc+tJucEfNDv8y/DA4
         5U8nmCwjLx/+vCziQQtcme21nUPnLVDFq6c8ucUURV5RWU5YtaPA9Aye5OqurZCSMDyi
         MpJHmB++K/Evfo9kJjf/7Q57H2XW2ghmg0pK5TA3GsxntaPt6bAgHvYfjzRXCpFX0kbP
         V0QjzCqzR1MO+pWP02p786C6IcOgcqOUL30GsMa3j0gorbvMCV0GzstBubC7RDrVS7oq
         qQb2FQ5i545lbLNgZDdIxv8y8c4DAuakwrnF36Crs1ZQ68Vl/lawN/zVecQcOK+shJ1H
         g8Yg==
X-Forwarded-Encrypted: i=1; AKwUvBwMCvcxf9k9w5L2WgP5pyeJY4+HdClJTHZVWI/8MaAnWHjKT5TPSgxyCTP1UGNjk8eajZOObPwclFwUXg==@vger.kernel.org
X-Gm-Message-State: APuU4Z+X6cGm2/S1pL3z4i+uHgvNb2pIcSYKckJAXoW6xVlL21EPtjDV
	Km9LKqzy2JmvX8Ted9A18DRAzygXsxPV9PmOJxcVvtX6nTjlrJYumj/l
X-Gm-Gg: AYBFou3jdmf5+rtrFI28sSfUHJa7l4jFL74n8Eu1y410canwgB8DZxJi6fhklZaAZ53
	jkLmShb2q4YQ6X+cxVbmbrIgwjXeAvbAFeEFmLPcdmOqPFdQ3YisOjiG9aH0qhC6KhX0fHomR9s
	3Cofagsha9mmKm9cQS9SjtflTpKxEkfke4Bw91Qwr9t6zvoA9KPVBAUPCeWM7ysenj/OYQLlH8f
	j/Jf+0/hJgeLgihw7YBnd72PmBhvuwEby7a0yiVPjnP9fIv8U5eIJcKN6jLaWJ2bXlW1WOcmuC7
	KNQbqSoFDjloCNgG60hsuKo48Uy8LcHNZQtD/00qB/rsNa2ZTftRrf9Yu9VmpZUHvBdSmTMDZw/
	a8/Mk44hBh56NotiswChUnV7HWPSF7mTG8TPNf7C9JBW0PatXM/p9hb0U2LbLCZpKTbKxNVpcZk
	yMuMloua421hAWbSTwr2xZ2KFmEiD5UTw2s6sCxY2sNsjU+kfIr6eq7+2yDtRUtESqMaDPEweUk
	1LkmktkzSKz46p7Bh3zPwB5JXh/8svZgY9HKiuztTqlCt691+v6zm8nRjgZF1BJB4HXgIMxRPUw
	e0/kkMro/WqebLdUQfl4/KHpkPNyuWV0FYkAUu7gSoDJ2qhS
X-Received: by 2002:a17:907:9603:b0:c31:8cfe:9a25 with SMTP id a640c23a62f3a-c4ca7a4d9bfmr1116631466b.9.1793715987705;
        Tue, 03 Nov 2026 06:26:27 -0800 (PST)
Received: from localhost ([130.192.98.149])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4cebf23b14sm91818366b.46.2026.11.03.06.26.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 06:26:26 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=6b6df4b89e0b7551c81df0d1e7117343e0b90d772256c55912bbdd7e2ef0;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Tue, 03 Nov 2026 15:26:20 +0100
Message-Id: <DMLN8XHASPL4.1R3MI7CMA5KCD@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>, "Chris
 Mason" <mason@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, "Sean
 Smith" <defendthedisabled@gmail.com>, "Andrey Albershteyn"
 <aalbersh@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] add provenance time (ptime)
From: "koraynilay" <koray.fra@gmail.com>
To: "Jan Kara" <jack@suse.cz>, "koraynilay" <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261027220532.736352-1-koray.fra@gmail.com>
 <upe7qvhod63zd724s7uiql6kanqyrcwplodoavcvqjt35vd4ee@s3iglizxejlr>
In-Reply-To: <upe7qvhod63zd724s7uiql6kanqyrcwplodoavcvqjt35vd4ee@s3iglizxejlr>

--6b6df4b89e0b7551c81df0d1e7117343e0b90d772256c55912bbdd7e2ef0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Tue Nov 3, 2026 at 2:25 PM CET, Jan Kara wrote:
> On Tue 27-10-26 23:05:30, koraynilay wrote:
>> This is an initial implementation of a new timestamp to indicate the
>> time when a file/directory was initially created.
>>=20
>> This patch series takes inspiration from the one by Sean Smith
>> <defendthedisabled@gmail.com> [1], but using
>> file_setattr()/file_getattr() as suggested by Darrick J. Wong
>> <djwong@kernel.org> in [2].
>>=20
>> The semantics of this new timestamp should be at least these:
>> - it should be the same as btime on a newly created file
>> - it's user-settable, so it can be preserved for backups, filesystem
>>   conversions, archives and any similar operation
>> - it should be preserved every time mtime gets preserved
>>=20
>> and the correspondence with the other timestamps is as follows:
>>=20
>> ctime <-> btime
>> mtime <-> ptime
>
> One thing I miss in this series is an explanation what this new timestamp=
 is
> good for. Because frankly, I don't miss such timestamp as a Linux user :)=
.
>
> 								Honza

Hello, my concrete use-cases are backups and filesystem conversions.

For backups, my setup is btrfs and using btrbk (so btrfs send to my nas
with ssh) and the only missing thing from the backup is the timestamp of
file creation (which I'm currently working around using xattrs).

The situation that prompted me to finally start working on this RFC
PATCH was when I wanted to merge 2 btrfs FSs and the only way of doing
that (AFAIK at least) is using cp/rsync, which can't set the creation
time since btime is immutable. The workaround I used was the same as
with backups, so with xattrs, but noticed that some files (symlinks)
wouldn't accept xattrs, so I looked into it and found out xattrs are
only for regular files/dirs.

(also see https://lore.kernel.org/DMGS4KQLY24Q.14MUTR6U93GIC@gmail.com/)

>
>>=20
>> Examples:
>> 1) a .zsh_history file created in 2019, then after a few years the user
>>    decides to switch to another filesystem, copying the .zsh_history to
>>    the new home, in that case btime would have the timestamp of the copy
>>    and ptime would have the 2019 timestamp (just like mtime would have
>>    been preserved)
>> 2) a symlink created in 2020 from the home directory to a /path going
>>    through the same process as the .zsh_history, in this case it would
>>    also make sense to sync the ptime to the 2020 timestamp instead of
>>    keeping only the btime (so the inode creation time).

And as in these examples, keeping the original creation time for
everything is valuable to some users (like me) and allows for a true 1:1
clone of files between filesystems without losing any metadata (I can't
think of any other file metadata (not permissions) other than the
creation time that is still missing).

As for non-concrete use-cases, adding this timestamp would be good for
completeness IMO, since the creation time of file data is not a thing
on linux yet (but is on windows and mac).

Thanks,
koraynilay

>> The proof-of-concept code (for testing) for stat(1) and cp(1) is
>> available at https://github.com/koraynilay/coreutils (master branch)
>> (Note: these coreutils code changes are a prototype and won't be
>> submitted upstream as-is, but they work as expected in simple stat and
>> cp -a/--preserve=3Dptime tests)
>>=20
>> Lastly, the name "provenance" and "ptime" are not final, I personally
>> don't have a strong opinion on any name, but while testing with stat(1)
>> I noticed that "Provenance" is definitely too long for the normal
>> output, so another option which would fit well is "Origin time",
>> abbreviated as "ntime" (OrigiN time) and not as "otime", as that would
>> conflict with btrfs' internal naming and create confusion.
>>=20
>> Thanks.
>>=20
>> [1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisabled@gma=
il.com
>> [2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs
>>=20
>> koraynilay (2):
>>   vfs: add provenance time (ptime)
>>   btrfs: add provenance time (ptime)
>>=20
>>  fs/btrfs/btrfs_inode.h          |  4 ++++
>>  fs/btrfs/delayed-inode.c        |  6 ++++++
>>  fs/btrfs/inode.c                | 17 ++++++++++++++++-
>>  fs/btrfs/ioctl.c                | 12 +++++++++++-
>>  fs/btrfs/print-tree.c           |  1 +
>>  fs/btrfs/tree-log.c             |  3 +++
>>  fs/file_attr.c                  | 24 ++++++++++++++++++++++--
>>  fs/stat.c                       |  2 ++
>>  include/linux/fileattr.h        | 27 ++++++++++++++++++++++++---
>>  include/linux/stat.h            |  1 +
>>  include/uapi/linux/btrfs_tree.h |  3 ++-
>>  include/uapi/linux/fs.h         |  8 +++++++-
>>  include/uapi/linux/stat.h       |  7 ++++++-
>>  13 files changed, 105 insertions(+), 10 deletions(-)
>>=20
>>=20
>> base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7
>> --=20
>> 2.56.0
>>=20



--6b6df4b89e0b7551c81df0d1e7117343e0b90d772256c55912bbdd7e2ef0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCaunvDAAKCRA0bnTtJTDo
OF3AAQCOfJdJ0dhQbojHXJ+5f2/akSjeaKCJ9aEjflKllnVGRQEAvkNLsD/jetRa
qjn20bf16T6gEG4qRWaXCb0/KnTJ/gM=
=bu8I
-----END PGP SIGNATURE-----

--6b6df4b89e0b7551c81df0d1e7117343e0b90d772256c55912bbdd7e2ef0--
