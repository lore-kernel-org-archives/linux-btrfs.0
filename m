From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Can't resize second device in RAID1
Date: Tue, 17 Jan 2012 11:22:31 -0500
Message-ID: <4F15A047.3080006@ubuntu.com>
References: <CADy=jfVZjRAE049OiD6VkoKkpzZh9e_=V62AvuVwxyHZyfuU1w@mail.gmail.com> <CADy=jfWbzq81CrhCFy+RVd8e7265XZgkqomwOOxYaKehSpzasQ@mail.gmail.com> <20120113231717.GB21769@carfax.org.uk> <CADy=jfU88LRMw4Jmk4O_n+URRQxN2EUpiZCZe7GVK_LHPShmZA@mail.gmail.com> <20120114144236.GA22603@attic.humilis.net> <CADy=jfV+-sT_9opMeUXxOF4zWxt7PTQOg_+bPL7o5vq66omcsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: sander@humilis.net, linux-btrfs@vger.kernel.org
To: "Marco L. Crociani" <marco.crociani@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CADy=jfV+-sT_9opMeUXxOF4zWxt7PTQOg_+bPL7o5vq66omcsA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I submitted some patches a few weeks ago to fix this so you specify
the device normally instead of looking up the internal devid and
passing it as an undocumented prefix to the size parameter.  Hopefully
they can get merged sometime soon.

On 1/14/2012 1:18 PM, Marco L. Crociani wrote:
>>> ./btrfs fi resize max /mnt/RootFS:2 ERROR: can't access to
>>> '/mnt/RootFS:2'
>> 
>> btrfs filesystem resize 2:max /mnt/RootFS
>> 
>> Sander
>> 
>> -- Humilis IT Services and Solutions http://www.humilis.net
> 
> Perfect, Thank you! I've written a section on: 
> http://btrfs.ipv5.de/index.php?title=UseCases
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPFaBGAAoJEJrBOlT6nu754+0H/jyk5yDLn5T4sYiPNGAFQyG+
SI47GsE3uD5pfQ0vve8YsDSburNbBzHTmsyWdn/YZE+TtocNTsj+Gj3m7bd/Flr8
u/dM/4htyyiAjEXJeRQqlnApFDh0hBeMZSF1qK9odhMd8h2FqOfon7mrafCjPzGY
R9FG1nTqXVmNBmdWQfTiRLnR5ErTBImd8Mo+zt9vbd5naR1Sxc9sUFk1BX4jP0lp
ZK66C7SPMdb7HnVROPR2TEFHweAjPjF1YMcFOkR4/no37jB+g5/+wlF0YuV4hnc0
BgC/5dZcxOP1R+nUNQ1xPZm7My+dlzVJaG9AqQC5IEKW7Lejn9HxJzgtZyTZ8hs=
=QpE2
-----END PGP SIGNATURE-----
