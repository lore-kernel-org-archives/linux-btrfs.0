From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: LABEL only 1 device
Date: 27 Feb 2012 22:59:00 +0100
Message-ID: <C3f55qiy1uB@helmut.hullen.de>
References: <20120227214536.GB4481@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120227214536.GB4481@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 27.02.12:

>> But there's a small difference:
>>
>>         mke2fs -L MyLabel /dev/sdn4
>>
>> only sets/changes the label (ok - it tests the type of the partition
>> and refuses labeling if the type doesn't fit).

>    OK, I have just tried this out. It does set the filesystem label.
> It also wipes the filesystem, as I expected it to. You clearly aren't
> doing this on existing filesystems with data in them.

I should have tested it ... sorry.
I've always labeled my ext[234] partitions with "e2label".

And because I hadn't found such a simple command for btrfs I took  
"mkfs.btrfs -L" instead of "btrfs fi label <mountpoint>".

Viele Gruesse!
Helmut
