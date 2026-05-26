Received: from mail-yx1-f67.google.com (mail-yx1-f67.google.com [74.125.224.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B4A2E1722
	for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2026 02:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779763222; cv=pass; b=rG8v4+q5myovk+0xTcCaN/ugXwBOQFMnisVFyvJb2h7lzYrhsCE/8GntyuOCaijAb4s/KnpPuuVrgkF9X1uy8RZwH3H7RuiVi2qa8FS9XR42W90jKqhhsa7WWQpq8mzERL+IM73mHOvs7omBm4YIFGOilPsUQtGQcefpaqIvpH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779763222; c=relaxed/simple;
	bh=adz3DJqPc2CnVVhE9MeI4o30Y3bDFg4y/kAkW6stXGc=;
	h=In-Reply-To:References:MIME-Version:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FL37rO/yVXBQ/mWCSIbJXhrkiM3Iyq2rLr5wcfEhtYA8TJma0CuYs0xEaPeYauv81TFvUaJ1+yr3nav26jsgHmSiWg2jgJ8azLVJeNsNOWdSdNACPq0SU2JGRqTwqjUXmoH/jgjIYCOK9LsF/LmxG2PkaCTRLFCZZRIg9QBs3fs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dd9aqbct; arc=pass smtp.client-ip=74.125.224.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dd9aqbct"
Received: by mail-yx1-f67.google.com with SMTP id 956f58d0204a3-65c24be9e4bso10363125d50.1
        for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 19:40:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779763219; cv=none;
        d=google.com; s=arc-20240605;
        b=DOZxkI/2wBaY6dWZI1aVkTAzS2sGfGvxGDKacrpzWVnbhR9aIsDGao9UIfFld2TqfM
         3dskqst7HDgqf9ztOidHm0CRXAKKhNxVp+KxR1BYH9OdE7EgaLWo/J5mhLI3irymQ+w4
         RrqkFbS7Zqt3IrinjLYdf5fZIobVqeVWL2LhB+G1DzfZ9519rWZFwnCXch4/W87LbFLF
         Mi/sDqCkQqJRckgmLC0U6P5H5254EiZrUIYJWEIw3U8xVmXEXD3r6nNXEN1Z9Ri7hdnI
         /NVAxBQFAFWI3koJ5XlIyrLrAsCy8+9UBJKxkDxXdtbw1saYclEpDrMLwCE1K/lIgY2Q
         lIPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:dkim-signature;
        bh=kr4Vnh6UW3RbCflcNy1iRdqvq0ppc91YdQ51UAqCCbM=;
        fh=/rkdjfWvtraxZxdg34CKtK2xcWF8sbimko12+MBLh/c=;
        b=RClZ6TFLeGr1i/7J7YpBxTa4/ZJzMhL9wrmJLGsCSnm+c78U57d2QCWvtgoaDuSJ4S
         1lSsRLfHpocdHqA4/9pT2nhLNnmBowciUGZAlwPs0xAybDk2nkmWXUa9IoJxUdSir6eQ
         llKv2cyhQZi9dHL0MaI8z2+wW7RMDpXH6127g4nHN4iQANYe5jg6xhTshcrrbfHeR8xl
         Icy3rPmgXKtqvMyKI8ntuykx0ne4eIzHfgFQKSo+CXYajQkaqNvi1ud+Y+fC/KN7QZ2W
         Qcp+ohcXq4wzzM7LFn5tqLQCZEi9sSsjahqnjTPchkkghTt382xSw9MiyVkyixgaqCyi
         4Rrw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779763219; x=1780368019; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kr4Vnh6UW3RbCflcNy1iRdqvq0ppc91YdQ51UAqCCbM=;
        b=dd9aqbctlaYdf35HNq/IkTWhCLsg8w1u02YPMGsA12Y/Vj81/8lODp0bShm7F+gQ8c
         gqD2m+tnTMz0nvq+KkHCf0VT1zdG1GuwvS0H9aYRMSeU94ZOaAXQWRQJLkh25tuDv6PG
         8LrsECIUz1+TICZ+IaZVKIV4jZYPrXAgxeWfg/kM7GHE43CKuVOp2fozjRLB3Y9zdWfk
         /vW1MiI9eNn0teNBnaIMxBttn+tP1pwhGoF+5/gMOV4I4COekUjVdEzehxcdn17sxcYB
         DFv+Z1mOJv5E/98Xj3Dh6Lf5cvJOd5X/9WMit5qATKKMCOUYAHDKzqjYmukV3tshC8H4
         HHMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779763219; x=1780368019;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kr4Vnh6UW3RbCflcNy1iRdqvq0ppc91YdQ51UAqCCbM=;
        b=Nk9d8o5c64YSYpz4u/xD6IYQOdJOpZJtwn0ciTGEfIBAQ7GSBS5+r8GPT6vzv05wxB
         s8C9k6tdGbUap7D+AcHpk36mWMaUbI/8/U0Q2J7IXt007Sqm2h5KiTiy0M6E+A+ZhgLw
         3nCnidvh8WtPRcXj6y6ANLlI1HLykTXOy9YDSexlMZoOM0P4rTmVMRg34sxhwd0vVbPd
         zWTUmeQycAfM5OfjBmHM27GAnzhHPrRZmEUMKU6h23Ao0dnodWYrJcvfw/3gQpw+nfX0
         myHd+26MAPAS1TBQGhJOkr6GxrY8w1vG4JP5FurYSTT2p3YwMnF7zslFaZi87NjNnN3d
         KLDA==
X-Forwarded-Encrypted: i=1; AFNElJ/2RVHz6bfK/DhffaqQfOTJ0QrBLJoGVj3cxovH6JTgyri2YRHkmeRCJFweIgndw3uudaR+FAkdCnUIWQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4DgLf7GvZEUNWqZfnCAPXwSPP73hl8wSX6JQN/TL1VnT8Qx3G
	hSFXB/YEzAmebEQd8jt/CYXefWOYTpn18TO9nYKpG1zZc8NoyUtNwFPr5BQb9LdadvzUWiFDJei
	L3wLivYnf/sqpcjzgTzl3hy+mbReq4Wo=
X-Gm-Gg: Acq92OHbGfjD78H6TTdiJIu6MNHa8EcnyLoeT9wpm7Tv4UIBGjDZ3IeUXadKJH3e+Lm
	l9XrUMgbsg3XJBLcQx1siY/Wj5sINL09lpjcg9M7pNxzow635pwx+bIRBWWHIGSKlsb3HoM82I0
	Lv8ckKaFjOo7qS5yMblFgpKEf25qXdAe4hAGae8HyXu9RaD0pFDK2gnhMJUghItDLIonx5GXYkv
	8yiB9J39AyjiXx+y6z12a2DDfm2tK0+94cxM2YLiDUMXlY+pQnmFxX9f+dZh2eIRaIjlutwqkHV
	32eXhcat
X-Received: by 2002:a53:acce:0:10b0:65e:49e8:3425 with SMTP id
 956f58d0204a3-65ec99dd22emr13014057d50.64.1779763219360; Mon, 25 May 2026
 19:40:19 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Mon, 25 May 2026 19:40:17 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Mon, 25 May 2026 22:36:33 -0400
In-Reply-To: <12c0106a-c626-444d-a403-51d83808a30b@gmx.com>
References: <CAPJnbgKVuBQCLSTgYUO1kir1ibBp_=ap==OoE6xbikBjn_S_3Q@mail.gmail.com>
 <12c0106a-c626-444d-a403-51d83808a30b@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Yifei Chu <yifeichu24@gmail.com>
Date: Mon, 25 May 2026 19:40:17 -0700
X-Gm-Features: AVHnY4KkuzRIB3rODP8erGYNcYdn_iT7RLnXbKzkkts0oTFtZFIsSFKPVAi7Nxo
Message-ID: <CAPJnbgLjkrgua8TgjV+v3OE5WQWsM-eb7bC-bWNRsSgdnwcRGg@mail.gmail.com>
Subject: Re: [BUG] btrfs: dev-replace finishing commit error reaches WARN_ON
 and panic_on_warn
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000079b9960652af6a75"

--00000000000079b9960652af6a75
Content-Type: multipart/alternative; boundary="00000000000079b9950652af6a73"

--00000000000079b9950652af6a73
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Qu,

You are right to call this out. Sorry about that =E2=80=93 if the archive y=
ou
received only contained a hidden ._... AppleDouble file, then the
attachment was clearly not useful and looked suspicious.

I checked the file I had locally before sending. On my side, the original
tarball does expand to the files I described in the report: README.md,
repro_init.c, positive_instrumentation.diff, and the two serial logs plus
qemu/result files. So I suspect I managed to trip over a macOS
AppleDouble/attachment handling issue somewhere while preparing or sending
it, and you ended up seeing the metadata sidecar instead of the real
contents.

For reference, the local original tarball I checked is:

btrfs_dev_replace_finishing_commit_warn_panic_20260523.tar.gz
size: 29856 bytes
sha256: 61948cdd4a3ec0ca08b0e25fcec99b3d128558f6d986519029fc36a169d7e1f1

tar -tzf on that local file shows:

btrfs_dev_replace_finishing_commit_warn_panic_20260523/
btrfs_dev_replace_finishing_commit_warn_panic_20260523/README.md
btrfs_dev_replace_finishing_commit_warn_panic_20260523/repro_init.c
btrfs_dev_replace_finishing_commit_warn_panic_20260523/positive_instrumenta=
tion.diff
btrfs_dev_replace_finishing_commit_warn_panic_20260523/logs/
btrfs_dev_replace_finishing_commit_warn_panic_20260523/logs/positive_run1.q=
emu-args.txt
btrfs_dev_replace_finishing_commit_warn_panic_20260523/logs/positive_run1.r=
esult.txt
btrfs_dev_replace_finishing_commit_warn_panic_20260523/logs/positive_run1.s=
erial.log
btrfs_dev_replace_finishing_commit_warn_panic_20260523/logs/positive_run2.q=
emu-args.txt
btrfs_dev_replace_finishing_commit_warn_panic_20260523/logs/positive_run2.r=
esult.txt
btrfs_dev_replace_finishing_commit_warn_panic_20260523/logs/positive_run2.s=
erial.log

I have attached a freshly repacked archive here. I created it with macOS
copyfile metadata disabled and tar xattrs excluded, and checked that there
are no ._* or __MACOSX entries in it.

btrfs_dev_replace_finishing_commit_warn_panic_20260523.clean.tar.gz
size: 28744 bytes
sha256: 30ab240e6a090a0013d444ad1a6f7b27e0a33ea5ae38022a34835352dc205b36

Again, sorry for the noise and for making you spend time on a broken
attachment. If this one still does not come through cleanly, I will stop
using an attachment and send the small reproducer/patch inline instead.

Thanks,
Chuyifei

On Mon, 25 May 2026 07:47:52 +0930, Qu Wenruo quwenruo.btrfs@gmx.com wrote:

=E5=9C=A8 2026/5/25 00:45, Yifei Chu =E5=86=99=E9=81=93:

Hello,

Short version: I am reporting a second Btrfs dev-replace error-path bug
found with targeted fault injection, this time in the finishing path.
The injected -EIO is in btrfs_commit_transaction()=E2=80=99s normal error-r=
eturn
domain, and the injection is placed at the transaction-commit return
boundary. With that rare commit failure made deterministic,
btrfs_dev_replace_finishing() reaches WARN_ON(ret); with panic_on_warn=3D1
this panics the kernel.

Tested kernel:

v7.1-rc4-640-g79bd2dded182-dirty
commit base 79bd2dded182b1d458b18e62684b7f82ffc682e5
x86_64 QEMU, KASAN config

Reproducer shape:

The initramfs source mounts a single-device Btrfs image on /dev/vda and
starts device replace from source devid 1 to an empty target device /
dev/vdb. The validation patch forces the commit in
btrfs_dev_replace_finishing() to return -EIO.

The point of the injection is not arbitrary state corruption. It makes a
valid transaction-commit error deterministic at this caller, so the
finishing path=E2=80=99s error handling can be tested.

I reproduced this twice under targeted fault injection. The signature is:

BTRFS info (device vda): dev_replace from /dev/vda (devid 1) to /dev/vdb
started
BTRFS error (device vda): AGENT_BTRFS_DEV_REPLACE_FINISH: forcing finish
commit EIO
WARNING: fs/btrfs/dev-replace.c:912 at
btrfs_dev_replace_finishing+0x295/0x13a0
RIP: 0010:btrfs_dev_replace_finishing+0x295/0x13a0
Kernel panic - not syncing: kernel: panic_on_warn set =E2=80=A6

This looks related in theme to the dev-replace start-path error
handling, but it is a separate callsite and a different state surface:
the commit happens after scrub returns and before mapping-tree/device-
list updates. I did not find a direct current-upstream fix for this
finishing-phase WARN_ON(ret) site in my local duplicate sweep.

Expected behavior:

The commit error should be propagated and the replace state should be
left consistent, rather than treating the error as a warning-only
invariant. A real fix likely needs to audit target/source device
lifetime and replace state around this finishing path.

The attached tarball includes README.md, repro_init.c,
positive_instrumentation.diff, QEMU args/results, and both full serial logs=
.

Your attachment looks very malicious.

Firstly the tar.gz is way larger than the only file inside the tar.gz.

Secondly the only file inside that archive is a hidden file, named
=E2=80=9C._btrfs_dev_replace_finishing_commit_warn_panic_20260523=E2=80=9D.

The file is hidden is already suspicious, and =E2=80=9Cfile=E2=80=9D tells =
me it=E2=80=99s a
=E2=80=9CAppleDouble encoded Macintosh file=E2=80=9D.

Nothing matches your description.

You have a lot of things to explain.

Thanks,
Chuyifei

--00000000000079b9950652af6a73
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<p>Hi Qu,</p>
<p>You are right to call this out. Sorry about that =E2=80=93 if the archiv=
e you received only contained a hidden <code>._...</code> AppleDouble file,=
 then the attachment was clearly not useful and looked suspicious.</p>
<p>I checked the file I had locally before sending. On my side, the origina=
l tarball does expand to the files I described in the report: README.md, re=
pro_init.c, positive_instrumentation.diff, and the two serial logs plus qem=
u/result files. So I suspect I managed to trip over a macOS AppleDouble/att=
achment handling issue somewhere while preparing or sending it, and you end=
ed up seeing the metadata sidecar instead of the real contents.</p>
<p>For reference, the local original tarball I checked is:</p>
<p>btrfs_dev_replace_finishing_commit_warn_panic_20260523.tar.gz<br>
  size: 29856 bytes<br>
  sha256: 61948cdd4a3ec0ca08b0e25fcec99b3d128558f6d986519029fc36a169d7e1f1<=
/p>
<p><code>tar -tzf</code> on that local file shows:</p>
<p>btrfs_dev_replace_finishing_commit_warn_panic_20260523/<br>
  btrfs_dev_replace_finishing_commit_warn_panic_20260523/README.md<br>
  btrfs_dev_replace_finishing_commit_warn_panic_20260523/repro_init.c<br>
  btrfs_dev_replace_finishing_commit_warn_panic_20260523/positive_instrumen=
tation.diff<br>
  btrfs_dev_replace_finishing_commit_warn_panic_20260523/logs/<br>
  btrfs_dev_replace_finishing_commit_warn_panic_20260523/logs/positive_run1=
.qemu-args.txt<br>
  btrfs_dev_replace_finishing_commit_warn_panic_20260523/logs/positive_run1=
.result.txt<br>
  btrfs_dev_replace_finishing_commit_warn_panic_20260523/logs/positive_run1=
.serial.log<br>
  btrfs_dev_replace_finishing_commit_warn_panic_20260523/logs/positive_run2=
.qemu-args.txt<br>
  btrfs_dev_replace_finishing_commit_warn_panic_20260523/logs/positive_run2=
.result.txt<br>
  btrfs_dev_replace_finishing_commit_warn_panic_20260523/logs/positive_run2=
.serial.log</p>
<p>I have attached a freshly repacked archive here. I created it with macOS=
 copyfile metadata disabled and tar xattrs excluded, and checked that there=
 are no <code>._*</code> or <code>__MACOSX</code> entries in it.</p>
<p>btrfs_dev_replace_finishing_commit_warn_panic_20260523.clean.tar.gz<br>
  size: 28744 bytes<br>
  sha256: 30ab240e6a090a0013d444ad1a6f7b27e0a33ea5ae38022a34835352dc205b36<=
/p>
<p>Again, sorry for the noise and for making you spend time on a broken att=
achment. If this one still does not come through cleanly, I will stop using=
 an attachment and send the small reproducer/patch inline instead.</p>
<p>Thanks,<br>
Chuyifei</p>
<p>On Mon, 25 May 2026 07:47:52 +0930, Qu Wenruo <a href=3D"mailto:quwenruo=
.btrfs@gmx.com">quwenruo.btrfs@gmx.com</a> wrote:</p>
<blockquote>
<p>=E5=9C=A8 2026/5/25 00:45, Yifei Chu =E5=86=99=E9=81=93:</p>
<blockquote>
<p>Hello,</p>
<p>Short version: I am reporting a second Btrfs dev-replace error-path bug<=
br>
found with targeted fault injection, this time in the finishing path.<br>
The injected -EIO is in btrfs_commit_transaction()=E2=80=99s normal error-r=
eturn<br>
domain, and the injection is placed at the transaction-commit return<br>
boundary. With that rare commit failure made deterministic,<br>
btrfs_dev_replace_finishing() reaches WARN_ON(ret); with panic_on_warn=3D1<=
br>
this panics the kernel.</p>
<p>Tested kernel:</p>
<p>v7.1-rc4-640-g79bd2dded182-dirty<br>
commit base 79bd2dded182b1d458b18e62684b7f82ffc682e5<br>
x86_64 QEMU, KASAN config</p>
<p>Reproducer shape:</p>
<p>The initramfs source mounts a single-device Btrfs image on /dev/vda and<=
br>
starts device replace from source devid 1 to an empty target device /<br>
dev/vdb. The validation patch forces the commit in<br>
btrfs_dev_replace_finishing() to return -EIO.</p>
<p>The point of the injection is not arbitrary state corruption. It makes a=
<br>
valid transaction-commit error deterministic at this caller, so the<br>
finishing path=E2=80=99s error handling can be tested.</p>
<p>I reproduced this twice under targeted fault injection. The signature is=
:</p>
<p>BTRFS info (device vda): dev_replace from /dev/vda (devid 1) to /dev/vdb=
<br>
started<br>
BTRFS error (device vda): AGENT_BTRFS_DEV_REPLACE_FINISH: forcing finish<br=
>
commit EIO<br>
WARNING: fs/btrfs/dev-replace.c:912 at<br>
btrfs_dev_replace_finishing+0x295/0x13a0<br>
RIP: 0010:btrfs_dev_replace_finishing+0x295/0x13a0<br>
Kernel panic - not syncing: kernel: panic_on_warn set =E2=80=A6</p>
<p>This looks related in theme to the dev-replace start-path error<br>
handling, but it is a separate callsite and a different state surface:<br>
the commit happens after scrub returns and before mapping-tree/device-<br>
list updates. I did not find a direct current-upstream fix for this<br>
finishing-phase WARN_ON(ret) site in my local duplicate sweep.</p>
<p>Expected behavior:</p>
<p>The commit error should be propagated and the replace state should be<br=
>
left consistent, rather than treating the error as a warning-only<br>
invariant. A real fix likely needs to audit target/source device<br>
lifetime and replace state around this finishing path.</p>
<p>The attached tarball includes README.md, repro_init.c,<br>
positive_instrumentation.diff, QEMU args/results, and both full serial logs=
.</p>
</blockquote>
<p>Your attachment looks very malicious.</p>
<p>Firstly the tar.gz is way larger than the only file inside the tar.gz.</=
p>
<p>Secondly the only file inside that archive is a hidden file, named<br>
=E2=80=9C._btrfs_dev_replace_finishing_commit_warn_panic_20260523=E2=80=9D.=
</p>
<p>The file is hidden is already suspicious, and =E2=80=9Cfile=E2=80=9D tel=
ls me it=E2=80=99s a<br>
=E2=80=9CAppleDouble encoded Macintosh file=E2=80=9D.</p>
<p>Nothing matches your description.</p>
<p>You have a lot of things to explain.</p>
<blockquote>
<p>Thanks,<br>
Chuyifei<br>
</p>
</blockquote>
</blockquote>

--00000000000079b9950652af6a73--
--00000000000079b9960652af6a75
Content-Type: application/x-tar; 
	name="btrfs_dev_replace_finishing_commit_warn_panic_20260523.clean.tar.gz"
Content-Disposition: attachment; 
	filename="btrfs_dev_replace_finishing_commit_warn_panic_20260523.clean.tar.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: 2d623bced498c46e_0.1

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
/Pz8/CM+/w8XZTBDAHgBAA==
--00000000000079b9960652af6a75--
