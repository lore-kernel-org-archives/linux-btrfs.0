Received: from phd-imap.ethz.ch (phd-imap.ethz.ch [129.132.80.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AB43A168C
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jul 2026 09:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.132.80.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784280046; cv=none; b=VFD5bcmnyeQshaEYukJW1y2TIPKJFO56ECU+VEAdlDQo2tkqqI6Z95X1wW6ZKUSlnbyOGve9dc8Q6QSoKoNQ8Fh/I/LF15yNd0AF+lf0lq2Yv/I+4ELbl7x6M7MYMZl+IJeBwSrDX8wSsQ/Jffqd+mpkymsR9EVxYDB9JpZRP7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784280046; c=relaxed/simple;
	bh=oE9uSzV9BgkuvGQ0GJ7pviyAwCohZa9ZhjXN8InCv3s=;
	h=MIME-Version:Date:From:To:Subject:Message-ID:Content-Type; b=ngatD+bSD6Y5iXgq7PKcbNJGccDcep7KmLOh474GdrSm19UanN07QkkrgkIOKNUnDS8hRBPGiRAryByjSQ6Xz7dktNcGGa1+/Fmuqoe8zu8v2BbTslHAqFoMgSiKYnUjJZ/ETku14ZWGlfYNTpLGaI/JTu9lwgzZvns3fwPAZSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=phys.ethz.ch; spf=pass smtp.mailfrom=phys.ethz.ch; dkim=pass (2048-bit key) header.d=phys.ethz.ch header.i=@phys.ethz.ch header.b=EXv0AuhL; arc=none smtp.client-ip=129.132.80.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=phys.ethz.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=phys.ethz.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=phys.ethz.ch header.i=@phys.ethz.ch header.b="EXv0AuhL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=phys.ethz.ch;
	s=2023; t=1784279727;
	bh=s71c/2XDHvt4hS0ax013MxvqxSff6OPLyGNsSusUlds=;
	h=Date:From:To:Subject:From;
	b=EXv0AuhLHQi6zJA3XG8pwU/8l6t+4Jmd51TByRGuGW6ISjI3OKvsB6ZkxSns/S+eC
	 MrQM6Dq8ruo7YINptIdpRQLxmB14Pyl7awNTGuE7c278p/znxnTsKiponm7ypDScft
	 lRlnWqXqImY/9/IiCWUf7D4bEtdLglOH+LqfCw5yna6JnCc4yeGGkKdKuJMDihNLL1
	 6T+ew+RwFvAkxaiMAvCukCD1bUrefmErfYXxZac0OgqXBhxN+J21BmKQoev+pkdp+8
	 XhP/kkuTuaXeFhTpf7is6B6zD9GOZsmDXmwGPGlvdRvMTPEI037HhcVtTkV7mrDp6M
	 FCXEveEH8Kfmg==
Received: from localhost (192-168-127-49.net4.ethz.ch [192.168.127.49])
	by phd-imap.ethz.ch (Postfix) with ESMTP id 4h1klg2vMpzKQ
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jul 2026 11:15:27 +0200 (CEST)
X-Virus-Scanned: Debian amavis at phys.ethz.ch
Received: from phd-mxin.ethz.ch ([192.168.127.53])
 by localhost (phd-mailscan.ethz.ch [192.168.127.49]) (amavis, port 10024)
 with LMTP id gqGbNQmzDbpJ for <linux-btrfs@vger.kernel.org>;
 Fri, 17 Jul 2026 11:15:27 +0200 (CEST)
Received: from webmail.phys.ethz.ch (192-168-127-51.net4.ethz.ch [192.168.127.51])
	by phd-mxin.ethz.ch (Postfix) with ESMTP id 4h1klg22f2zHm
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jul 2026 11:15:27 +0200 (CEST)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 17 Jul 2026 11:15:27 +0200
From: Stephan Mueller <stepmueller@phys.ethz.ch>
To: linux-btrfs@vger.kernel.org
Subject: pause device removal
Message-ID: <9a39301eb2542756e730be92c8b79ca9@phys.ethz.ch>
X-Sender: stepmueller@phys.ethz.ch
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit

Hello

we have 140T btrfs made from 10 LUNs. This file system is quite full 
with backups (and snapshots). Now we need to free one of the LUNs. A 
`btrfs device remove` is quite slow and also slows down nightly backups 
a lot.

So we run the device remove during the day and the backups during the 
night. On another btrfs this worked quite well. But here, the backups 
fill the device we want to remove and currently we are not moving 
anywhere regarding the usage the LUN.

Do you have an idea how can resolve this?
Can we somehow mark the device as unusable for new writes, or set it 
size, so that it is not written to?
Do you think it's safe to cgroup freeze the removal during the night?

   Have a nice day
   Stephan

Total devices 10 FS bytes used 144.08TiB
devid    1 size 0.00B used 6.81TiB path /dev/sdgb     <--- currently in 
removal
devid    3 size 1.88TiB used 546.00GiB path /dev/sdv
devid    5 size 20.00TiB used 17.16TiB path /dev/sdw
devid    6 size 20.00TiB used 17.16TiB path /dev/sdo
devid    7 size 20.00TiB used 17.16TiB path /dev/sdu
devid    8 size 20.00TiB used 17.16TiB path /dev/sdn
devid    9 size 20.00TiB used 17.16TiB path /dev/sdj
devid   10 size 20.00TiB used 17.16TiB path /dev/sdk
devid   11 size 20.00TiB used 17.16TiB path /dev/sdm
devid   12 size 20.00TiB used 17.16TiB path /dev/sdbc

-- 
Stephan Müller <stephan.mueller@phys.ethz.ch>
IT Services Group, HPT H 8
Physics Department, ETH Zurich
CH-8093 Zurich, Switzerland
