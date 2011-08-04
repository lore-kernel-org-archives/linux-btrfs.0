From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: INSTALL hint: create device btrfs-control
Date: 04 Aug 2011 23:26:00 +0200
Message-ID: <BrDfft7D1uB@helmut.hullen.de>
References: <20110804204219.GB8970@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110804204219.GB8970@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 04.08.11:

>> ...
>> failed to read /dev/hdc
>> failed to read /dev/hdc8
>> failed to read /dev/lmscd
>> failed to read /dev/sdc1
>> failed to read /dev/sdb4
>> failed to open /dev/btrfs-control skipping device registration

>    OK, that's the symptom we can put in the problems list for this
> particular issue.


[...]

>    Goffredo published a patch to scan only the contents of
> /proc/partitions, which should at least shut up the scan over the
> issue of non-existent devices in /dev. That's in the next
> integration-* branch (going out shortly... I'm just integrating and
> updating the balance management patches before i release).

That sounds fine - thanks to you and to Goffredo!

>> I'll try to reproduce these messages ...

>    Thanks. We can add those as symptoms to the solution later.

I've just run the first test - finding reliable (for only this case)  
messages is a bad job ...


>    How's this?

> https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_get_the_message
> _.22failed_to_open_.2Fdev.2Fbtrfs-control_skipping_device_registratio
> n.22_from_.22btrfs_dev_scan.22

There's some problem in the Wiki. This new paragraph (?) is not shown  
when I call the "Problem_FAQ", it ends with the "Copy-on-write doesn't  
work" question.

When I look into the source code of that page I can see and read the  
paragraph, and it looks fine!

Viele Gruesse!
Helmut
