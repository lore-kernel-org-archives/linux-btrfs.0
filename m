Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C01280A29
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2026 18:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771353206; cv=none; b=bsBsZ/j+N1CgeeRihua3Xs1M6W7BSfKA0ippmqZVU7G7fplihQt7N6rz6WncmnmPmciM5/w/DXrI3spgPhiQ76sd+/MjH+PckV70Jd+9EFL3VQB79Xb7PTmmMMvDO1QUg+w27i2HN0WhunSp3U1D6z/z4iHI0EIXTXbg/PNxZ80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771353206; c=relaxed/simple;
	bh=XKyqN9MWZX2BpAkU36kfV+zjdvidFFxsITnEtYLyIf4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eG7L8VR5PNukGqP88KQ1ruKqjxdeTKzmQGVkFWjC1jk2kMYGf446HQdlFvo84trCpl6J8yLaxCjKDe6mecgN7K8hj4R2uR4/6JXiDpn3iWeSc+OpSwogLEbLp9CN69GJ948q5BucQGRcKJ0smBBdiX0fqXbi3bOlav4psuejYxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dwUTk7RO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dwUTk7RO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382CDC19425
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2026 18:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771353206;
	bh=XKyqN9MWZX2BpAkU36kfV+zjdvidFFxsITnEtYLyIf4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dwUTk7ROobMn9c9Csk+BAoV7O8cpOmCAd7ARrxJZsdIexz9lJCojZHGXhBarP/NBb
	 +XBKslK+6wFe6ssa2ocxti7bajbHN0R42AigBHbtd0y0SIlvLP17qkKWnmYTV9dEsP
	 RUWhbRhf45ASp49k8gOabPYq6xrmfI7nib2GqwhyIWfi0rqOmUBYqkPd9xsXwPCJ9n
	 E9KmQFSOCZyM7pYLArMsOufoFCtwCmqpeSzYu02ZMzm/Wu6hyedR8Tww4Svsv/4PMc
	 mUh1hnzdVBmke50HTgYNiJu17r5TV8IQh4ryzz3rNKADvtqSACLZQvWh3wTerND1ji
	 TzICYggPPmQRw==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b8876d1a39bso505643366b.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2026 10:33:26 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCULzk1M8UzStMkAmKVbbJJqntzX3cs35yFDWoyd7QzNmUYZUPm+931XCVA3up6ynYFnDGO99sEZ1vWUgA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxDniG5uULT8ezHanecajhTno2MfydrfO6fO2JAY0LNsm8dzIZE
	E3dDlY7mCwYHfeXfSVa63bsy+k3ocJs8CjgjMFNxrZl4hXBQu6W3SQ9CRuH7BGAkHMcSgkGajs1
	OR5o1vZgmPFl9HqmCRlscTBPng3a+8RY=
X-Received: by 2002:a17:906:6a07:b0:b8e:5e2:79fc with SMTP id
 a640c23a62f3a-b8fc3a31688mr672545566b.14.1771353204752; Tue, 17 Feb 2026
 10:33:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <af8c15fa-4e41-4bb2-885c-0bc4e97532a6@gmail.com>
In-Reply-To: <af8c15fa-4e41-4bb2-885c-0bc4e97532a6@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 17 Feb 2026 18:32:47 +0000
X-Gmail-Original-Message-ID: <CAL3q7H50P0YVqj5w9hUpZwPYnih6W-ACvaT3_hGeO=KaqZV0Mg@mail.gmail.com>
X-Gm-Features: AZwV_Qi_AT4pv8KsT5PVwSjmA4uY79RXhwvdnOCzia_xfkiiqMxvrg6Kwo1u07E
Message-ID: <CAL3q7H50P0YVqj5w9hUpZwPYnih6W-ACvaT3_hGeO=KaqZV0Mg@mail.gmail.com>
Subject: Re: File size is not persisted after opening the file with O_TRUNC
 flag and creating hard link if system crashes
To: Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>
Cc: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 17, 2026 at 8:43=E2=80=AFAM Vyacheslav Kovalevsky
<slava.kovalevskiy.2014@gmail.com> wrote:
>
> Detailed description
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Hello, there seems to be an issue with btrfs crash behavior:
>
> 1. Create an empty file in a directory.
> 2. Fill file with data (e.g. truncate) and sync the file.

By the way, truncate doesn't fill any data, it just increases i_size
and leaves a hole in the file.

> 3. Open file with O_TRUNC flag (should set size to 0) and sync the file.

A truncate to 0 achieves the same, O_TRUNC is not necessary.
The issue only happens if we truncate to 0, to any other size it works fine=
.

Fixed here:

https://lore.kernel.org/linux-btrfs/cover.1771350720.git.fdmanana@suse.com/

Thanks.


> 4. Create a new hard link to the file in the same directory.
> 5. Sync the directory.
>
> After system crash the file will have the old size (>0) even though the
> file was synced after truncating (O_TRUNC).
>
>
> System info
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Linux version 6.19.2
>
>
> How to reproduce
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> ```
> #include <errno.h>
> #include <fcntl.h>
> #include <stdio.h>
> #include <string.h>
> #include <sys/stat.h>
> #include <sys/types.h>
> #include <unistd.h>
>
> int main() {
>    int status;
>    int file_fd;
>    int dir_fd;
>
>    status =3D creat("file1", S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
>    printf("CREAT: %d\n", status);
>
>    status =3D truncate("file1", 1000);
>    printf("TRUNCATE: %d\n", status);
>
>    sync();
>
>    status =3D open("file1", O_RDWR | O_TRUNC);
>    printf("OPEN: %d\n", status);
>    file_fd =3D status;
>
>    status =3D fsync(file_fd);
>    printf("FSYNC: %d\n", status);
>
>    status =3D open(".", O_RDONLY | O_DIRECTORY);
>    printf("OPEN: %d\n", status);
>    dir_fd =3D status;
>
>    status =3D link("file1", "file2");
>    printf("LINK: %d\n", status);
>
>    status =3D fsync(dir_fd);
>    printf("FSYNC: %d\n", status);
> }
> // file size is 1000 instead of 0
> ```
>
> Steps:
>
> 1. Create and mount new btrfs file system in default configuration.
> 2. Change directory to root of the file system and run the compiled test.
> 3. Cause hard system crash (e.g. QEMU `system_reset` command).
> 4. Remount file system after crash.
> 5. Observe that file size is 1000 instead of 0.
>
