Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40945 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbaITNmK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Sep 2014 09:42:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XVKvP-0004fn-C1
	for linux-btrfs@vger.kernel.org; Sat, 20 Sep 2014 15:42:07 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Sep 2014 15:42:07 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Sep 2014 15:42:07 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Performance Issues
Date: Sat, 20 Sep 2014 14:41:55 +0100
Message-ID: <lvk073$56j$1@ger.gmane.org>
References: <1411129114.1811.7.camel@zarniwoop.blob> <pan.2014.09.19.13.51.22@googlemail.com> <1678306.dObPo7E7s7@fb07-iapwap2>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <1678306.dObPo7E7s7@fb07-iapwap2>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 20/09/14 09:23, Marc Dietrich wrote:
> Am Freitag, 19. September 2014, 13:51:22 schrieb Holger
> Hoffstätte:
>> 
>> On Fri, 19 Sep 2014 13:18:34 +0100, Rob Spanton wrote:
>> 
>>> I have a particularly uncomplicated setup (a desktop PC with a
>>> hard disk) and I'm seeing particularly slow performance from
>>> btrfs.  A `git status` in the linux source tree takes about 46
>>> seconds after dropping caches, whereas on other machines using
>>> ext4 this takes about 13s.  My mail client (evolution) also
>>> seems to perform particularly poorly on this setup, and my
>>> hunch is that it's spending a lot of time waiting on the
>>> filesystem.
>> 
>> This is - unfortunately - a particular btrfs
>> oddity/characteristic/flaw, whatever you want to call it. git
>> relies a lot on fast stat() calls, and those seem to be
>> particularly slow with btrfs esp. on rotational media. I have the
>> same problem with rsync on a freshly mounted volume; it gets fast
>> (quite so!) after the first run.
> 
> my favorite benchmark is "ls -l /usr/bin":
> 
> ext4:     0.934s btrfs:   21.814s


So... On my old low power slow Atom SSD ext4 system:

time ls -l /usr/bin

real    0m0.369s

user    0m0.048s
sys     0m0.128s

Repeated:

real    0m0.107s

user    0m0.040s
sys     0m0.044s

and that is for:

# ls -l /usr/bin | wc
   1384   13135   88972


On a comparatively super dual core Athlon64 SSD btrfs three disk btrfs
raid1 system:

real    0m0.103s

user    0m0.004s
sys     0m0.040s

Repeated:

real    0m0.027s

user    0m0.008s
sys     0m0.012s

For:

# ls -l /usr/bin | wc
   1449   13534   89024


And on an identical comparatively super dual core Athlon64 HDD
'spinning rust' btrfs two disk btrfs raid1 system:

real    0m0.101s

user    0m0.008s
sys     0m0.020s

Repeated:

real    0m0.020s

user    0m0.004s
sys     0m0.012s

For:

# ls -l /usr/bin | wc
   1161   10994   79350


So, no untoward concerns there.

Marc:

You on something really ancient and hopelessly fragmented into oblivion?



> also mounting large partitons (several 100Gs) takes lot of time on
> btrfs.

I've noticed that also for some 16TB btrfs raid1 mounts, btrfs is not
as fast as mounting ext4 but then again all very much faster than
mounting ext4 when a fsck count is tripped!...

So, nothing untoward there.


For my usage, controlling fragmentation and having some automatic
mechanism to deal with pathological fragmentation with such as sqlite
files are greater concerns!

(Yes, there is the manual fix of NOCOW... I also put such horrors into
tmpfs and snapshot that... All well and good but all unnecessary admin
tasks!)


Regards,
Martin


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlQdhBwACgkQ+sI3Ds7h07f/VwCgkHPjrIkBkWh5zrKwvN7fXalZ
LWcAoIbLFEoc7iTNLzgSChNvnYatIkuZ
=YlDI
-----END PGP SIGNATURE-----

