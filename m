From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: minor ID for btrfs-control
Date: 02 Apr 2011 20:06:00 +0200
Message-ID: <Bj4lIEOy1uB@helmut.hullen.de>
References: <20110402172936.GA24370@mother.jarsat.pl>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110402172936.GA24370@mother.jarsat.pl>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Tomasz,

Du meintest am 02.04.11:

>   No udev is wrong.

Sorry - no.
On the machines I use I don't need udev (they are a kind of server, not  
end user workstations with often changing hardware). And I could abstain  
(? - please excuse my gerlish) from btrfs, but not from fixed device  
names.

I may not believe that btrfs only works under udev.

>   Modern Linux kernels allocate minor devices
> dynamically. If you do not use udev, you need to synchronise /dev/
> node with /sys/class/misc/btrfs-control/dev manually on each boot.

How and where? From where gets the system the actual minor number 234  
instead of the defined number 55?

By the way - the btrfs module is "builtin", is that a problem?

Viele Gruesse!
Helmut
