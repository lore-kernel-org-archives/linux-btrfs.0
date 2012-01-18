From: cwillu <cwillu@cwillu.com>
Subject: Re: bad tree block problems
Date: Wed, 18 Jan 2012 14:48:52 -0600
Message-ID: <CAE5mzvgaoWWLoi2ejsFNzZ65h6Hov5KTDtBAAZU+x+4uHONGLg@mail.gmail.com>
References: <CAGGGvRtNCvt9LYvZE1ZEE9tYCS95KLTUdKKXnqDzm8vHbO-vfg@mail.gmail.com>
	<20111220233637.GP19266@shiny>
	<CAGGGvRucivqjTz4X7LNdTo_Nx_oXY9wOor4f7zbnbCf_+-XKPw@mail.gmail.com>
	<4EF13156.302@cn.fujitsu.com>
	<CAGGGvRsse8YhCxeyi+KOWNr2Oav+YS2iR9_4Px3gH4J1=8NH6w@mail.gmail.com>
	<CAGGGvRvVUDbsZKOgqkA+CYfsfpYdHEDF5BYLs3sKVWw+ekH4nQ@mail.gmail.com>
	<CAGGGvRtNS1_aAWh0=NOD9KTjBNY4Z9wDMATGYTOFCN-HXt4ssg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Chris Baines <cbaines8@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAGGGvRtNS1_aAWh0=NOD9KTjBNY4Z9wDMATGYTOFCN-HXt4ssg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

First thing I'd try is to try mounting it readonly ("mount ... -o
ro").  This should get it mounted, or at least failing at a later
point with different (better?) error messages to work from.  (dmesg
output after such an attempt would be useful).

On the vanilla kernel front, Ubuntu has kernel debs without any extra
patches, which will/should work with debian.  (There may be a similar
pure debian thing somewhere already, but anyways).

If you see anything about dkms building modules when installing,
you'll have to disable those in order to prevent the nvidia and
virtualbox modules from being built/installed with vanilla kernel.

Debs available from
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.2.1-precise/

And the relevant dkms lines if applicable (module names may also vary,
but dkms status will list the relevant ones assuming dkms is in fact
in use):

"dkms status"
"dkms uninstall -m nvidia -v <from status> -k <from status, something
something 3.2.1>"
"dkms uninstall -m vboxhost -v <from status> -k <from status,
something something 3.2.1>"
