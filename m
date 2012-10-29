Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:39734 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932658Ab2J2RzC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 13:55:02 -0400
Message-ID: <508EC320.6060907@inwind.it>
Date: Mon, 29 Oct 2012 18:55:44 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: add btrfs-show-super tool
References: <1350631087-1169-1-git-send-email-sbehrens@giantdisaster.de> <5086F3C4.50804@gmail.com> <508E61D4.1020809@giantdisaster.de>
In-Reply-To: <508E61D4.1020809@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2012-10-29 12:00, Stefan Behrens wrote:
> On Tue, 23 Oct 2012 21:45:08 +0200, Goffredo Baroncelli wrote:
>> On 2012-10-19 09:18, Stefan Behrens wrote:
>>> Just a small program to print the fields of a super block.
>>> 
>>> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
[...]
>> 
> 
> Hi Goffredo,
> 
> All your comments are correct and are good suggestions for
> improvements. Thank you!
> 
> But I am not going to enhance this tool beyond to its current
> rudimental state since I'm lazy and it works for me :)
> 
> Such a low-level debug tool is not a candidate to ever be added to
> the btrfs-progs IMO. Posting the sources to the mailing list was
> just with the goal to use the Internet to create another backup of
> the sources :)

I think that it would be a great debug tool. Can I update your patch
with my improvements ?

G.Baroncelli

> 
> Regards, Stefan .
> 


- -- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJQjsMgAAoJEA7amzeLguC1p8kQAMQ2H8B3NT8l9DDo3HfQL5bq
XKs8K3GUyYyl0gNYmrTtNwyHDnPffcz5FTTyIqBKXaiHmiMpCVDU6tKg5lD01ycP
61E39Zt6e2A0RK7iLW6QxXvsmx7yobqW7IMGvrZB6Kdnm8GEJ2Qhk4Xwx2yWmkFl
k9cRrp2hdKNaJcheA+DtJm2HaJGj/9vLBSPq6e5fLEcn+alsQHgzp1+VGvwW7X5E
OdoRlg2lRwG762mTC6Zh+W9+ArFIpBE+JGMSD9j06vH/SsnblcH5nPa5t0mVL0tQ
jhrUra8I6L4Nz9ag0w40QlyHJdjflywTM5AcYoRSphHHemZzx1Po7pv/VplVlWGc
/98merp0PPiaTR+0vzqq4bgw+kajSWT0PgKd9O+nLcSNa4DoJQKMct470r93KqKM
lBVa8/6/HL5JEJk3S+wFZwJOriGZdEFVAi/V2fqpufEVi+aBU3buyO0QffBW3/Wu
uP23kc57sPnhVt+4Zivmc2NyuiZ6EKSgzZEJSS+uWR87/PM80bp68g7Zt6Pa5yO4
E8QNkmGPKFMhlXTagq2R/+iyC9WUI4gKetAlnT5TTZ7gP6utIzS80buJ005CvATv
BWw+R2HgmIMUb9Bb0zzYMgsLXCypxx2uYHraWGPY3VpfcntJKBi+uGbEuBm4EM5q
PwTRjlBlGIgtCOixLQFj
=ERTv
-----END PGP SIGNATURE-----
