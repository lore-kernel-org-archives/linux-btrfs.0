Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43330 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab3EYMNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 May 2013 08:13:08 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Recommended settings for SSD
Date: Sat, 25 May 2013 14:13:07 +0200
Message-ID: <1751895.r3q1HmeO0C@merkaba>
In-Reply-To: <pan$1197$73f28aeb$cb95553f$36bb7307@cox.net>
References: <CAAeznTr3rsJWcFWKoagNrduXGzP2AWaXMKY0FO8te2Xpa7XiHw@mail.gmail.com> <CAAeznTo1uiZMgedoWfE-E0v=2vTWVkV0_k-9_+vVZ6YMFfjdRg@mail.gmail.com> <pan$1197$73f28aeb$cb95553f$36bb7307@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 25. Mai 2013, 03:58:12 schrieb Duncan:
> Leonidas Spyropoulos posted on Fri, 24 May 2013 23:38:17 +0100 as
> 
> excerpted:
> > On 24 May 2013 21:07, "cwillu" <cwillu@cwillu.com> wrote:
> >> No need to specify ssd, it's automatically detected.
> > 
> > I'm not so sure it did detected. When I manually set it I saw
> > significant improvement.
> 
> Without going back to check the wiki, IIRC it was there that the /sys
> paths it checks for that detection are listed.  Those paths are then
> based on what the drive itself claims.  If it claims to be rotating
> storage...

This is:

martin@merkaba:~> cat /sys/block/sda/queue/rotational 
0

> 
> It may also depend on the kernel version, etc, as I'm not sure when that
> auto-detection was added (tho for all I know it has been there awhile).
> 
> I do know my new SSDs (Corsair Neutrons, 256GB) are detected here, and
> the ssd mount option is thus not needed.  However, I'm running current
> v3.10-rcX-git kernels, tho I'm a few days behind ATM as I'm still working
> on switching over to the SSDs ATM and am having to do some reconfiguring
> to get there.

And can be verified by:

martin@merkaba:~> grep ssd /proc/mounts
/dev/mapper/merkaba-debian / btrfs rw,noatime,compress=lzo,ssd,space_cache 0 0
/dev/mapper/merkaba-debian /mnt/debian-zeit btrfs 
rw,noatime,compress=lzo,ssd,space_cache 0 0
/dev/mapper/merkaba-home /home btrfs rw,noatime,compress=lzo,ssd,space_cache 0 
0
/dev/mapper/merkaba-home /mnt/home-zeit btrfs 
rw,noatime,compress=lzo,ssd,space_cache 0 0
martin@merkaba:~> grep ssd /etc/fstab
martin@merkaba:~#1>

> Meanwhile, what about the discard option?  As I'm still setting up on the
> SSDs as well as btrfs here, I haven't had a chance to decide whether I
> want that, or would rather setup fstrim as a cron job, or what.  But
> that's the other big question for SSD.

I just use fstrim once in a while.

The Intel SSD 320 still claims it is new here:

merkaba:~> smartctl -a /dev/sda | grep -i wear
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       
-       2203907
233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       
-       0

We had a discussion on debian-user-german, where one user has an Intel SSD 
with media wear out indicator down to 98 I think.

The SSD is in use for about 2 years. I left about 25 GiB free of the 300 GB it 
has.

merkaba:~> smartctl -a /dev/sda | grep Host
225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       
-       261260
227 Workld_Host_Reads_Perc  0x0032   100   100   000    Old_age   Always       
-       49
241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       
-       261260
242 Host_Reads_32MiB        0x0032   100   100   000    Old_age   Always       
-       559520

So thats 261260 * 32 MiB = 8360320 MiB = 8164,375 GiB = about 8 TiB writes in 
total.

Intel claims a useful life of 5 years with 20 GB of host writes per day. For 2 
years thats 365*20 = 7300 GB. So it seems that I am exceeding this a bit.

Strange, last time I looked it was way under the specified limit. KDE Nepomuk / 
Akonadi stuff? Switch of /home to BTRFS? I don´t know. What I know that Akonadi 
/ KDEPIM has gone wild once and wrote 450 GB in a row until I stopped it doing 
that manually.

Anyway, it seems this SSD is still good to go. Erase fail count has not gotten 
higher:

merkaba:~> smartctl -a /dev/sda | grep Erase
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       
-       169

It went up from zero to 169 at some time but stayed there since then.

Also according to some other Intel PDF Intel recommends to replace the SSD 
when Media Wearout Indicitator reaches 1. This SSD is far from it at the 
moment. But I don´t know who quickly that indicator can raise.

> Here, I'm actually partitioning for near 100% over-provisioning, (120-ish
> GiB of partitions on the 238GiB/256GB drives, so I suspect actually
> running with discard as a mount option won't be such a big deal and will
> likely only cut write performance as I head toward stable-state, since
> the drive should have plenty of trimmed space to work with in any case
> due to the over-provisioning.  But I suspect it could be of benefit to
> those much closer to 0% over-provisioning than to my near 100%.

100% overprovisioning is a lot. There is a PDF from Intel where 20% was 
beneficial and 40% even more so, but I think much more really isn´t need. But 
in case you don´t need the space for something, hey, why not?

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
