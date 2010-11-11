From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: labelling
Date: 11 Nov 2010 10:01:00 +0100
Message-ID: <B$fK9snT1uB@helmut.hullen.de>
References: <4CDBAB52.60903@jp.fujitsu.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CDBAB52.60903@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Tsutomu,

Du meintest am 11.11.10:

[cold start]

>> # mount LABEL=MM2
>> mount: wrong fs type, bad option, bad superblock on /dev/sdd2,
>>         missing codepage or helper program, or other error
>>         In some cases useful info is found in syslog - try
>>         dmesg | tail  or so

> I encountered the same problem, too.
> Please try 'btrfsctl -a' before mounting.

It works - thank you!

Another problem (I had mentioned it some days before):

        btrfsctl -a

tests every block device in "/dev". And as I don't use "udev" there are  
many device entries without an existing devices (p.e. hda1 to hda31).  
"btrfsctl" should use something like "/proc/partitions" to test only  
existing devices.

I have to call

        /sbin/btrfsctl -a 2>/dev/null

to make the output readable, and suppressing error messages is no good  
style.

Viele Gruesse!
Helmut
