Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B6A35294E
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 06:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774419850; cv=none; b=OBvQJngBkfuz0xxohtVshAEE1XdQWaRfXRlKkRaoJQ+xfeS2Cdt2tn8DcXOLaKyiYbBZ3G9kOasErY3Kf3jU8/qhDPo9doCCtqSqCY0lO283o2NK3wZ3zl+R3vfl+2Rh9I6IxJOnqmwWvaELoNbLSk2kOBih7B7BPPt8XkgeeTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774419850; c=relaxed/simple;
	bh=w6PhaDbqDloKrgQyUQLopSFb93juNzw4s4OvjTTV1f0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fFAOMsvo4Nm+qdynx6g21DE6cRYmPe6rtD+q4EWSKAhUdMt4pPTAMoW7Hc9a+dwKrAu1Ook0iDXPcBMDZvWbm3bLRmsTFpUICglB66wodYwZqRNiEkybgagCyPwAvOEkUQ4Zte5v3zNoI3rudGBOsrRHdZbfL6JieW+CbMLTc0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Q/8792EB; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Q/8792EB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1774419844; x=1775024644; i=quwenruo.btrfs@gmx.com;
	bh=oZmZEL+TjmD4+Gn/Lu1cNGm/YwTfLVwMFts12pnTxdM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Q/8792EBsysEvG8qr6TW8/TB6Rm9uLgaI/dM1gddf3VMe4ZtsbF+EsHl6jg72gNY
	 9Py3HJOYZcUbO/Spx4OZjlcleL51hsA4/IbEr0tXFgh2+rRE650L69Fr6q8H86JGI
	 tHwyG0NDvEXEu1vQI7vfLNWfJJSuKnMM8trQlvL4aRqe/A5DNHevzuXvwmDqFhGB2
	 ZgkTTKmHQb3n9SRlE5qM84J2phb2MKT2LFxA9NveMeTjB+A+pYJp13FrVrUdSfllM
	 B8mg8dMyE4Ndr2RIrsoDW3lbuSL2HJtgDpuCy3TJk0VBdw5vvWNdrw607d77QBGmJ
	 kuWyy8TL9fgqYO3vlA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M2f9h-1w7k6O1lt9-006b8G; Wed, 25
 Mar 2026 07:24:03 +0100
Message-ID: <2846a90e-e99c-4395-b33f-ec336bc20e70@gmx.com>
Date: Wed, 25 Mar 2026 16:53:59 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] generic/747: handle ENOSPC gracefully during write/delete
 cycles
To: Leo Martins <loemra.dev@gmail.com>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <efcb3c8470bf099534fec1c1745780eba445e111.1774394322.git.loemra.dev@gmail.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <efcb3c8470bf099534fec1c1745780eba445e111.1774394322.git.loemra.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:y+SQsQuMryNqrxFeG5Vz3KnmOa4X/IyJXUrQjMtGUMZvgCpkDSD
 LOJdGzkLEbFEvXbYumrNRyX1wz7iy2pxluHkH2/YguINjdbRKeR0W5lG8xjIsMFz8fPjCDN
 LfgP9QUn3njXm2Oc4TA8UpDQ0YV9viNZSb3nWSaMcuX2RF4ajg+i7XC56CJENt9/OquVQrL
 Rr3GjmQcCtBtuBukfKKqw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:89EE04mqcYw=;GFuc4mNSqXa5zr0VSmvhx5lJhGh
 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
 eF



=E5=9C=A8 2026/3/25 10:03, Leo Martins =E5=86=99=E9=81=93:
> generic/747 consistently fails on btrfs in my fstests setup, with an
> ~88% failure rate across multiple runs on kernels ranging from v6.9 to
> v7.0-rc5. This is not a regression but a pre-existing issue since the
> test was added.

Glad we finally have someone trying to fix this.

>=20
> The test fills a filesystem to 95% then does mixed write/delete cycles,
> using statfs to decide whether to write or delete. However, statfs
> f_bavail may overestimate the actual available space.

If this is the problem, then I believe we should fix our f_bavail=20
calculation.

> On btrfs, the
> statfs implementation documents its estimate as "a close approximation"
> (fs/btrfs/super.c). At high fill levels the discrepancy between what
> statfs reports and what the filesystem can actually allocate becomes
> significant, causing dd to hit ENOSPC even though statfs indicated
> there was room.

 From what I can see, there are several different ways that f_bavail is=20
