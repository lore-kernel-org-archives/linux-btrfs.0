Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bitfolk.com ([85.119.80.223]:57655 "EHLO mail.bitfolk.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbaHIOup (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Aug 2014 10:50:45 -0400
Received: from andy by mail.bitfolk.com with local (Exim 4.72)
	(envelope-from <andy@strugglers.net>)
	id 1XG7gk-0005hS-PY
	for linux-btrfs@vger.kernel.org; Sat, 09 Aug 2014 14:32:06 +0000
Date: Sat, 9 Aug 2014 14:32:06 +0000
From: Andy Smith <andy@strugglers.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: 40TB volume taking over 16 hours to mount, any ideas?
Message-ID: <20140809143206.GJ11855@bitfolk.com>
References: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com>
 <2242759.aOKEuU2TTR@xev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <2242759.aOKEuU2TTR@xev>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

On Sat, Aug 09, 2014 at 01:38:34PM +1000, Russell Coker wrote:
> On Fri, 8 Aug 2014 16:35:29 Jose Ildefonso Camargo Tolosa wrote:
> > Then, after reading here and there, decided to try to use a newer
> > kernel, tried 3.15.8.  Well, it is still mounting after ~16 hours, and
> > I got messages like these at first:
> 
> I recommend trying a 3.14 kernel.  I had ongoing problems with kernels before 
> 3.14 which included infinite loops in kernel space.  Based on reports on this 
> list I haven't been inclined to test 3.15 kernels.  But 3.14 has been working 
> well for me on many systems.

I'm in a similar position with a filesystem that won't mount except
read-only, but am already on 3.14 and am also wondering whether to
try a 3.16 kernel.

    https://bugzilla.kernel.org/show_bug.cgi?id=81981

Jose, maybe you could try -oro in the hope of at least getting back
to a read-only mount?

Cheers,
Andy

-- 
"I remember the first time I made love.  Perhaps it was not love exactly but I
 made it and it still works." — The League Against Tedium
