From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: minor ID for btrfs-control
Date: 03 Apr 2011 05:11:00 +0200
Message-ID: <Bj8lm4ND1uB@helmut.hullen.de>
References: <4D97A4B0.6010207@libero.it>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D97A4B0.6010207@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Goffredo,

Du meintest am 03.04.11:

>> if I've understood some mails in this list correct, then btrfs needs
>> a character device "btrfs-control"  with the ID 10:55
>>
>> When I look for this device in
>>
>>         /sys/class/misc/btrfs-control/dev
>>
>> I see 10:234

> As wrote by Tomasz the minor number of the btrfs-control is allocated
> dynamically.

At which place?

> If you don't want to use udev you have two choices:
> - use devtmpfs

That leads to similar problems as "udev": I have to define on another  
place ("/lib/udev/devices") the desired device.

> - create manually a device. But nobody guarantee that the minor/major
> will not  change.

That seems to be the behaviour I'm watching on my test machine. "hard  
coded" device with 10:55, but the system uses 10:234

If btrfs is designed to work only under udev then it has to check wether  
udev is running.

Viele Gruesse!
Helmut
