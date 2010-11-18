From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: SI units
Date: 18 Nov 2010 14:53:00 +0100
Message-ID: <Ba6eWBnD1uB@helmut.hullen.de>
References: <20101118132658.GA27661@vlad.carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101118132658.GA27661@vlad.carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 18.11.10:

>> when I invoke
>>
>>         btrfs filesystem show
>>
>> then it shows the size of my Terabyte disks in TiByte but tells
>> "TB". It's a difference of about 10% - either there should be a
>> switch like in "df" (option -H or --si), or "TB" should be changed
>> to "TiB" (the same with GiB, MiB etc.)

>    I posted patches[1] to do just that, a few weeks ago.

I've just compiled btrfs from git (20101117) - at least this patch isn't  
included.

  git clone git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git

as recommended in

  https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories

Do I use an antique version?

Viele Gruesse!
Helmut
