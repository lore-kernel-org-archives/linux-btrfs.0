From: Chris Samuel <chris@csamuel.org>
Subject: Re: BUG while writing to USB btrfs filesystem
Date: Mon, 31 Jan 2011 14:35:03 +1100
Message-ID: <4D462DE7.7050502@csamuel.org>
References: <AANLkTimjuO=RcVciFCo5MKPnVArvXBLnhs2taS5cOw6f@mail.gmail.com>	<AANLkTim6a_xv7gf-OHbhtV75eJesCF4gLDB-aHxkM-PX@mail.gmail.com>	<AANLkTim_+yfC4i21uu65eaEapjwdc6X2yV9bunwXezOx@mail.gmail.com>	<4D46250D.2090403@csamuel.org> <AANLkTinFq=EfJDU6EUTGN6J9rP2aw849o+KvGV_C-L4G@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinFq=EfJDU6EUTGN6J9rP2aw849o+KvGV_C-L4G@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 31/01/11 14:11, cwillu wrote:

> There's a bunch of places it could be (any ret = foo
> followed by a break will exit with that ret rather
> than oops).

Ahh, thanks for that, I plead being a sysadmin rather than
a programmer.. ;-)

-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
