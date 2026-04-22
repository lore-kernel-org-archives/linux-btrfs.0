Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DCB3659FF
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 17:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776877816; cv=none; b=C2MtvmYnb3RdAt0mCWdVUMgoONEDNzb/zOipKB/rHg/ZxlESZDqXWlRoVlYMUatJuEF0QlKuWdXa2eAmhQfcYOqv7DZpUFTnhAzqTBF836zFCx3RBoO3/JBOXhvSTirLD7QVWkn3prRzoAYMDx2oWptpg5H6fqh3FN8AzWio5M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776877816; c=relaxed/simple;
	bh=wo7Bpy4qHdwLngDOoKa8/LUxHKKvrrDXkziZTUHy01U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pvj7N1+/8CpbqM7x6Obedgm0VqnX18LWwFfKVLuX8pCimsT8CCaH+T9N2i9yfZu7jMssBN2nyx5iikysDddZ3K1CzKWNMjS6Sjdl8ADfF5JyR+O8XkhCTrKrcgb7fu8t5JKHlUGlqbi89kMRqMk5g1dzPouyFlOfCn7CR1U4nbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=CUm9pOFE; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="CUm9pOFE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UfxwHpcivqTaU0/D6etCPUZvI9y0/SPHOmy6Zf6ZigM=; b=CUm9pOFEy5EQhweg3nqb4ek9HB
	a5gFcK9MKYE5+YmG3Z6D93w+6bhd1CvMUpKN0IhiDRe3k55G2FWvZS4BAnlHbw/QryxRGSQ+GS7R8
	s0UHGpxK5KA9yEEEjyxKfLGs3FzGzXEEELYjiO2mkZmHX+5V12ONdgEXmkvOIrpYsxP7tdVivLSEE
	brVoBnS2Tzv+FRnjvX8YqN0I5zgig8G5tRnmr3n74usxYowPZEK/l8RyuqHX5VvnQNXIm6lwcfaXj
	X7WzNHtaA1MvSBclJxZWgeSpSNd2bTR0Fio02k6bbwf2o0zQXRsvhQhPGIcVA4e3uoxtqEX30/dnh
	5Azoak6Q==;
Received: from [24.6.49.44] (port=39446 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wFb5Y-00000007GgX-1ups by authid <merlins.org> with srv_auth_plain;
	Wed, 22 Apr 2026 10:10:12 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc_btrfs@merlins.org>)
	id 1wFb5W-00AF5I-31;
	Wed, 22 Apr 2026 10:10:10 -0700
Date: Wed, 22 Apr 2026 10:10:10 -0700
From: Marc MERLIN <marc_btrfs@merlins.org>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Deleted snapshots stay in squota, mayube because of bees?
Message-ID: <aekA8mS4hppTjbA-@merlins.org>
References: <aeA2c8V4FgCctUPG@merlins.org>
 <20260416012535.GB1065998@zen.localdomain>
 <aeEaqCJAWaWbz1vO@merlins.org>
 <20260416213632.GA1654609@zen.localdomain>
 <aeFY4uSTSIz4Ccat@merlins.org>
 <20260417215127.GA2310330@zen.localdomain>
 <aeK2QgUCefpVY4KX@merlins.org>
 <20260417231603.GA2376753@zen.localdomain>
 <aeLNxjmUGGhnW5ss@merlins.org>
 <20260422022627.GA1034721@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422022627.GA1034721@zen.localdomain>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc_btrfs@merlins.org

Hi Boris,

I noticed another issue, when I do a btrfs send to this volume
which was created cleanly from scratch with squota, if I have
an incomplete btrfs receive subvolume (copy failed half way),
when I delete it, it does from
<under deletion> to <squota space holder>.
You'll notice I have now two <squota space holder> which just so happen
to be 297.04MiB each.

I do run bees, so there is a very small chance bees took data from
debian64 and dupedd it against another subvolume and then can't delete
all the data, but in this example backup/debian64_kodi_ro.20260327_10:11:40
was last, so any duped data should have been duped against a previous
snapshot, and ideally not leave leftover squota data after deletion,
unless bees somehow is making those references the other way around
and the new copy becomes the master copy for squota?

