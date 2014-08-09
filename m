Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:35953 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaHIDik (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Aug 2014 23:38:40 -0400
From: Russell Coker <russell@coker.com.au>
To: Jose Ildefonso Camargo Tolosa <ildefonso.camargo@gmail.com>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 40TB volume taking over 16 hours to mount, any ideas?
Date: Sat, 09 Aug 2014 13:38:34 +1000
Message-ID: <2242759.aOKEuU2TTR@xev>
In-Reply-To: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com>
References: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 8 Aug 2014 16:35:29 Jose Ildefonso Camargo Tolosa wrote:
> uname -a
> Linux server1 3.15.8-031508-generic #201407311933 SMP Thu Jul 31
> 23:34:33 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
> 
> The complete story:
> 
> The filesystem was created on Ubuntu 12.04, running kernel 3.11.
> mount options included compress=zlib .
> 
> After having some issues with it, specifically that it would mount
> itself read-only, and would then be "stuck" while trying to mount it
> again, we decided to upgrade 14.04, kernel 3.13, and 3.12 btrfs tools.

[...]

> Then, after reading here and there, decided to try to use a newer
> kernel, tried 3.15.8.  Well, it is still mounting after ~16 hours, and
> I got messages like these at first:

I recommend trying a 3.14 kernel.  I had ongoing problems with kernels before 
3.14 which included infinite loops in kernel space.  Based on reports on this 
list I haven't been inclined to test 3.15 kernels.  But 3.14 has been working 
well for me on many systems.

Trying 3.14 can't hurt.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

