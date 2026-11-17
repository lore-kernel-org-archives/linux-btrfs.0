Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794889430;
	b=gDKYc6iQ3bQJ1fKCFxc5IKUlyUmroViQFd7SfCHBHJ+3OHQIt4W+3CSkKkSL7SU+8/P0
	 VJXqgEz/NJV+RkPzl1VCQA31k2Kozr/4HDJ/fi5TxSN1bXyJ5vK7DEOKO/2Kznb0gH711
	 vS6Ym7xoL/dZ1V8J+tIdbVFl+gvJc31CbctuLUk+rNYT9HcduLA53mq/fj1Mb8LXXAFaw
	 PBm0twHEMOwj5aQ5wFzj/P7Nj2360X9LZhApOp1+Cb7uZUud/+RKHXvpezjgQ2UIafaYe
	 Nfhjh9FcVYOa1r/6tZLPyCmn+Lz91wFbqmaeDDCsj1RJT2epvBwX5E+Lmw8JhIbP4lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794889430;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=APV8tg0ohFqcqTgesQx19N4C7Xf7Brb9XeqQiqqac7Q=;
	b=IpCfqc1utOci8TN34Bw/8b1VmDmDFBcqzgUBfX7QfTsjEVSLH+ZY0exUecKanHRsLbcQ
	 HXYoamxgtC95uzY/9wzZggXUOSkO8jN1YmPn1ynK/B/5+aQ4o97QL2P3oGrCnTyqGQ3qt
	 riSXJ1ygcVPCvnvYMIVZhkyVCHZihRcFHR2erfh4WakZALrfnXGEEoXBQA8JLJc/lS5xd
	 kqS/hprdQyA2vc5XRr881BFcKNNdSNVF0Xu9ZTcv5FT+A6HB6Qrr8R7bcC1y5V4GUZjKc
	 92ZYGUJnXWEAP6qiKrVqiwQLqxQNnuqC9rcGBFUArbyId6dMSQghomjWbi0vZ9bCBqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=m7AfkUQC;
	arc=none smtp.remote-ip=212.227.17.22
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A671F606A323
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 04:23:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A671F606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=m7AfkUQC
DKIM2-Signature:  i=1; m=1; t=1794889427;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:Tnf0Dj0XbCxI+Js+CSGKVwVwo9GG
   OBWbK8ESR9VoCweXefvDuFTQBQsw1bS17zX8+dTsX++FZwdPIolkLYPoFz0sNuc0gPI1gXleZEL
   mQHCaecVsfKa/whyFmWGu8hmHaAPm+eKHIS2vHRzqXHwaTguNoThR0908d8IDHPpYDnWRICPFOd
   dY/IZoUe20J9ByCEXGdOZnEfQegpMOtJEyc7TQT1K8x1dKeGTAEkUPcZvrudcioi8eyuzCPo8V5
   deuVlJYpGIt1aDv9RC/AUFRAmYJ/A5reOS2xkLqtiCIzaEB265m8xIqHUbalA+EGQW2M1irgsg/
   b6ZqbQyYeT2HvQ==;
Message-Instance:  m=1;
 h=sha256:
   arFSDpxcRTSJ8bKqKcdJzyPDSCF02AsXZLqnpZXUzXE=:
   DFmFieaS17jxWT//I0DtP42udxwRUVO1DcaV3AgO3Ro=,
  sha512:
   XGeCUDX2aM3An662y3urDIfEmxwVpvhGmYbRmtZsBr5HF+o8GWU5nHyRUXxhp0ns1Th2oCnn4IsIA1WDNvcqrw==:
   A+9n5u0DliCUbywmcFMAYZsWsLltyZooZSvDJaBcIK1LqE3vYLnWsTlWkQUcMqSq+2KBcFTZMmhL8VC0+MyWyA==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794889419; x=1795494219; i=quwenruo.btrfs@gmx.com;
	bh=APV8tg0ohFqcqTgesQx19N4C7Xf7Brb9XeqQiqqac7Q=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=m7AfkUQCEcNoLtgEaJsnpGpQ8G+VLu0rwZuSsthUt/ZdEIhXfesgGhRS0fAKDZlZ
	 spTeY4eAl/rMmn031w/3uXuSyNYJWE6KYyWfANCKjtKqf6tq9G6c6Qc8NcmTWygs2
	 i+9MpYheO8ItBh7Mc//WHzSogfi5fw9FYy+TDW+z54eGQ9I+a5q8tObPS08v67ZKp
	 9iioO+wh0GGb2fJQ6I/91rXLclXy5Nmsg9oQuPPKHRbHSrW9+VxztNZd5dFBMV/Dy
	 UuDvKVjVOfvJO22L/Brogxop57hGbj7FC71rnORXeN55o5hpG3zLboYvX4RaBL9oI
	 QtXnwJYIaItYP6F+EA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MmlTC-1wlcBY46Zq-00gsWK; Tue, 17
 Nov 2026 05:23:39 +0100