overestimated:

- btrfs_calc_available_data_space()
   That functions goes through each device and try to find unallocated
   space.
   This can not handle uneven space (e.g. 1G + 10G RAID0), and it should
   go through the  per-profile estimation, which handles uneven disks way
   better.

   Normally it shouldn't affect single device, but we can still over-
   estimate by taking the reserved 1M bytes as available.

- total_free_data calculation
   It's just on-disk size minus the on-disk used space, which doesn't
   take things like reserved space into consideration.

   Thus I guess the problem is mostly from this part.

Mind to give this idea a try to fix the long failing g747?

Thanks,
Qu

>=20
> This is not a filesystem bug. The filesystem correctly rejects the
> write when it cannot reserve space. The test's purpose is to stress
> garbage collection through write/delete churn, not to validate space
> accounting.
>=20
> Handle ENOSPC by cleaning up the partial file and making room:
>=20
> In _direct_fillup: break out of the fill loop (we're full enough).
> In _mixed_write_delete: delete a file to free space and retry. If
> writes fail 10 consecutive times, _fail the test as that indicates a
> real filesystem issue rather than a transient statfs discrepancy.
>=20
> Redirect dd stderr to seqres.full so errors are preserved for
> debugging without polluting the expected output.
>=20
> Signed-off-by: Leo Martins <loemra.dev@gmail.com>
> ---
>   tests/generic/747 | 28 +++++++++++++++++++---------
>   1 file changed, 19 insertions(+), 9 deletions(-)
>=20
> diff --git a/tests/generic/747 b/tests/generic/747
> index 44834186..35de3ccb 100755
> --- a/tests/generic/747
> +++ b/tests/generic/747
> @@ -35,11 +35,7 @@ _create_file() {
>  =20
>   	POSIXLY_CORRECT=3Dyes dd if=3D/dev/zero of=3D${file_name} \
>   		bs=3D${bs} count=3D$(( $file_sz / ${bs} )) \
> -		status=3Dnone $dd_extra  2>&1
> -
> -	if [ $? -ne 0 ]; then
> -		_fail "Failed writing $file_name"
> -	fi
> +		status=3Dnone $dd_extra  2>>$seqres.full
>   }
>  =20
>   _total_M() {
> @@ -69,7 +65,10 @@ _direct_fillup () {
>   	while [ $(_used_percent) -lt $fill_percent ]; do
>   		local fsz=3D$(_get_random_fsz)
>  =20
> -		_create_file $testseq $fsz "oflag=3Ddirect conv=3Dfsync"
> +		if ! _create_file $testseq $fsz "oflag=3Ddirect conv=3Dfsync"; then
> +			rm ${SCRATCH_MNT}/data_${testseq}
> +			break
> +		fi
>   		testseq=3D$((${testseq} + 1))
>   	done
>   }
> @@ -79,14 +78,25 @@ _mixed_write_delete() {
>   	local total_M=3D$(_total_M)
>   	local to_write_M=3D$(( ${overwrite_percentage} * ${total_M} / 100 ))
>   	local written_M=3D0
> +	local enospc_retries=3D0
> +	local max_enospc_retries=3D10
>  =20
>   	while [ $written_M -lt $to_write_M ]; do
>   		if [ $(_used_percent) -lt $fill_percent ]; then
>   			local fsz=3D$(_get_random_fsz)
>  =20
> -			_create_file $testseq $fsz "$dd_extra"
> -			written_M=3D$((${written_M} + ${fsz}/${M}))
> -			testseq=3D$((${testseq} + 1))
> +			if ! _create_file $testseq $fsz "$dd_extra"; then
> +				rm ${SCRATCH_MNT}/data_${testseq}
> +				_delete_random_file
> +				enospc_retries=3D$((enospc_retries + 1))
> +				if [ $enospc_retries -ge $max_enospc_retries ]; then
> +					_fail "failed to write after $max_enospc_retries consecutive ENOSP=
C attempts"
> +				fi
> +			else
> +				written_M=3D$((${written_M} + ${fsz}/${M}))
> +				testseq=3D$((${testseq} + 1))
> +				enospc_retries=3D0
> +			fi
>   		else
>   			_delete_random_file
>   		fi

