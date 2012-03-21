From: Hullen@t-online.de (Helmut Hullen)
Subject: Re: looking for non existent devices
Date: 21 Mar 2012 19:24:00 +0100
Message-ID: <C5J2uwYuCXB@helmut.hullen.de>
References: <20120321181202.GA1973@zambezi.lan>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120321181202.GA1973@zambezi.lan>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Ilya,

Du meintest am 21.03.12:

>> When I run
>>
>>         btrfs filesystem label
>>
>> or
>>
>>         btrfs scrub status /dev/sdxn
>>
>> then I get a lot of error messages with (p.e.)
>>
>>   failed to read /dev/hda6: No such device or address
>>   failed to read /dev/sdm7: No such device or address
>>   failed to read /dev/sr3: No such device or address

> I think this has been fixed in recent btrfs-progs, commit 32eff711.

It is fixed in some (or many) places, it is not fixed everywhere. I had  
used kernel 3.2.9

Viele Gruesse!
Helmut
