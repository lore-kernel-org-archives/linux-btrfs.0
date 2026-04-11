Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0046E3921CE
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Apr 2026 16:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775924581; cv=none; b=GiCmNrbk3dPAEYAIekpRipuY2Ou6HDGeZZUzKIAJDpnf2jdUi5dPFowWv0b3j0epy2VjDN37+OCSWZSgzysHSspfkTglrZRG0goBsiLNqOuRznkqUwaf9SGcP4gH2WKtn3kpkm1haeulsNyyjPiL4vOau93cAdDi0MgRZfH/lnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775924581; c=relaxed/simple;
	bh=HGqOv6qMPOZ3EPpIFipLDKsrb5ZCIS4wILFeWOd5BtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=VrYlqUKO8clwY8BSdl5p4A5rN3nxSozJDzMXz/cQhh2GIyeaVhV5u3CJRxd1JAmk2f6ygre39VGScu1vqJnukTjLVcZM8KSiPqUv+XMmtfQnElGpthOwcOh+sBaFn1sZtgNr9tLDnKb6vNcmLyWyBNJ9aUonTzD5Sdalnz7qFgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=fTy1HNRg; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="fTy1HNRg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:
	To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=n/sQF5BwzXieaJMShrrq/hf6UItGudBeKs0xKQobkic=; b=fTy1HNRgO9FLXlTtrjl8gJVkHW
	G/NKHLSRjallwMgT6jTFYofCGl9zCxH5oZ2F7aons9bnrdHHaOmKkme0Q9whQXzRIN+CEmO/SdRtY
	0AeXKv5cp/h9AGOsqn8Q0vbo0nMgd+k8eeO5SB7fS3ePWgfLioIjY8R7LOkS12388zM2WhiHCGbFS
	nXr4dIYjl+lI6l6QTymmOmvfRgJ0H+HMg2KKXxXPjpZxS3JifQGyZ8Wwcvy1hLfeqU6vqOrNhvVBe
	WBIzx8xCMj2uFPKL2TNSPawqVrFJ+fM6eatfI9YG2Q11SR7AyofRDjE+b8RRw4Wtpi2rJWV145Jrl
	vI5qvjeQ==;
Received: from [24.6.49.44] (port=44888 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wBb6h-0000000HGfI-21fB by authid <merlins.org> with srv_auth_plain;
	Sat, 11 Apr 2026 09:22:51 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc_btrfs@merlins.org>)
	id 1wBb6f-001s43-3C;
	Sat, 11 Apr 2026 09:22:49 -0700
Date: Sat, 11 Apr 2026 09:22:49 -0700
From: Marc MERLIN <marc_btrfs@merlins.org>
To: Roman Mamedov <rm@romanrm.net>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Boris Burkov <boris@bur.io>,
	Josef Bacik <josef@toxicpanda.com>, QuWenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@kernel.org>,
	Chris Murphy <lists@colorremedies.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	Su Yue <Damenly_Su@gmx.com>
Subject: Re: BTRFS discard crash: failed to run delayed ref for logical
 15506102321152 num_bytes 16384 type 182 action 2 ref_mod 1: -2 6.11.2)
Message-ID: <adp1WXwBWt2HjYj2@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03e3077a-28a4-4e68-af01-940eed58689e@gmx.com>
 <20260411170453.7bfe9b1e@nvm>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc_btrfs@merlins.org

Thanks both for the answers.
> didn't capture the initial "crash". So it might be just a coincidence, or it
> might be not. And like Mr. Qu, I am also skeptical of the AI fantasies in this
> case.
> 
> Be aware of the write hole issue when running Btrfs on top of a multi-device
> mdraid. In case of a system crash, some devices might have stripes written and
> synced to disk, and others not. This is can easily lead Btrfs into the
> infamous "parent transid verify failed" state, from which there's no good way
> out.

1) there was no system crash or power off that I can remember, at least
not recently.
2) I do have all the logs from the start, here they are: https://pastebin.com/7HmQwy3n
3) AI may have been wrong about linking me enabling trim to the crash
but they sure happened a few minutes apart. Could have been coincidence.
4) write hole: I do have md5 "Intent Bitmap : Internal" which indeed
prioritizes rebuild over fixing the write hole (mdadm can't do both,
sadly). I'm honestly sad that mdadm does not allow PPL (closing write
hole and intent bitmap for reasonable rebuild times)
5) the mdadm layer does not help, I would love to use built in btrfs
raid5 but last info I read still says it also has write hole or other
issues and can't really ever be production ready
5) RST is supposed to fix this but https://btrfs.readthedocs.io/en/latest/Status.html
says it's not ready, and why I asked about status recently, no answer
yet: https://yhbt.net/lore/linux-btrfs/adbgT-3VINfJNctk@merlins.org/#r

So raid5 and btrfs are still problematic :-/

On Sat, Apr 11, 2026 at 02:17:24PM +0930, Qu Wenruo wrote:
> Please try skip_balance to see if the fs can be mounted, then cancel the
> relocation.
 
I tried many mounts with skip_balance, they all still crashed.
You can find them all in https://pastebin.com/7HmQwy3n

> Then re-run btrfs check so we do not have balance complicating the
> situation.
 
My first one crashed due to OOM, I added 64GB swap and am trying again.

> > btrfstune --convert-from-block-group-tree /dev/mapper/crypt_bcache0
> 
> Please do not do whatever writes to the fs until you know why you should do
> that.
> And in this case, this will only make things worse.

Sequence of mount commands:
mount -t btrfs -o ro,nologreplay,skip_balance,clear_cache /dev/mapper/crypt_bcache0 /mnt/btrfs_bigbackup
umount /mnt/btrfs_bigbackup
=> worked, but ro

mount -t btrfs -o ro,nologreplay,skip_balance,clear_cache /dev/mapper/crypt_bcache0 /mnt/btrfs_bigbackup/
mount -o remount,rw,skip_balance /mnt/btrfs_bigbackup/
umount /mnt/btrfs_bigbackup/
=> Could not remount with skip_balance

all of these failed and caused the mounts in https://pastebin.com/7HmQwy3n
mount -t btrfs -o nologreplay,skip_balance,clear_cache /dev/mapper/crypt_bcache0 /mnt/btrfs_bigbackup/
mount -t btrfs -o skip_balance,clear_cache /dev/mapper/crypt_bcache0 /mnt/btrfs_bigbackup/
mount -t btrfs -o skip_balance,usebackuproot /dev/mapper/crypt_bcache0 /mnt/btrfs_bigbackup/
mount -t btrfs -o skip_balance /dev/mapper/crypt_bcache0 /mnt/btrfs_bigbackup/
mount -t btrfs -o rw,skip_balance,space_cache=v2,clear_cache /dev/mapper/crypt_bcache0 /mnt/btrfs_bigbackup

Once I dropped the cache (clear_cache), I was forced to downgrade
with --convert-from-block-group-tree 

> Now I do not even know if this is the original problem or something
> introduced by your writes.
 
Hopefully https://pastebin.com/7HmQwy3n shows the original issue
 
> Next time, please do not do whatever crazy/stupid things unless *YOU* know
> the reason.

I'm in the middle of a maintenance, I don't have a support contract with
you the few people who know who to read this, and to be honest I have
found pretty much no good debug info or guide on the net.
Even looking for the status of RST and how usable, it is, or not, I
found nothing on the official pages, and when I wrote on this list to
ask, I got 0 reply.

So I'm not saying it's great or smart to use an LLM, but if there is no
easily findable (or any) information on how to debug all those things
without reading/knowing the kernel code, what is the recommended path
for an end user?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