But even then, it looks a bit weird that now I have two
0/263        297.04MiB    297.04MiB   <squota space holder>
0/269        287.84MiB    287.84MiB   <squota space holder>
of almost the same space

Is that still working as intended and I don't quite grasp how?

gargamel:/mnt/btrfs_pool2/backup# btrfs qgroup show .
Qgroupid    Referenced    Exclusive   Path 
--------    ----------    ---------   ---- 
0/5            1.61GiB      1.61GiB   <toplevel>
0/256         16.00KiB     16.00KiB   backup
0/258         16.00KiB     16.00KiB   backup-btrfssend
0/260          1.06GiB      1.06GiB   .beeshome
0/261         63.74GiB     63.74GiB   backup/win_kodi_ro.20260328_21:48:59
0/262        229.51GiB    229.51GiB   backup/ubuntu_kodi_ro.20260328_10:19:47
0/263        297.04MiB    297.04MiB   <squota space holder> <- this has been there for days
0/264        187.38GiB    187.38GiB   backup/0Notmachines_kodi_ro.20260325_20:08:49
0/266         10.37GiB     10.37GiB   backup/1Appliances_kodi_ro.20260325_23:22:32
0/268        294.27GiB    294.27GiB   backup/debian32_kodi_ro.20260325_23:43:06
0/269        295.74GiB    295.74GiB   backup/debian64_kodi_ro.20260327_10:11:40
gargamel:/mnt/btrfs_pool2/backup# btrfs subvolume delete debian64_kodi_ro.20260327_10:11:40/
Delete subvolume 269 (no-commit): '/mnt/btrfs_pool2/backup/debian64_kodi_ro.20260327_10:11:40'
gargamel:/mnt/btrfs_pool2/backup# btrfs qgroup show .
Qgroupid    Referenced    Exclusive   Path
--------    ----------    ---------   ----
0/5            1.61GiB      1.61GiB   <toplevel>
0/256         16.00KiB     16.00KiB   backup
0/258         16.00KiB     16.00KiB   backup-btrfssend
0/260          1.06GiB      1.06GiB   .beeshome
0/261         63.74GiB     63.74GiB   backup/win_kodi_ro.20260328_21:48:59
0/262        229.51GiB    229.51GiB   backup/ubuntu_kodi_ro.20260328_10:19:47
0/263        297.04MiB    297.04MiB   <squota space holder>
0/264        187.38GiB    187.38GiB   backup/0Notmachines_kodi_ro.20260325_20:08:49
0/266         10.37GiB     10.37GiB   backup/1Appliances_kodi_ro.20260325_23:22:32
0/268        294.27GiB    294.27GiB   backup/debian32_kodi_ro.20260325_23:43:06
0/269        295.74GiB    295.74GiB   <under deletion>
gargamel:/mnt/btrfs_pool2/backup# btrfs qgroup show .
Qgroupid    Referenced    Exclusive   Path
--------    ----------    ---------   ----
0/5            1.63GiB      1.63GiB   <toplevel>
0/256         16.00KiB     16.00KiB   backup
0/258         16.00KiB     16.00KiB   backup-btrfssend
0/260          1.06GiB      1.06GiB   .beeshome
0/261         63.74GiB     63.74GiB   backup/win_kodi_ro.20260328_21:48:59
0/262        229.51GiB    229.51GiB   backup/ubuntu_kodi_ro.20260328_10:19:47
0/263        297.04MiB    297.04MiB   <squota space holder>
0/264        187.38GiB    187.38GiB   backup/0Notmachines_kodi_ro.20260325_20:08:49
0/266         10.37GiB     10.37GiB   backup/1Appliances_kodi_ro.20260325_23:22:32
0/268        294.27GiB    294.27GiB   backup/debian32_kodi_ro.20260325_23:43:06
0/269        287.84MiB    287.84MiB   <squota space holder>
0/270        321.80GiB    321.80GiB   backup/debian64_kodi_ro.20260327_10:11:40

Thanks
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
