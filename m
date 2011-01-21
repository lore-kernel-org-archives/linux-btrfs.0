From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Adding a disk fails
Date: Fri, 21 Jan 2011 15:00:48 +0700
Message-ID: <AANLkTi=4cipcUswB+krpzf4OGG4zFk-BUZ2omjtwuyBt@mail.gmail.com>
References: <201101201510.54418.CACook@quantum-sci.com>
	<BeHbttGy1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BeHbttGy1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 21, 2011 at 2:00 PM, Helmut Hullen <Hullen@t-online.de> wrote:
>
> Hallo, Carl,
>
> Du meintest am 20.01.11:
>
> >> If you shutdown the system, at the reboot you should "scan" all the
> >> device in order to find the btrfs ones
> >>
> >> # find the btrfs device
> >> btrfs device scan
>
> > This must be done at every boot?
>
> Yes - this advice is added in the Wiki (?).
>
> > If so, where is recommended, in rc.local?
>
> That depends - it has to be done before mounting. And if the device is
> part of the boot partition then you may put the "scan" command into an
> init-ramdisk.

Using something like "device=/dev/sdb,device=/dev/sdc" on fstab mount
options should also work.

-- 
Fajar
