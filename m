From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: 800 GByte free, but "no space left"
Date: 05 Dec 2010 15:33:00 +0100
Message-ID: <BbJP6kxy1uB@helmut.hullen.de>
References: <AANLkTinA81Zb102g4rmzp-+tR3Y_+1hrGh2EXW=xeCn4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinA81Zb102g4rmzp-+tR3Y_+1hrGh2EXW=xeCn4@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Evert,

Du meintest am 05.12.10 zum Thema Re: 800 GByte free, but "no space lef=
t":

>>>>>> =A0 =A0 =A0 devid =A0 =A02 size 1.35TB used 1.35TB path /dev/sdc=
3
>>>>>> =A0 =A0 =A0 devid =A0 =A01 size 1.81TB used 1.35TB path /dev/sdf=
2

>>> Here devid 2 is at 100%, and hence you are getting the no more
>>> space left errors. So, the 300 TB is on the bigger disk, and not
>>> usable for you right now.

>> =A0 I _think_ that a balance is all that's needed at this point. It
>> can't hurt, anyway (other than taking quite a long time).

> I am under the impression that as soon as one of the devices in a
> btrfs is out of space, and write to that file system returns ENOSPACE
> This certainly does look like it from this example, and from what I
> have read elsewhere.

Maybe - I don't know the code.

But in my case "ENOSPACE" is returned too early.

"btrfs-show" tells 2*1.35 TiByte used, but "no space left" is told when=
 =20
2.4 TiByte are used (2.38 TiByte is ok). That's 300 GiByte too early (o=
r =20
about 10% too early).

Or am I wrong in interpreting the messages?

Viele Gruesse!
Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
