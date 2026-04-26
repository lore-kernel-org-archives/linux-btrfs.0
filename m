Received: from rebatir.fr (rebatir.fr [212.129.56.80])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7209020E702
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2026 21:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.129.56.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777239072; cv=none; b=RAc/k99QFg5V2czEgdj/bhcWKGOU9HTsrMhYMiawEQyYMMSbK7jxMRHD7gaywCUO0tR2+1i81lUsPQy+3s5rG3C4FVYiIIx4W61Fhky+SeYmI43TVGpKuae1ukY1Kqtg0kMJcjmvKXFxwwouQkOt98JVnfGd+WAVCEa1GnksfNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777239072; c=relaxed/simple;
	bh=CT5oJxANCipfW+8omlDeNzVYZx4hZR55maK/dawCaRM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=IyZJsbeVCnjFLS9+vSaINK6XJ0dLBPuNdeyqiSOXOMVObeRp1vNiUU4BVjYcJBG1Y05rU8RR1tKtwA+DolF7rnmmizG28Top3EQCkreP4zlv7BgBZd5CPVObzVAe6iSQ8j651bxK6hJ/FSEqK+++X2AfqLBS5wUpT6kvmLENpGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=illwieckz.net; spf=pass smtp.mailfrom=illwieckz.net; arc=none smtp.client-ip=212.129.56.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=illwieckz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=illwieckz.net
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by rebatir.fr (Postfix) with ESMTPSA id C377920141
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2026 23:23:51 +0200 (CEST)
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-2c15849aa2cso12520904eec.0
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2026 14:23:51 -0700 (PDT)
X-Gm-Message-State: AOJu0YwGX/iNutu6nPwdvlrGuuHrgjJPcNYUSGNXzDERgHv8q2LIqs++
	I94jFUl2HI1H+QY/kdX9Q2wX4w5KRx8Cs12rGx4IZaiwJFM1X+eK2H77ZCXhC/5Sw5HEw2RTAg2
	BM2Qf13Saveo7z3iKe8k0NPcaINvgCGg=
X-Received: by 2002:a05:7022:103:b0:12c:3d30:37ba with SMTP id
 a92af1059eb24-12c73f9bf03mr17716996c88.25.1777238629874; Sun, 26 Apr 2026
 14:23:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Thomas Debesse <dev@illwieckz.net>
Date: Sun, 26 Apr 2026 23:23:38 +0200
X-Gmail-Original-Message-ID: <CALpuBKwmZRYX0Mag-gLSoL9NgBBR_D+iOeKX7sdhHtyAposGRg@mail.gmail.com>
X-Gm-Features: AQROBzAJH_MNrcPZK8R9yPYbT1vZ7DUAwwBPLQP6wzmdGpG_NTCfn1bFgVj7eCM
Message-ID: <CALpuBKwmZRYX0Mag-gLSoL9NgBBR_D+iOeKX7sdhHtyAposGRg@mail.gmail.com>
Subject: corruption after block-group-tree conversion, how to recover? (data
 is readable)
To: linux-btrfs@vger.kernel.org
Cc: Thomas DEBESSE <dev@illwieckz.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, I just did a `btrfstune --convert-to-block-group-tree` conversion
operation on a btrfs filesystem and this corrupted the volume:

```
[  786.278571] BTRFS info (device dm-9): first mount of filesystem <uuid>
[  786.278595] BTRFS info (device dm-9): using crc32c (crc32c-intel)
checksum algorithm
[  786.442781] BTRFS error (device dm-9): parent transid verify failed
on logical 9820282388480 mirror 2 wanted 5715946 found 5717327
[  786.448020] BTRFS error (device dm-9): parent transid verify failed
on logical 9820282388480 mirror 1 wanted 5715946 found 5717327
[  786.449543] BTRFS error (device dm-9): failed to read block groups: -5
[  786.481199] BTRFS error (device dm-9): open_ctree failed: -5
```

