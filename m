Received: from nt.romanrm.net (nt.romanrm.net [185.213.174.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB223D4114
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 12:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.213.174.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777035563; cv=none; b=UdjK2H8gniZhJ3knJ0AgAcTJ3+ccnj8rJxgkM2yRgT47gmyyF0smB8OxqqKbpI3ctXq9oPSVeZPXjio9RlcO/PPZeraZxH5jhd1gciNqio0B4BChV8f13hyJfRM9E6Tbp58zxCuE36phwiEMPuCUKF18LUbvRg6cUCLuwqILwSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777035563; c=relaxed/simple;
	bh=XNj7ywd8KstlrVDj+0uyABWLf1EeBU5AeFwuhKY/PMk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ppFTYAKy2E1vTB8dqfJz3Y4KnWQdtulrpCZOyPLiwgYFrUVVCI9cB8BXw17R8GLncmjEdZZVL3cEtyH1QdqaT88sJWu1dFS/PNblBKlzxFWJQ5QucuoJIaUftwd1HZu4f91HNtuWj6fudc8EJ+DZw/Ab95/TyJcsA615XeVoTWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=185.213.174.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (umi.0.romanrm.net [IPv6:fd39:ade8:5a17:b555:7900:fcd:12a3:6181])
	by nt.romanrm.net (Postfix) with SMTP id 5BF0643ABD;
	Fri, 24 Apr 2026 12:49:06 +0000 (UTC)
Date: Fri, 24 Apr 2026 17:49:04 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Fixing a corrupted file system
Message-ID: <20260424174904.385e875f@nvm>
In-Reply-To: <20260424082300.GA361238@tik.uni-stuttgart.de>
References: <8c8e2466574b29ba1da29c325a108824c8373a85.camel@infradead.org>
	<fc202c52-cb3e-40b2-a80a-6ffda886f76b@suse.com>
	<571fb6a8-d4e7-42ed-9f19-22962163918d@app.fastmail.com>
	<87d1aca.ae41f579.19d4f977d95@tnonline.net>
	<20260424082300.GA361238@tik.uni-stuttgart.de>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 24 Apr 2026 10:23:00 +0200
Ulli Horlacher <framstag@rus.uni-stuttgart.de> wrote:

> root@moep:~# btrfs filesystem df /home
> Data, single: total=95.01GiB, used=54.27GiB
> System, single: total=32.00MiB, used=16.00KiB
> Metadata, single: total=1.00GiB, used=293.70MiB
> GlobalReserve, single: total=80.53MiB, used=0.00B
> 
> (How) can I convert /home to DUP for System and Metadata?
> (/ looks good)
> 

See https://btrfs.readthedocs.io/en/latest/Balance.html

  btrfs balance start -mprofiles=single -mconvert=dup /home

-- 
With respect,
Roman
