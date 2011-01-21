From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: Adding a disk fails
Date: 21 Jan 2011 08:00:00 +0100
Message-ID: <BeHbttGy1uB@helmut.hullen.de>
References: <201101201510.54418.CACook@quantum-sci.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101201510.54418.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Carl,

Du meintest am 20.01.11:

>> If you shutdown the system, at the reboot you should "scan" all the
>> device in order to find the btrfs ones
>>
>> # find the btrfs device
>> btrfs device scan

> This must be done at every boot?

Yes - this advice is added in the Wiki (?).

> If so, where is recommended, in rc.local?

That depends - it has to be done before mounting. And if the device is  
part of the boot partition then you may put the "scan" command into an  
init-ramdisk.

Viele Gruesse!
Helmut
