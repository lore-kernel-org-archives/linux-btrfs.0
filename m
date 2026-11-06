Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793988687;
	b=BeutdPyI1DdBAAsiNkBdMMg6yubEQY4qQswQYd5FipY64tBIxeNnnJrbHatqvYmaeRqY
	 who1MchMmfSG4JCSTLmdBGOe5nZWJ3Mnt0rK6VFypnu8kuzuyckGXcsb/wxRZULqncxSW
	 BtDxZEZosBLEQCLHqb41t3QMl3b5Fb5rRjich2EXVUJkDlYBrfKavZeekL/eDRK73vRLN
	 X3KBG4y4vn2751zPG40KTTEZy7P1tZfYdyADGsdVcpeaVfnXqxUPKMR1rsmsuc0jJTItM
	 yitAd4yyfQ8Te2psls6IO+b6WgjU+yxb8/meCceny52n1y5vqOjrAvtaLWWvSz2Ejew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793988687;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=bbKFktL6hLkse7DadYzw/IhnhxnyJ6+K89PpHztRZ40=;
	b=VuKLHBWkVqmkUBhMpbMhhMYqCYrYt/smgNyNxLvqSpjkgTqFkA2qKxScdSP0s9K3TL8z
	 vniyFeP8VQY1LCQVc1KeVDc6Bft0EWFH42u2ECs2hiEx+oQayiRc0BhFgYh4cw55KhnnT
	 fSf3s1L+W7mSUl0zQGi0QhT/Ud6+mKvWMz5y8OrRKe/a89vF0eI0NB8TU6557tjlsmfAp
	 erAQxgnWtHvE8Npi0cDLwdBoTmFQR3vUPMgNAEUP5w+smoAJ5wWI/rC7aopyCQAwCJ2JV
	 Lh5cJsFbIL76UKqqdhOoxlUlYyvxOST/WmkAM8oOTJt2sm58RJElqf8ulvrnS7VXgoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i89stuKR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC03606A326
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 18:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i89stuKR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D4B1F0089F
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 18:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793988686;
	bh=bbKFktL6hLkse7DadYzw/IhnhxnyJ6+K89PpHztRZ40=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=i89stuKRljUC8HbXjB21uvtGPg+BP8KnERY92HT5bxETrajdgNUrppdX7STNosDlz
	 r6HzEsdN7TPRZ+IOZh/h4/DmSn2Io/r58cik5Xnhb0zcWjz49nR5HGI16HLzQMKa7U
	 4Re1vd+rhf6X+tprcT5rLwqbIZC4Ymz8GIDLfJqIG3ZU8t/m/TLEdqVuvuBuNwctBV
	 t4xUCLSsTu38qr2sETTaLfzkToqfBKVQqETzT3IPg0CCuBFaoH6sQCUfYKghmT0Hr5
	 JG8l1UicmjPWVkM9iTK2hXa5Z7a+/9gCCGPeT8sbEjO2hFZI5OP7UNVfDS9ilTnoi7
	 5V9HOnGz2QnOw==
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-7d27bbe9900so284234137.2
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Nov 2026 10:11:26 -0800 (PST)
X-Gm-Message-State: APuU4Z/Av7ppMWDeBfqfnpWn6uVfAsxQnPly9bgjG9u/O0RwZtD3B7kA
	JujEqMzGmRsIhpwHqtO1ryWmijO0YIT8hd7YGOQ8IKLKRQBAZoTZz+aIokVWvzFq3jtAH5NzyY8
	LXfZfOkAjV19xxSbkWNxd3WOTRgqiSvs=
X-Received: by 2002:a05:6102:e0e:b0:7c1:75c5:c4c with SMTP id
 ada2fe7eead31-7d2a1625e7bmr1816110137.25.1793988686141; Fri, 06 Nov 2026
 10:11:26 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <18e431317f832f21-26f56778@a-workstation>
In-Reply-To: <18e431317f832f21-26f56778@a-workstation>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 6 Nov 2026 18:10:49 +0000
X-Gmail-Original-Message-ID: <CAL3q7H7ZdWut0qH6jDrmzUSEzMWZcZ=M8tqwvJhPVA17tN637w@mail.gmail.com>
X-Gm-Features: AclHuK-SzzxeJMFhRVZ3E_4bfxPzes4nH9IEWPvRTP2nujpg_6WhjsH7AXCtweU
Message-ID: <CAL3q7H7ZdWut0qH6jDrmzUSEzMWZcZ=M8tqwvJhPVA17tN637w@mail.gmail.com>
Subject: Re: deleted subvolume isn't cleaned while an inotify watch is on its root
To: linuxkernel+co@alexs.space
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 5:20=E2=80=AFPM <linuxkernel+co@alexs.space> wrote:
>
> Hi,
>
> A subvolume deleted while something has an inotify watch on its root dire=
ctory stays in "btrfs subvolume list -d" until the watch is removed. The wa=
tch never gets IN_DELETE_SELF or IN_IGNORED, so the watcher has no reason t=
o drop it. Same with rmdir of an empty subvolume. I hit this with syncthing=
, which had watches on a few subvolumes inside a synced folder; they were o=
nly cleaned once syncthing let go.
>
> To reproduce:
>
>     truncate -s 512M /var/tmp/btrfs.img
>     mkfs.btrfs -q /var/tmp/btrfs.img
>     mkdir /var/tmp/t
>     mount -o loop /var/tmp/btrfs.img /var/tmp/t
>     btrfs subvolume create /var/tmp/t/sv
>     inotifywait -m /var/tmp/t/sv &
>     sleep 1
>     btrfs subvolume delete /var/tmp/t/sv
>     sleep 30; btrfs filesystem sync /var/tmp/t
>     btrfs subvolume list -d /var/tmp/t
>     kill %1
>     sleep 5; btrfs filesystem sync /var/tmp/t
>     btrfs subvolume list -d /var/tmp/t
>
> Output on 7.3.0 (CachyOS build):
>
>     Create subvolume '/var/tmp/t/sv'
>     Setting up watches.
>     Watches established.
>     /var/tmp/t/sv/ OPEN,ISDIR
>     /var/tmp/t/sv/ CLOSE_NOWRITE,CLOSE,ISDIR
>     Delete subvolume 256 (no-commit): '/var/tmp/t/sv'
>     ID 256 gen 9 top level 0 path DELETED
>
> The first "list -d" is 30 seconds after the delete; the second, after kil=
ling inotifywait, prints nothing. Without the inotifywait the subvolume is =
cleaned right away.
>
> It looks like btrfs_delete_subvolume() leaves i_nlink of the root inode a=
t 1, so dentry_unlink_inode() never calls fsnotify_inoderemove(), and the m=
ark keeps the inode, and with it the dead root, alive. kernfs had the same =
problem and fixed it in 7.1 by clearing i_nlink on removal (eea5d2bb34ba).

Thanks for the report.

Fix sent here:

https://lore.kernel.org/linux-btrfs/de103b6af03cec8d98b21e0734fb482f9244bed=
6.1793988522.git.fdmanana@suse.com/


>
> Thanks,
> Alex
>
>
