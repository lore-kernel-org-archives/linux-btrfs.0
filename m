Received: from aarghimedes.fi (unknown [92.223.105.234])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32FCF383C9F
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Jul 2026 09:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=92.223.105.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784365816; cv=none; b=slz4Mpo47J1PsRP8hrBdl9BsOlrBq85Zu6GvX3cqW4O09VARD3ZwrKRAeNQeZ/XVeTKwGfigpZQ31vgGog7Mvj+3y1CYrgYNyXLdMP/ZKj8IPaq63gXxrmlsTlpt8wOhfeatDAOX26XjzZuILAIldaEvApLfn1vSf5JSDSFoZxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784365816; c=relaxed/simple;
	bh=2LmZBUmEFCPJF83hYsEYd0PBtTCJpjtTnbV6y7Yfunc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gU1gaeWTEgY1V0T1Prm81AQF1M2d+E5YFxX7hR/rrkPJLXFVQ6L8yGqktSz2bdyeLEs9C6RN2WUkeP584QVsFC/dKUxSnRlGgKjCgisdTXjngQr3fHOZzlTCNoltJhTDRyE40lKhvWVxohfkCV8DXI3Zp0PorDYDlk7HtMxxWik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aarghimedes.fi; spf=pass smtp.mailfrom=aarghimedes.fi; dkim=pass (2048-bit key) header.d=aarghimedes.fi header.i=@aarghimedes.fi header.b=qJHwMK4W; arc=none smtp.client-ip=92.223.105.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aarghimedes.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aarghimedes.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aarghimedes.fi header.i=@aarghimedes.fi header.b="qJHwMK4W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aarghimedes.fi;
	s=default; t=1784365299;
	bh=2LmZBUmEFCPJF83hYsEYd0PBtTCJpjtTnbV6y7Yfunc=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=qJHwMK4Wk2IfBBp5XgKSSU1cHAa7cQYrFm3u5RfFPR6SP8p3s361GQbct7ejft//B
	 38+A64siGMDev687OEgc3wz3zzvNXg9UnuGbDh1YHsuQuaMjYCDbdfj9AOb+Uhl+xA
	 INMHKa9j2eWESYfJxELJmvtkaOg1/oWXYLyQvmt6c5vcK86b8FgC0sm4n54+mID3MV
	 q/MRlYNoG9XI3XSv3HMvG+9NMKmT6/zj8uNbRB++O6w5d5Dnd44/ed7UCuJOUtbAit
	 UNWl2cL9bGHkUqaHypKhFK6QLGqZIoGPs7VXhxDGBEbIOBxVXGbJ8ygvob6tEUh+yx
	 LzT2POnYyYmZg==
Received: from [192.168.122.149] (79-134-115-245.cust.suomicom.net [79.134.115.245])
	by aarghimedes.fi (Postfix) with ESMTPSA id 4880520354;
	Sat, 18 Jul 2026 12:01:39 +0300 (EEST)
Message-ID: <0331d608-a7e8-40ea-ae75-4f3e407c2473@aarghimedes.fi>
Date: Sat, 18 Jul 2026 12:01:38 +0300
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: pause device removal
To: Stephan Mueller <stepmueller@phys.ethz.ch>, linux-btrfs@vger.kernel.org
References: <9a39301eb2542756e730be92c8b79ca9@phys.ethz.ch>
From: Jukka Larja <roskakori@aarghimedes.fi>
In-Reply-To: <9a39301eb2542756e730be92c8b79ca9@phys.ethz.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Stephan Mueller kirjoitti 17.7.2026 klo 12.15:

> we have 140T btrfs made from 10 LUNs. This file system is quite full with 
> backups (and snapshots). Now we need to free one of the LUNs. A `btrfs 
> device remove` is quite slow and also slows down nightly backups a lot.
> 
> So we run the device remove during the day and the backups during the night. 
> On another btrfs this worked quite well. But here, the backups fill the 
> device we want to remove and currently we are not moving anywhere regarding 
> the usage the LUN.

You can use btrfs device resize to incrementally decrease the device size, 
then finally remove it with normal delete.

Like so: btrfs fi resize 1:-100G path-to-device

This will resize devid 1 100 gigabytes smaller. It will be a somewhat slower 
process than just device delete, but not hugely so (in my experience anyway).

-- 
      ...Elämälle vierasta toimintaa...
     Jukka Larja, Roskakori@aarghimedes.fi
