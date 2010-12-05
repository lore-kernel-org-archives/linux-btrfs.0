From: Evert Vorster <evorster@gmail.com>
Subject: Re: 800 GByte free, but "no space left"
Date: Sun, 5 Dec 2010 11:00:41 -0700
Message-ID: <AANLkTim_vYJtsknDEYFkOXqZ9BtpReywpy2ajFq_8QR6@mail.gmail.com>
References: <AANLkTinA81Zb102g4rmzp-+tR3Y_+1hrGh2EXW=xeCn4@mail.gmail.com>
	<BbJP6kxy1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Helmut Hullen <Hullen@t-online.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BbJP6kxy1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 5, 2010 at 7:33 AM, Helmut Hullen <Hullen@t-online.de> wrot=
e:
> Hallo, Evert,
>
> Du meintest am 05.12.10 zum Thema Re: 800 GByte free, but "no space l=
eft":
>
>>>>>>> =A0 =A0 =A0 devid =A0 =A02 size 1.35TB used 1.35TB path /dev/sd=
c3
>>>>>>> =A0 =A0 =A0 devid =A0 =A01 size 1.81TB used 1.35TB path /dev/sd=
f2
>
I'd like to point to this output of btrfs filesystem show again...
Here devid is 100% full. This, I assume, is both data and metadata.
When you do a df, what you see is only data, and not the metadata.
That might account for the difference you see.

I did a little bit of testing on my machine....

I created two partitions, /dev/sdb6 (1Gb)  and  /dev/sdb7(2Gb)
When I created an btrfs with the following command:
mkfs.btrfs -d raid0 /dev/sdb6 /dev/sdb7

I got a filesystem that started giving ENOSPACE with only 1.6Gb full.
Running a filesystem balance did not do anything.... and it was
predictably slow...

When I created a file system with
mkfs.btrfs -d single /dev/sdb6 /dev/sdb7
I was able to fill the resulting file system to 2.7Gb before it
started throwing ENOSPACE this file system was quite a bit faster...

So, by far the simplest solution would be to re-create your file
system with "single" mode, and then you will be able to utilize all of
the space of both disks. I was using quite chunky files, so there
would be some granularity in the test results, but it clearly shows
that raid0 is limited in space to (smallest subdevice) x (number of
subdevices) whereas "single" tries to use all of the available space
on all the subdevices.

Kind regards,
-Evert Vorster-
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