Message-ID: <9155e9f6-9d76-43b3-bd20-a4c98a9f2c84@gmx.com>
Date: Tue, 17 Nov 2026 14:53:31 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: remove "rescue=usebackuproot" from "rescue=all"
 shortcut
To: Hengyu Liang <hengyul@cs.unc.edu>, linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>, Boris Burkov <boris@bur.io>,
 David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 linux-kernel@vger.kernel.org
References: <20261117030353.1738805-1-hengyul@cs.unc.edu>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7o8gUJFKS8
 OQAKCRDCPZHzoSX+qAogB/9C5ErH7KGAGpcLPte3Wcfdt3acCkGAuMpCjqOt8BVw30mX0kmF
 SRo2nODjz8YsYhWR1T8L3ylANAS/IGIJ64idBmObaqGHQn845nXLIvG33LqMsAGXmOJdRgTT
 BnBA+QFCEIZpo7L9Qt1dOQdHSpHT31Ta1kKsbDm582KPVBl6KRcJJBnjudIerOA1/L/zEyDa
 YjIfHIcvuM3Xm8AS00iBpsmc151QgCPljqnSRXBiup9C1oMgVlaROhY1iDam4UIQB6glkHQs
 LZhUmFDNimX5LxfOzi2pFJSjJvPclRZVX7Sq6XhK/OFb6IvswN7i0nUYZMQfuGDNqGn70ic3
 AQImzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7pCgUJFMw7KQAK
 CRDCPZHzoSX+qEjbB/9crFFjips2NKxkt2XUutUIKjBoUlg/xCeFIj8PsTuJePhrV9HzgKsa
 rJgSqo3t78oQWmeaP9WPoDYjfhOkQXEs+G9UwHe/LENm70+Q1jrwY3nlcR3YrkDCJ+EvMZOW
 ackgcOYn46Iri9DN91FbSTszPMnwHi/nf0aeJXicO9krrY5C8mUxv4CSKeKSRg/5BR59uDiy
 9CMRHDtIDnpDWaLOXtUeowCdiC5O/jA571PMFx3Aolc7g4SSyNbYodblCBOdJrh0CVm2LlQW
 3SXrvFpSAw7LMVDgsS8pTRt4A11eTIS7mz0zqafTohXP1wt+575IBHK5ZpThQb+PzSQmxAqa
In-Reply-To: <20261117030353.1738805-1-hengyul@cs.unc.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tmW1SD8SdRYQRdJ3BKEG4qFxwmxQW99FnAebiX7bpl2j02Ze2JR
 5w+B9c1HadIFAHbcsQ+XTOS09xBOTFQQ51v5YScD1ZCHCGuBhb5d2mUmLR05qqJmAAITNVc
 +/pW/xn1K9WrCn3XhzT0aly9jjT5lKcotRKe4vXgmIQggUjAGN9ATxaOa06yBihJx5mWm0G
 lx2TjO7FzsgCbushLLR7Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:TrTg7k0wfPg=;EZy7pqI76tH/e96wSmAuRHTyvlT
 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
 YD15jD9cyAbKamMzuiaw2KhkQE4OlyM=



=E5=9C=A8 2026/11/17 13:33, Hengyu Liang =E5=86=99=E9=81=93:
> [BUG]

Don't use [BUG][CAUSE][FIX] sections for a very simple behavior change.

You should not use this detailed method for such a simple behavior.

