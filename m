Received: from outbound.pv.icloud.com (pv-2006h-snip4-11.eps.apple.com [57.103.67.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0787E43E08A
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 06:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.67.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789452494; cv=none; b=fgOgCTooMxb+OBCwEnwka/8nKu9RsX0u6mHLrseen+9ZtOiK7dSWvncQkJ02OPpT9R8LTWc8NyCkG589ubN2ttP3fupbPxwJxClm5P+t5EFlv1tQbe6Y6+P52/Vqga54U/bHonJdWwaKAYEfXpDvJtNCY2qjRpb8m9SvZ3F8cqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789452494; c=relaxed/simple;
	bh=79kcZ+O30+iU0D1VkgZoYPKKCDocfroD560qea7HTXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGKcngJKrMKFpzr4qcyVcpEOEdnkyls5hLd9Bd2UHu5g3jRh0g3Xzk/DulauGbR3XUzJdIzubKp4lRzMTyTkSs1jhIVFex2yztIdTzSMKJta6YYHcbXg1StRj+r1SKUT5ylQf69/DlNtbSgZeG0/ka7tiujrB//5GQGV7OAvD7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com; spf=pass smtp.mailfrom=dev.linjama.com; dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b=UeJ4oVKr; arc=none smtp.client-ip=57.103.67.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev.linjama.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dev.linjama.com header.i=@dev.linjama.com header.b="UeJ4oVKr"
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-0 (Postfix) with ESMTPS id 829FA1800395;
	Tue, 15 Sep 2026 06:08:10 +0000 (UTC)
X-ICL-RepId: 01a0a3ae-16e4-78c6-b309-842ef21a88f0
X-ICL-Out-Info: HUtFAUMHWwJACUgATUQeDx5WFlZNRAJCTQ1NHVwGRQpFF0oBVBcOVk1dGV0EUgdyFFwOHQFeBVgRVBkdDlgGEhZdRVcIQUVeGVcSUgBWRVEfVFhBDgpdEhhcFFxQWB5GElYNXQkZG0ReUBtfAkIPHBNWFRMdQxkPKwhKBEMHRQJeCyUTCVNWVhVPVl8EWQFTHVhWUAJaS18ZXUUPXwdZBEAASQZdAVsFRA5WAFwCUgFIFEkeCVYFWxVVOFcIQUVeGVcSUgBWRVEfVEYTGU4bV01aDUAZWAZtFFYVUgRZ
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dev.linjama.com; s=sig1; t=1789452492; x=1792044492; bh=79kcZ+O30+iU0D1VkgZoYPKKCDocfroD560qea7HTXI=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=UeJ4oVKrgwv8O3VZA6JIUShJNSGNSPysOFenuqspiV4K0mNS6fi9JiOyDkNk+X63+9P5vegcNgMHDtibfjIO5G8vBIFPBaOxok9wynuJMr+t83PGYcAMCWjVf0ujUEWDLwBsjyzxZabEcn9In6p8NqnOsxkJE0FzUJQMDhLFjbGgrZ3VmBXOt5eRyJw4apdqN92DRjDOrOktJtODBNocdDJXEQhvVwI700IKSYbticvk7YTx+IsHcl+mgIAHmgLO9CMKuhPI7W4oUwyOzrPqFffC5W3PDLRklzhMdRur8/F0lLC2G67KCAZFMg6fI3+iZC7/ahPU8oEsYIFpsbCJsA==
mail-alias-created-date: 1690913137769
Received: from dev.linjama.com (unknown [17.156.192.29])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-0 (Postfix) with ESMTPSA id A8A941800128;
	Tue, 15 Sep 2026 06:08:08 +0000 (UTC)
From: Daniel Linjama <daniel@dev.linjama.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org,
	David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	linux-kernel@vger.kernel.org,
	Daniel Linjama <daniel@dev.linjama.com>
Subject: Re: [PATCH] btrfs: don't force the filesystem read-only on EDQUOT/ENOSPC verity rollback
Date: Tue, 15 Sep 2026 09:07:47 +0300
Message-ID: <20260915060747.315938-1-daniel@dev.linjama.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <af99a1d5-25b0-4e39-9f66-a2dd8e1425c5@gmx.com>
References: <20260914062459.3889313-1-daniel@dev.linjama.com> <2107e9f8-2bc6-42e5-98e2-30e25be016dd@gmx.com> <af99a1d5-25b0-4e39-9f66-a2dd8e1425c5@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: MTz4CtcDUFM_BkfUT6jAJsIG5OGdzdlh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDA4NiBTYWx0ZWRfX6pw9teXPJ6dJ
 v3oO6JcfSeJaryzRWweSNUW9PzkHMnkQJxuoeYH26/7OFOmK4Ve7JozgwLGOyfpdnc3kSljFRBr
 zXL4hRmRJzDYsKN9DUN4d/qOhJ8gfhtOaI7VdjCuBQIby51kDjmbeoPCHhC/dslIWtI6AV+gZAO
 r9mfTFrUQpuZvgF+ZV6h1SSM/4wU+rdU2rr15E3hQ/H71+16sxb+jMhMOSBXGFPRXuqKBwZJpew
 ZU9vJtibw81iSGyQ8+p0LxEt+C/wOpW2kH+E7807UO6cen5m0gZJirlhhAwBL6+Zjt6kcoNbVf6
 8Kv/IEAUgTYMg8wuZSSEiOHy25FaGTh4ijqjXMcSnKnJPscDCih5USfMdqmBno=
X-Authority-Info-Out: v=2.4 cv=TovrRTXh c=1 sm=1 tr=0 ts=6aa8e0ca
 cx=c_apl:c_pps:t_out a=aW9mcIavGNWWFvFFKOxBSA==:117
 a=aW9mcIavGNWWFvFFKOxBSA==:17 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=olXNNK5aAAAA:8 a=Em7shX7px7pPTLXbYC8A:9
 a=U4UmX7kblY_o6ZOM_jyP:22
X-Proofpoint-ORIG-GUID: MTz4CtcDUFM_BkfUT6jAJsIG5OGdzdlh
X-JNJ: AAAAAAABf5j+aTQi/vM5/r14a7ADckd+SNY8EMdYJRqbFlP7J3gbbvSqHAjuriIzATqt99IsajlKsCK8O81uafmhNWkY0aaeq2NMrl8Ygm8M7Xt/Zl9WJELz/xd7t0Mx/b5uCI+0//Ho4o2W6BPXD0Bj6g6EuSuylMThlurRx1t9H36YbzFdojk1aDN0kOjeKdjkvii81iDpSy4mfCSLD9OoAbxG9o2WQ3XGTQU1fmz32De2Ra5oZnjeZLVM1w3dZzW3k2g2y98/qPNQRZ1p/13jbflDlYQRs3l5q+PK/ctmcS3SKw86Y6PpEeoFnaBk0sNzL4/P79iu1IAiGthCMR6tl5ule0VRESi0zS+ER0dK0ri5yugTyZOZDt3TIn/7lu2n7jSqJOIpIq6p19cQj5SpnsBtxsuVHWofl4i/lY1nM/e/ncjeccPFe3InjXVA6Te0O9+p47He2sFakm1srZmDSyvJJXiJO/BUrpMVcU02De5YG9Ck6XUPXsfaoZxitrQcXcaMa08Egp053EetYZ+gcaQhf7f3qauenH/ocuSbcVyMB4GscH1y/RozGfCPNUyZAhI0KA2wMgNWJyTgeM/tuo1FebJAJWz+gVjItGEoXMSapAK/TH55djaqrGWtyObB75j0lBACzVb9aOF4c9S3DWev1etJ/lVnIZnuhge1UHl/J/EECv4eNxbnd7nECIAbLs9jNxKgvxP9lXofTi4mrkEQTyX3Vv+odu/gycBiLIuA2ZgmsTiCFUZ7I7ArwfpNTg9bOaXxtDeiJR5ecJNZhy0CkT4tbN5h/5aZooXUkoQzd0weXgRQ5Q269NruR4qyIfTxslv4a5Wn3RXw4JckzsCkGtymxiGywarN8yp/zaB1a2HS8Vv1UIOmyDOq0KKM4NGKFu09qGeV9ZuoHMGT67H63mffZEh6Sle/Smit8N3wbbCix1qqIJFZ124XO/mvaMtLKHv7SzbtP8vXOU0Ooke+t2t
 39LaHNmGl10PFxu37yi8EYxpIyjyro/QW5OVudMwLPfGfxiYcw52ZdVCGaHSENg1kL9sb1ssuyh0Uz0RTThAqj48d+M11SA+TCr8rk5KbyPa0n8ZrX5R3gOfrRtlplcNm6/g/CUyvinfLhFPpxBsdUy0cRArvtnizMiFWWyXNAHrnrHaoYPyEIY0+0BsrKBP+hmQ1X+bkHICTB4aRhX+i/YaNJsadhOPSmxyeuN4J48/wrj4XG3wGI64XYXCKbNxo5bnvdC6zlzt8nkIs/zqlEC6vHT/tWM7DTyp8K30T58+4yfjUoKmCseEQmuIJWgpBQ3GlgA==

On 2026/9/14 18:45, Qu Wenruo wrote:
> On 2026/9/14 16:02, Qu Wenruo wrote:
>> Please also submit a fstests case for it.

Sent to fstests as btrfs/354 (qgroup limit) and btrfs/355 (full
filesystem):
https://lore.kernel.org/fstests/20260915053815.307674-1-daniel@dev.linjama.com/

>> EDQUOT is fine, but I'm not sure if ENOSPC is really recoverable.
>>
>> Even if we ignore ENOSPC for now, we may have really exhausted the
>> metadata, and the next transaction may be aborted anyway.
>
> Sashiko also mentioned even if we ignored EDQUOT for now, the next mount
> we still fallback to call btrfs_drop_verity_items() on the inode cleanup.
>
> And it will return -EDQUOT again, so the inode will not be cleanred up.
>
> Considering we're only delete items, I think the better solution would
> be calling btrfs_start_transaction_fallback_global_rsv(), which will not
> enforce qgroup, thus should not return -EDQUOT in the first place.

You are both right. With v1 the next mount fails the orphan cleanup with
-EDQUOT again, every lookup of the subvolume fails, and mounting it with
-o subvol fails too, so the subvolume is unreachable as long as the limit
is in place.

v2 does what you suggest: btrfs_start_transaction_fallback_global_rsv()
in drop_verity_items(), for the second transaction in rollback_verity()
and for the orphan item deletion in btrfs_orphan_cleanup(). All three are
needed, the reservations of the dropped items are only released at
commit, so the following transactions hit the limit as well.
https://lore.kernel.org/linux-btrfs/20260915055109.311839-1-daniel@dev.linjama.com/

>> I believe your test case is only utilizing qgroup limit, or did you hit
>> a case where btrfs_drop_verity_items() returns -ENOSPC and the fs still
>> works fine?

Yes, on a full mixed block group filesystem the rollback fails with
-ENOSPC the same way. Without the fix the orphan cleanup then fails the
next read-write mount (open_ctree failed: -ENOSPC), and the filesystem
can only be mounted read-only after that. With v2 the mount succeeds and
the leftover items are dropped. btrfs/355 covers this.

Thanks,
Daniel
