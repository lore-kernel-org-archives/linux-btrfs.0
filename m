From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: snapper for Ubuntu? (WAS: btrfs auto snapshot)
Date: Tue, 10 Apr 2012 20:48:04 +0700
Message-ID: <CAG1y0seZqb+KkSA8Ae0cSfoGWCfBFnPotCM3FUs4q9fND5XjXw@mail.gmail.com>
References: <CAG1y0sdzOXhWowTiBomc6CDEVGJdpJy983P5suQfFC_-NmnYtQ@mail.gmail.com>
	<20120410114623.GA24057@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Arvin Schnell <aschnell@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120410114623.GA24057@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 10, 2012 at 6:46 PM, Arvin Schnell <aschnell@suse.de> wrote:
> On Mon, Apr 09, 2012 at 08:18:45AM +0700, Fajar A. Nugraha wrote:
>> I noticed that openSUSE buildservice now provides debs for ubuntu as
>> well. I can't seem to find a way to add it to apt source list though,
>> using the usual line
>>
>> deb uri distribution [component1] ....
>
> You can use these commands:
>
> echo 'deb http://download.opensuse.org/repositories/filesystems:/snapper/Debian_6.0/ /' >> /etc/apt/sources.list

I didn't know you could use that format :D Just tested it, and it
works, although the command I use is

echo 'deb http://download.opensuse.org/repositories/filesystems:/snapper/Debian_6.0/
/' | sudo tee /etc/apt/sources.list.d/opensuse-snapper.list

>
> apt-get update

That got me the error

W: GPG error: http://download.opensuse.org  Release: The following
signatures couldn't be verified because the public key is not
available: NO_PUBKEY 2DA6FAF4175BFA4E

easily fixed though, using

$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 2DA6FAF4175BFA4E

... and then another apt-get update after that.


> apt-get install snapper

That result in a warning

WARNING: The following packages cannot be authenticated!
  libsnapper snapper
Install these packages without verification [y/N]?

Did the package creation process somehow ommit signing process,
perhaps? Or is there something else I missed?

Anyway, I got snapper-0.0.10-0 installed now, but having a small
problem. I use different subvolumes for multiple directories. For
example, /home and /data. Creating the config for both results in an
error

$ sudo snapper list-configs
Config | Subvolume
-------+----------
$ sudo snapper create-config /home
$ sudo snapper create-config /data
Creating config failed (config already exists).
$ sudo snapper list-configs
Config | Subvolume
-------+----------
root   | /home

How can I create config for /data or other directories (other than
manually creating the config file and .snapshots directory)?

-- 
Fajar
