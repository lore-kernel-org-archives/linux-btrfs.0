Received: from altprdrgo002.altice.prod.cloud.openwave.ai (altprdrgo002.altice.prod.cloud.openwave.ai [66.179.105.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C9931F9A6
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2026 15:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.179.105.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786808838; cv=none; b=C5ndwipEag2jxzQxTIdzXLiEESEhTJXYlegVAQOYiU/OHQ4z6l5rchE5jtoZW82D5rMi3sDg0ncxvC1QaLvr18qP9jBABDmk3jTnCRr3pM4P5McTqfmaCRHWj4ibFvvsIkgQo12F5G0LBZ+nEUsVagSjAKyXFSHbtcS4ENcEop8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786808838; c=relaxed/simple;
	bh=83eCC1DxuA6b+hMHrpdSs4YL7HACs8kik9KGuLCBjLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/8KWpWhGpy6cjiWfn0Cg/lnMtlNlgj4/KMgSfQ1X7uiWpfzi7Lb7O1eKKzEZ+czmB2vAlXfvVkFmtRpMJSTDCDWv2nO8pmjX4HGwMima3q6GNzyCsWbz6X+DzaZeVV2TrYQ074WZWJ8TvyUTQAMADEMSVqJ+LyMyHwcfoMPSJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=optonline.net; spf=pass smtp.mailfrom=optonline.net; dkim=pass (2048-bit key) header.d=optonline.net header.i=@optonline.net header.b=s496Pbon; arc=none smtp.client-ip=66.179.105.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=optonline.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=optonline.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=optonline.net header.i=@optonline.net header.b="s496Pbon"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=optonline.net; s=dkim-002; t=1786808836; 
        bh=mBAr5IzshZCEUgX2RzQT16/nFWyRqNT03W5IpJrS5a4=;
        h=From:To:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version;
        b=s496Pbon3PHkK7IwO/4mzdwOKC3eTJlLq7yjSLvE4PGTHWoSjhbtnuhnm3bUQdyZAvyoriN1x0ZTMtMI8dhi6FhHzmFUwR6GLqkJuoCvXmHzi0NP9CggQA+++YBnzvR0lOOZ/hSlhS2JHyTPoVwFWpE1jCClBXCodXB5OojiGQqB2pl7Ml6uqNI69xNsTnq3f1VT1Y/dSlv3KnA06A6izwj8CbX3K1PmPO7q5vUmLaQTr/3YP9pkxkOyNzsxhTAywZqdePvKdzIURndPc2jzVmy7XRhgwpDwl9ybxma0n9X5Mr7aiJvwVkA2XNbOXrDceaVli7ptQcr/375JEnPCvA==
X-RG-VS-CS: clean
X-RG-VS-SC: 0
X-RG-VS: Clean
X-RG-Env-Sender: jamesowens@optimum.net
X-RG-Rigid: 6A806F1000046DFC
X-RazorGate-Vade: dmFkZTGX3LZi72Fa7wi4Wq9DwIpWLkDfzfF1yqx4GgNZzDy6ZND1YqZXN5Qb4cVW6qKofHZRfT4repQz8wd2VqZEuJD7qHGBILbhlakE5wQ7Z1QQQq1XoeEArA6k2POmSYrBlWqoqAmYS/12b4HG564TCvvIGioAJ/5TK0s/0LZp5MaPIcbG803PPzj8LZ1Au3gmdUfRI7sFxTCVElOeTbOqxSeFYurAzIo2IWcW3b5nFG8rQNZPLo95VSzAV2gLNI+e2k0peL930/zzLcnZBP4FJ9wacuAobrFR6kYfPIQ7UTu3FO+xZzRc9CP6SIvKVDAL+N/wqXIuNLAtJdxvKmUo5z9kMfzJ2NGFNZKrHtTqTksHxbryx28piwZU3gZD6a11mFu5foeQ/4i/Y/kitHVxnWId+gFwO8SsKarmDyU9e3q23Bd+Ky0vUV56e9SBYGZUteBt3TiAVoWEXi13Wdacz5+UXr9KBDOuhGot1BXHO19rjyodAXBY/fKxtxFXFwWS++KqhD94x9SlFSIQWo+4qEGXDAN5g5eOmOzqb/UTtqJ61DNQo0VsQwOR0LA8tS9rrf+rYT+FWYGW9YpWW0mcf7cQjR2kL1yqQ3nI0kOTIPOicV/9gJkDVzt6mWrn/8FdTSD2ZBVMC+vBgPEWJes8SpYuGIVIxbvNouSEHyJb2Kz/xg
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from jco-monster-ng.jcowens.net (68.197.170.124) by altprdrgo002.altice.prod.cloud.openwave.ai (authenticated as jamesowens)
        id 6A806F1000046DFC; Sat, 15 Aug 2026 11:47:14 -0400
From: "James C. Owens" <jamesowens@optonline.net>
To: wqu@suse.com
Cc: linux-btrfs@vger.kernel.org,
	dsterba@suse.com
Subject: Re: [PATCH] btrfs: scrub: report the failing sector's address, not the stripe base
Date: Sat, 15 Aug 2026 11:47:03 -0400
Message-ID: <20260815154703.166107-1-jamesowens@optonline.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <6e0c2009-04ff-4e64-a56f-6f0394da9686@suse.com>
References: <20260814162405.1434693-1-jamesowens@optonline.net> <6e0c2009-04ff-4e64-a56f-6f0394da9686@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, Aug 15, 2026 at 07:50:51AM +0930, Qu Wenruo wrote:
> The patch format doesn't looks correct.
> How did you generate the patch?

With plain diff(1), which is why it lacked the diffstat, the "diff --git"
header, the index line and the hunk context. Apologies for that; I don't
submit patches often and should have used git format-patch from the start.

v2 is regenerated with git format-patch and carries your Fixes: tag and
your Reviewed-by:

  https://lore.kernel.org/linux-btrfs/20260815153416.138869-1-jamesowens@optonline.net/

Sorry also for missing you on the Cc there.

Thanks,
James
