Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from michael.mail.tiscali.it ([213.205.33.246]:56858 "EHLO
	michael.mail.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbaGBOEb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 10:04:31 -0400
Message-ID: <53B4116D.9090504@assyoma.it>
Date: Wed, 02 Jul 2014 16:04:29 +0200
From: Gionatan Danti <g.danti@assyoma.it>
MIME-Version: 1.0
To: Maurizio Lombardi <mlombard@redhat.com>, linux-btrfs@vger.kernel.org
CC: Duncan <1i5t5.duncan@cox.net>, g.danti@assyoma.it
Subject: Re: Question about fallocate
References: <20140702014130.47a5ba75@ws> <53B3E0C6.3030803@assyoma.it> <53B3E471.2010101@redhat.com>
In-Reply-To: <53B3E471.2010101@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> I am unable to reproduce the problem on kernel version 3.16.0-rc2
> using nodatacow.

I all,
I can confirm that with Fedora 20 x86_64 (kernel 3.14.9-200.fc20.x86_64) 
the problem do not occour: using the nodatacow option leads to 
un-fragmented file.

Sorry for the noise.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
