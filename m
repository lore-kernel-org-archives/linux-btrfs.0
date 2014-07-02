Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from michael.mail.tiscali.it ([213.205.33.246]:41025 "EHLO
	michael.mail.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaGBKg7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 06:36:59 -0400
Message-ID: <53B3E0C6.3030803@assyoma.it>
Date: Wed, 02 Jul 2014 12:36:54 +0200
From: Gionatan Danti <g.danti@assyoma.it>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Duncan <1i5t5.duncan@cox.net>, g.danti@assyoma.it
Subject: Re: Question about fallocate
References: <20140702014130.47a5ba75@ws>
In-Reply-To: <20140702014130.47a5ba75@ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> But how did you disable COW?  The nodatacow mount option?  Setting the
> NOCOW attribute on the file or parent-dir (chattr +C)?  Something else?
>
> Because there are caveats to both the mount option and the file
> attribute methods.
>

I used the nodatacow mount point. When doing the test, I had no other 
subvolume or snapshot.

> Other than that, I don't know, but it'd be interesting to see if the
> behavior replicates on a current kernel.
>

Yes, I'll try to replicate it on a 3.14.x based Fedora 20.

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
