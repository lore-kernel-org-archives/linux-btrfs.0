Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw7a-drew.wadns.net ([41.185.62.57]:5730 "EHLO fw7a.wadns.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751210AbbBJE35 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 23:29:57 -0500
Message-ID: <54D98927.7060704@swiftspirit.co.za>
Date: Tue, 10 Feb 2015 06:29:27 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Replacing a (or two?) failed drive(s) in RAID-1 btrfs filesystem
References: <CANcfdL0x_LTSnyL1FP8vVV4=MaFrewT4pd0MZgu3qzxOviXDgg@mail.gmail.com> <CAJCQCtT+8+02KkYOcRUOhscj3AP0av8PpNmsK526hvJY=3ucRw@mail.gmail.com> <CANcfdL0twe-pi4f1ZVNG=m82gQTKc5QL3pcodY6diJ6uLj2Q9A@mail.gmail.com> <CAJCQCtSJ+kgxKb-gGnuOCFEVBsr2UP0aUWg_M60Ts_OQaSL8oQ@mail.gmail.com> <CANcfdL2aSfE5uwgwt1KYGRsucF_wTGSyEVT=LfX+COd2gywJ+A@mail.gmail.com> <CANcfdL3qEG8HPDzRE8z8rEuuBpkcbMF4ZjV0oQrH9sZ8FSpxXg@mail.gmail.com> <CAJCQCtRy=Duyd9T5_rnPF06=a-fuqjhR=0yos0UtA1vm1r2v2A@mail.gmail.com> <CANcfdL1rT7BMM05cO7=Kd1JzKYSbUXXW+23YdzMc3+SYVra=TQ@mail.gmail.com> <54D85452.9070306@swiftspirit.co.za> <ivhnqb-40b.ln1@hurikhan77.spdns.de>
In-Reply-To: <ivhnqb-40b.ln1@hurikhan77.spdns.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2015/02/09 10:30 PM, Kai Krakow wrote:
> Brendan Hide <brendan@swiftspirit.co.za> schrieb:
> 
>> I have the following two lines in 
>> /etc/udev/rules.d/61-persistent-storage.rules for two old 250GB
[snip]
> Wouldn't it be easier and more efficient to use this:
> 
> ACTION=="add|change", KERNEL=="sd[a-z]", ENV{ID_SERIAL}=="...", 
> ATTR{device/timeout}="120"
> 
> Otherwise you always spawn a shell and additional file descriptors,
> and you could spare a variable interpolation. Tho it probably
> depends on your udev version...
> 
> I'm using this and it works setting the attributes (set deadline on
> SSD):
> 
> ACTION=="add|change", KERNEL=="sd[a-z]",
> ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="deadline"
> 
> And, I think you missed the double-equal "==" behind ENV{}...
> Right? Otherwise you just assign a value. Tho, you could probably
> match on ATTR{devices/model} instead to be more generic (the serial
> is probably too specific). You can get those from the
> /sys/block/sd* subtree.
> 

It is certainly possible that it isn't 100% the right way - but it has
been working. Your suggestions certainly sound more
efficient/canonical. I was following what I found online until it
"worked".  :)

I'll make the appropriate adjustments and test.

Thanks!

- -- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (MingW32)

iQEcBAEBAgAGBQJU2YknAAoJEE+uni74c4qNopMH/34nj5wEi3m25jk/vEUud3hh
bbK4/mh564VnMc1NnpYXe++gUUTf0+203JDERgCQ1k3XjFMUe3VDPQBSdCIxcuOV
H7BtFWcuUYvaTd/3kHTcB2mp097RUQs25Jhcmf8y/+YZdnglnpSrRYtIIMM8osil
Y70IzoSRLuVHYlZT5VPmH7r7P9CeW5VnEG0jb3DkDe+tLH2Ed1Wy/Ti5myX0BF2l
7vJ1gTnPMmIUu/MKmNka6/hSWKGV7G2MeFoOy9UB2HhWsdGCjpJ1z8ToRQLcZbWX
yCpSjw2GDCtdG91iKiWK+kAJOreKqWGA3GSdgKqZhAQVg6LFeml1qLrBZ7H9H1o=
=TtpU
-----END PGP SIGNATURE-----
