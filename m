From: Chris Samuel <chris@csamuel.org>
Subject: Re: mkfs.btrfs - error checking /dev/sda5 mount status
Date: Thu, 10 Feb 2011 14:09:17 +1100
Message-ID: <4D5356DD.8040501@csamuel.org>
References: <iiqphe$217$1@dough.gmane.org> <4D51A0D9.9000701@libero.it>	<iiscep$udg$1@dough.gmane.org> <4D52DC1E.2050302@libero.it> <iiusfk$lp4$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Lubos Kolouch <lubos.kolouch@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <iiusfk$lp4$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/02/11 07:12, Lubos Kolouch wrote:

> /dev/root / btrfs rw,noatime,compress,ssd 0 0

My memory of the strace showed that there was no /dev/root
when it tried to open it - can you confirm whether or not
that's the case please ?

cheers!
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
