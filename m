Received: from nt.romanrm.net (nt.romanrm.net [185.213.174.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508D04C92
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 00:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.213.174.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782691324; cv=none; b=T7YMDF+ZppBmymyvNALg7Z5Z0L06LiQ5BgxTsCkElArzZTsJwFZRnh8VWq4OkCHa47WdVuOvXC9kW+NNjbdIyWm3Dsdv9TazIEBQYNQou8/gtnwXQ7E9kuXIC//Hq3VEH+QpVaRlu+v0FROx+1dBVBJmN3U7Wr0e2IyCE3U7ufU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782691324; c=relaxed/simple;
	bh=zVeHGXtOJ5XmIYPRtxK+M7rNxokrAhnuoNtn0YQgxcU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ef0V6Sw27s2/lbgk9eoM2HEM2766lQ5thjX6PFaZm4m0YWCEnS+NCh+ocIkglM5HqvwWn+j+qKGpQauhcgyw9GMNm+6BPJKrxcexp9YLhA1zCyXp/eifREur5TdIbVoe19vtDLgnQ/b7MAUG6w+ze569M82RWAu0Oshm4jw57xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=185.213.174.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (umi.0.romanrm.net [IPv6:fd39:ade8:5a17:b555:7900:fcd:12a3:6181])
	by nt.romanrm.net (Postfix) with SMTP id 7A99B401C7;
	Sun, 28 Jun 2026 23:54:13 +0000 (UTC)
Date: Mon, 29 Jun 2026 04:54:11 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: shrink btrfs partition - recommended way?
Message-ID: <20260629045411.75f3d6d7@nvm>
In-Reply-To: <20260628233658.GA3404176@tik.uni-stuttgart.de>
References: <20260628233658.GA3404176@tik.uni-stuttgart.de>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 29 Jun 2026 01:36:58 +0200
Ulli Horlacher <framstag@rus.uni-stuttgart.de> wrote:

> 
> Is there a recommended way (or tool) to shrink a btrfs partition?
> 
> I have:
> 
> root@zoo:~# lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS /dev/sdc
> NAME    SIZE FSTYPE MOUNTPOINTS
> sdc     256G
> `-sdc1  256G btrfs  /LXC
> 
> root@zoo:~# df -Th /LXC
> Filesystem     Type   Size  Used Avail Use% Mounted on
> /dev/sdc1      btrfs  256G   19G  236G   8% /LXC
> 
> And want to shrink /dev/sdc1 to 200 GB
> 
> I know, I can use btrfs filesystem resize and afterwards use fdisk to
> delete /dev/sdc1, create a new smaller /dev/sdc1 and then add a new
> /dev/sdc2 
> BUT if make a calculation error with fdisk the btrfs filesystem will be
> damaged.
> gparted can do it all together in one step, but it needs X11, which I do
> not have on host zoo. I have only text console access, no X11.

I'd shrink it to like 180GB first, to avoid most chances of calculation and
GiB vs GB errors. As for shrinking the partition, 'cfdisk' has a resize
function. Then expand Btrfs to 'max'.

-- 
With respect,
Roman
