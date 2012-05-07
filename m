From: Hullen@t-online.de (Helmut Hullen)
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: 07 May 2012 15:34:00 +0200
Message-ID: <C8PCDX9uCXB@helmut.hullen.de>
References: <20120507105944.GD8938@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120507105944.GD8938@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 07.05.12:

>> =================== boot messages, kernel related ==============
>>
>> [boot with kernel 3.3.4]
>> May  7 06:55:26 Arktur kernel: ata5: exception Emask 0x10 SAct 0x0
>> SErr 0x10000 action 0xe frozen
>> May  7 06:55:26 Arktur kernel: ata5: SError: { PHYRdyChg }
>> May  7 06:55:26 Arktur kernel: ata5: hard resetting link

[...]

>    This is a hardware error. You have a device that's either dead or
> dying. (Given the number of errors, probably already dead).

It's dead - R.I.P.

I've tried it with a SATA-USB-adapter - that adapter produces dmesg  
lines when connecting or disconnecting.

And this special drive doesn't tell anything now. Shit.

Viele Gruesse!
Helmut