> Since commit c73eb6f72741 ("btrfs: always use the second newest slot for
> rescue=3Dusebackuproot"), "mount -o ro,rescue=3Dall" mounts the second
> newest backup root even when the newest roots are fine. As of now, the
> changes of the last transaction are not visible with "rescue=3Dall".

Furthermore, one can even argue that this behavior gives a higher chance=
=20
to mount the fs.

Thus counting this as a bug is very weak argument, thus the whole point=20
of your patch may not even stand.

>=20
> The issue can be reproduced with a healthy filesystem:
>=20
>      mkfs.btrfs -q -f /dev/vda
>      mount /dev/vda /mnt
>      echo old > /mnt/A
>      echo old > /mnt/C
>      sync
>      echo new > /mnt/A
>      echo new > /mnt/B
>      rm /mnt/C
>      umount /mnt
>      mount -o ro,rescue=3Dall /dev/vda /mnt
>      ls /mnt
>      cat /mnt/A
>=20
> Before that commit, the result is "A B" and "new". After that commit,
> the result is "A C" and "old".
>=20
> [CAUSE]
> Commit 2fd3f6a2711b ("btrfs: add "rescue=3Dusebackuproot" into
> "rescue=3Dall" shortcut") added USEBACKUPROOT to "rescue=3Dall". At that
> time the option only fell back to a backup root when the newest roots
> failed to load. Now btrfs_parse_param() sets USEBACKUPROOT and
> use_backup_slot =3D 1 for "rescue=3Dall", and init_tree_roots() calls
> read_backup_root(fs_info, 1) before it loads the tree root.
>=20
> [FIX]
> "rescue=3Dusebackuproot" now selects a root instead of tolerating an
> error, so remove it from "rescue=3Dall". With this change "rescue=3Dall"
> never uses a backup root by itself. When the newest roots are damaged,
> "rescue=3Dusebackuproot" has to be given in addition.
>=20
> Fixes: c73eb6f72741 ("btrfs: always use the second newest slot for rescu=
e=3Dusebackuproot")
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
> ---
> This is new in 7.4-rc (v7.3 mounts the newest roots with "rescue=3Dall")=
,
> so it can be judged before the release.
>=20
> On a copy of a disk taken while the next transaction was running,
> "rescue=3Dall" on v7.4-rc2 showed 30 of 60 files with the data of other
> files and no read error, as the space freed by the newest transaction
> was reused and data checksums are ignored.
>=20
> If "rescue=3Dall" should keep every rescue option, as btrfs-progs
> documents it, using slot 0 for it also shows the newest state, and I
> can send that instead.
>=20
> Tested on btrfs for-next (26eb4d70f96d) with clean mkfs.btrfs images:
> healthy, a damaged data block, a damaged extent, csum, fs or tree root
> block, and the disk copy above.

Remove ChatGPT garbage next time.
Or use your human brain cells to determine whether this makes any sense,=
=20
and check all the patches from known developers for the styles to=20
follow, other than blindly accept whatever chatGPT generated.

No one cares how your stupid agent tested the patch.

If you explained the patch well enough, no one need to waste his/her=20
time on this BS testing steps.
If not explained well, then the testing part is totally BS.


Furthermore, you should not just change this without a doc update.

>=20
>   fs/btrfs/super.c | 2 --
>   1 file changed, 2 deletions(-)
>=20
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index b424cc836bd4..d67d678451f6 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -624,8 +624,6 @@ static int btrfs_parse_param(struct fs_context *fc, =
struct fs_parameter *param)
>   			btrfs_set_opt(ctx->mount_opt, IGNORESUPERFLAGS);
>   			btrfs_set_opt(ctx->mount_opt, IGNOREBADROOTS);
>   			btrfs_set_opt(ctx->mount_opt, NOLOGREPLAY);
> -			btrfs_set_opt(ctx->mount_opt, USEBACKUPROOT);
> -			ctx->use_backup_slot =3D 1;
>   			break;
>   		default:
>   			btrfs_info(NULL, "unrecognized rescue option '%s'",
>=20
> base-commit: 26eb4d70f96d9bf99e87c2565d6234eb652f9c26