I can mount the btrfs volume with `mount -oro,rescue=3Dall`, I can
browse the filesystem, and every file data I checked loocked fine.

Here is the log when mounting with `-oro,rescue=3Dall`:

```
[ 2523.344235] BTRFS info (device dm-9): first mount of filesystem <uuid>
[ 2523.344260] BTRFS info (device dm-9): using crc32c (crc32c-intel)
checksum algorithm
[ 2523.612830] BTRFS error (device dm-9: state C): parent transid
verify failed on logical 9820282388480 mirror 2 wanted 5715946 found
5717327
[ 2523.613372] BTRFS error (device dm-9: state C): parent transid
verify failed on logical 9820282388480 mirror 1 wanted 5715946 found
5717327
[ 2523.639263] BTRFS info (device dm-9: state C): enabling ssd optimization=
s
[ 2523.639268] BTRFS info (device dm-9: state C): disabling log replay
at mount time
[ 2523.639271] BTRFS info (device dm-9: state C): turning on async discard
[ 2523.639273] BTRFS info (device dm-9: state C): enabling free space tree
[ 2523.639276] BTRFS info (device dm-9: state C): ignoring bad roots
[ 2523.639278] BTRFS info (device dm-9: state C): ignoring data csums
```

The log reports SSD optimization to be enabled because those drives
are bcache backing devices. Bcache was disabled throughout the
operation.

I expect that recovering from backup would take 10 days, so I would
like to avoid that if possible. If there are ways to recompute the
broken metadata for example or other repair operation, I would prefer
doing that.

I asked on #btrfs channel and after helping me succesfully mount the
volume, multicore recommended me to send an email to this mailing
list, so here we are.

What do you think about it? Is there a way to repair the filesytem?

Context: This is a 4 HDD btrfs raid10 volume. Drives are large (16TB
each, Seagate IronWolf Pro).
24 days ago two drives started logging some errors, so I replaced
them. Those drives are bcache backing devices but bcache has been kept
disabled for the whole operation that follows.

I first did a backup of the files in their last state. Then I replaced
the first drive with `btrfs replace`, waited for complete replacement,
then replaced the second drive with `btrfs replace` and waited for
complete replacement again. Once this was done I shut down, removed
the replaced drive, only keeping plugged in the two sane non-replaced
drives and the two sane replacement drives. I then rebooted, mounted
successfully the btrfs volume, and did a scrub. The scrub finished
without error.

It happens that this btrfs volume had been created on September 2023
so I was running Ubuntu Lunar that used Linux 6.2 at the time, and it
lacked the block group tree feature. Mounting was very slow so and it
annoyed me so in February of 2025 I asked on the #btrfs channel if
there was something doable to speed-up things, and it had been told to
me that enabling block group tree would help me. Out of caution, I
didn't do it at the time, waiting for a better moment. Since I just
replaced two drives and did a backup, I thought this was the best
moment to do it, and I did the block group tree conversion, after a
year of patience. It looks like it was the right time to do it but
that I should have not done it.

It also happens that I use btrfs deduplication and compression
extensively, and I do know that in fact once decompressed and
deduplicated the data is larger than the size of the disk storage. So
not only decompressing and copying from borg will be slow (and take
days=E2=80=A6), but I'll have to also wait for btrfs to recompress everythi=
ng
and I'll have to run bees while the copy is going on to deduplicate on
the go to make sure the restoration fits. This will be slow as hell.
That's why I expect the restoration from backup to last 10 days. Since
I'm already in degraded workflow since 24 days, I'm looking for faster
options if they do exist.

So if there is any recovery or repair operation available I want to
try it first. Since I can read the data, can the corrupted metadata be
recomputed?

The system is running Ubuntu 24.04.4 with Linux 6.8.0-110-generic and
btrfs-progs 6.6.3-1.1build2. I can run rescue systems on removable
drives if newer tools are required to repair.

Best regards,

--=20
Thomas =E2=80=9Cillwieckz=E2=80=9D Debesse
