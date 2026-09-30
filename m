Received: from outbound.pv.icloud.com (pv-2006f-snip4-6.eps.apple.com [57.103.67.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9FD466B58
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 08:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.67.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790756935; cv=none; b=QCqXB0efudG0CsO9TffbSy8EH67fIJyXRXJN25s+9WMZdeLuRqYwgWTLT+m6W1fNkr5enhrCXR2n2XNlyPP4LX/BKEqzVLFVkPUltdV0+mn5LHNKkZ/pAHC46FPyQTjt/C8D/0Ys11atNkIh81fX3MLdm/dazNSyz5k9p+wvhUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790756935; c=relaxed/simple;
	bh=/LRbb7eT7+EspHHWBOqxek+ncNOtJ9uKV1DO952/nq0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jlKc7SCTezXorGa+n3SzYuFZ+2fMXwwelpgtZW5sOwVsIaHF16z+swBYD1lRU4/Yl+Is4YlpwuuD7K+NAYWaUweq1Ko5uRBnEH+g1f+iSBWchddz9dFyI0vjgiLLXWDl6uVM0CtfPxeRMpPpG5EHQB0G/PUUBj7XUf2aNLFL+MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fenski.pl; spf=fail smtp.mailfrom=fenski.pl; dkim=pass (2048-bit key) header.d=fenski.pl header.i=@fenski.pl header.b=j01i+lHh; arc=none smtp.client-ip=57.103.67.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fenski.pl
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fenski.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fenski.pl header.i=@fenski.pl header.b="j01i+lHh"
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-0 (Postfix) with ESMTPS id C741418000B1;
	Wed, 30 Sep 2026 08:28:48 +0000 (UTC)
X-ICL-RepId: 01a0f16e-3c43-7b97-9065-1e0048fa77ba
X-ICL-Out-Info: HUtFAUMHWwJACUgBTUQeDx5WFlZNRAJCTQhABkMFWAZeAUEdXA5SEhVdRVEMRR9dA0M4VQhZGFkZFwhfTVEPDxZcFkAGXkVCHBkKUFAES1oVVRcOAkIfUB9MFldDRx0cGVoUXBhTRVEfVFhDGUVWaUELTx1dGVscQmRYVwkKDVceShNaQ0cHEh1QHA5RA1lRSA1PUQwaXQtIDVUHCw8PH0kIHFZAVlgHSVxBBVVTCQNBeR5WA0QAW15JFA1NQxJCFQQbRh5DBF8vXRdeDF4F
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fenski.pl; s=sig1; t=1790756931; x=1793348931; bh=Oe/Y90MTbF2aLeTtM5SRbEL0s7N7gqbTaqNa0SeaDLU=; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:x-icloud-hme; b=j01i+lHhnCWgeMwc/NBvv+r+CecKv4HBuc5DDGctraFBlR2IxuPawSg5p+6gxlEaoafB1eYwglxA4wXFEb+64mNCh3iSPMwuTl71CauVKy8H/dPAs8P+VnUI36V4K6Z1KStjAlmtRa4xWigVESc45OQzPu91Cc3Pf3cd4dDxilcg4sBpgwjIwvxSWb4DjRB2FgZzGUKhKDKlt7lutbKasX1KLBbsUHwI3woZhZSIrV5mmeo4LkglvYUGBsI6Pxpp9ynZeFPzIwh7iCMJEFVcbWY0JSr0P8vGymGXggXCytiZ7M09YVqK5tkHaJy9p1Wbdvo98nwNNiRA37h/nBjELQ==
mail-alias-created-date: 1561792305000
Received: from [10.10.10.10] (unknown [17.156.192.29])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-0 (Postfix) with ESMTPSA id 4CEDF180021C;
	Wed, 30 Sep 2026 08:28:47 +0000 (UTC)
Message-ID: <42c847ba-6984-4f8d-91de-a359e968db11@fenski.pl>
Date: Wed, 30 Sep 2026 10:28:44 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: raid56: do not verify the content if there is no
 data checksum
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
References: <2989cda015c8673ccd463a5225cb985dc9e36825.1790730674.git.wqu@suse.com>
Content-Language: en-US
From: Bartosz Fenski <bartosz@fenski.pl>
In-Reply-To: <2989cda015c8673ccd463a5225cb985dc9e36825.1790730674.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 3V1Fq5WAjPb0soXp_jm49mrCPNAXp-dE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDAzMyBTYWx0ZWRfX/o2fZij0HUc9
 AY/0KwfEpSdjs0Ur46i0I6nhss4wgGoAdrkj2Dr1KbC61Bg3lTt0REtWxwYcK2ovrTwuFBOanfc
 +YSzzUn9AbW0zdFnYjScUU8U25H2WJvrM+oGnyUsPxIBXFfGeZIyHqA8kbkXtol+Z2Jo0CWMGHr
 JYLPt9V3PI93L5dOW162KThASlZ0+68BvgR2baAoTpXaI5F53H1UA+1EQoTCLzrROK70uE/IyI7
 DNwToWwutqRa4Pi9pWOtHiG3OYAIMuAdJLsMJFyAEOjQZgMdDePWygkaMz/qsuMJ51+s1hh4YU5
 WtfQMor9AQ64UdrafIei1cGmLgd0OHkH+yWLCuh8nJNdeNgfuDBz9tTU26WXgg=
X-Proofpoint-ORIG-GUID: 3V1Fq5WAjPb0soXp_jm49mrCPNAXp-dE
X-Authority-Info-Out: v=2.4 cv=NMvYOk6g c=1 sm=1 tr=0 ts=6abcc841
 cx=c_apl:c_pps:t_out a=aW9mcIavGNWWFvFFKOxBSA==:117
 a=aW9mcIavGNWWFvFFKOxBSA==:17 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=iox4zFpeAAAA:8
 a=yDf0iHzyEnFXKLVeQvYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=WzC6qhA0u3u7Ye7llzcV:22
X-JNJ: AAAAAAAB/4ovPQ5aiXD8mxT39y+LAdb/o5sspjV7d+vEdjASDe/6qgRbhuA55nZ3f2WiL1h87MST2Tt7MtzH+WQh7kLtZK798pNAko1qfZMQYFtDfCOk4Ss7zricwqPZVSgr/T1/igLacXnfh+xqqYNgUaACHn4P71LOY3A/pBZdf4b8ccEL3TyGLeZNMQyUoZFBrP/OYCoaL85gxjooqyvnG8FS1ssZXkf9hGH870u0ZHf9f5aY37hmjFzRe8v5PPuCNySgcBgqFoCKyYLh7j3cU4DKqoxeBbuUzKZI2f3SUIzo5tkbwYZXIOKlMxA2UjuYBHjqa6YranbaTuefE8t3TezDrUs1YsNVkocDrMWXWuSAG0v3reefyfS2mdEafPgPK7l12oie4TDLWt+R9+rFUAEqAV9EBviYqK77W4Ysaj88p1k9IgnEj/ANFhWA8G+FaamOvQzWW0teBS4eU4vZqXCzrSxpp1qr3Vhl8KL7OIoXen5jsYrzydAibzLDzy8G6gllVZjf8Vu99cGNQtUELByzOePfz48H9V/V5fq+OBpWTCQxlP9h2uusOghx/Ax7O6jOxEvtMYhIOq58jg6cOE5UcJliICDc69dHaoxTPGSnQgSdlMgs81AkLbN+nQs55fAifPUWoSQaxR8i1aQJXH+KVX/1/B3wgIUEoF03cCyP78vsjaDXtAoGM7QbexHEGLxGoK342w7pUYcQI3Qw/8H0zzK6O6iwBJZVyKBa5FtMKBsKMU8qdeAeOVUz7D3sTgbCnQRJOOdFJPDtKrGZ5cBJMVILr2G9PydtLANri2ZYI3+7FXGPlWIKY2miEfDBTsodMuaD9qXllVtF7n62kmtGYv3Pu0kU5plNE4Dy2xm4pSfl/GWQOaPBqal5vruNd04zQ1EHdBU5zsULYMb8ZegiTcsHS+Okr1tJzxgZci0Y2HzQs3nKA36XhiD5hwUl1utPlx1geHlUKHP7+PpF+wgC7JT
 DMk9dDL5379emfvAByivZ12UMyXMvCLtMPhWTKxmZQk8YG5h7ouxJTd2MPHOd83iun43TkRT7TO4BXlnwrguCLpGpw5S1sBsUNc266MH187San/6248Gsjx+gz8Ln5tksS6o743LTEN9yMWPvR2SQ6bvv0b/eHEjp/a9DjDvYp06pOpVAYm65Q0Jdqrc7XYOlFlxG+4r68TzaAjB9JS7Y2TNd

The total_sector_nr calculation appears to have a typo:

-       stripe_nr + rbio->stripe_nsectors + sector_nr;
+       stripe_nr * rbio->stripe_nsectors + sector_nr;

I tested the patch as posted against the original v7.3-rc5 reproducer.
It still returned EIO from fdatasync, at offset 148971520 after 1632
writes.

After changing the addition to multiplication, the default-preallocation
test completed successfully twice. The fallocate=none control also
completed successfully. Kernel taint remained zero, all Btrfs device
error counters remained zero, and dmesg contained no Btrfs errors or
warnings.

regards
Bartosz Fenski

On 30/09/2026 03:11, Qu Wenruo wrote:
> [BUG]
> There is a bug report that fio can fail to sync the data on a degraded
> RAID56 mount:
>
>   # mkfs.btrfs -m raid1 -d raid5 -f $dev1 $dev2 $dev3
>   # mount $dev1 $mnt
>   # btrfs balance start -d $mnt
>   # umount $mnt
>   # btrfs dev scan -u $dev2
>   # wipefs -fa $dev2
>   # mount -o degraded $dev1 $mnt
>   # fio --name=degraded-write --directory=$mnt --rw=randwrite --fdatasync=4 \
> 		--bs=4k --size=512M --randrepeat=1
>
> The run will fail at fsync:
>
>   fio: io_u error on file /mnt/btrfs/degraded-write.0.0: Input/output error: datasync offset=142254080, buflen=0
>   fio: pid=2064, err=5/file:io_u.c:2008, func=io_u error, error=Input/output error
>
> [CAUSE]
> With extra debug output, it shows the problem pretty well:
>
>   rbio=2876243968 faila=0 sectornr=0
>   rbio=2876243968 error=0-15 csum=2 bio=15
>
> The first line shows the rbio's full stripe logical, and stripe/sector
> number when verify_one_sector() failed.
>
> The second line shows more detail about the rbio, the sector range [0, 16)
> is corrupted, which indicates the first data stripe is corrupted, matching
> the missing device.
>
> The important part is that the csum bitmap shows the data csum is only
> for sector number 2, meanwhile the failed verification is at sector
> number 0.
>
> This means we did the checksum verification even if no corresponding
> checksum is populated.
>
> [FIX]
> There is already a similar check at verify_bio_data_sectors(), but
> unfortunately there is no such check at verify_one_sector().
>
> Add the missing check to skip the csum verification if there is no
> corresponding data checksum.
>
> Reported-by: Bartosz Fenski <bartosz@fenski.pl>
> Link: https://lore.kernel.org/linux-btrfs/a72409af-45ef-45df-9970-2e38bcb22ea6@fenski.pl/
> Fixes: 7a3150723061 ("btrfs: raid56: do data csum verification during RMW cycle")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   fs/btrfs/raid56.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 8ec24dbb180f..38b48e53e11d 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -1889,6 +1889,8 @@ static int verify_one_sector(struct btrfs_raid_bio *rbio,
>   {
>   	struct btrfs_fs_info *fs_info = rbio->bioc->fs_info;
>   	phys_addr_t *paddrs;
> +	const unsigned int total_sector_nr =
> +		stripe_nr + rbio->stripe_nsectors + sector_nr;
>   	u8 csum_buf[BTRFS_CSUM_SIZE];
>   	u8 *csum_expected;
>   
> @@ -1898,6 +1900,11 @@ static int verify_one_sector(struct btrfs_raid_bio *rbio,
>   	/* No way to verify P/Q as they are not covered by data csum. */
>   	if (stripe_nr >= rbio->nr_data)
>   		return 0;
> +
> +	/* No data checksum for this sector. */
> +	if (!test_bit(total_sector_nr, rbio->csum_bitmap))
> +		return 0;
> +
>   	/*
>   	 * If we're rebuilding a read, we have to use pages from the
>   	 * bio list if possible.
> @@ -1908,9 +1915,7 @@ static int verify_one_sector(struct btrfs_raid_bio *rbio,
>   		paddrs = rbio_stripe_paddrs(rbio, stripe_nr, sector_nr);
>   	}
>   
> -	csum_expected = rbio->csum_buf +
> -			(stripe_nr * rbio->stripe_nsectors + sector_nr) *
> -			fs_info->csum_size;
> +	csum_expected = rbio->csum_buf + total_sector_nr * fs_info->csum_size;
>   	calculate_block_csum_paddrs(fs_info, paddrs, csum_buf);
>   	if (unlikely(memcmp(csum_buf, csum_expected, fs_info->csum_size) != 0))
>   		return -EIO;
