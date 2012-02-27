From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: btrfs-convert options
Date: 27 Feb 2012 11:29:00 +0100
Message-ID: <C3f2tNoT1uB@helmut.hullen.de>
References: <20120227101301.GF18898@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120227101301.GF18898@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 27.02.12:

>> I want to change some TByte disks (at least one) from ext4 to btrfs.
>> And I want "-d raid0 -m raid1". Is it possible to tell btrfs-convert
>> especially these options for data and metadata?
>>
>> Or have I to use "mkfs.btrfs" (and then copy the backup) when I want
>> these options?

>    The other alternative is to get hold of 3.3-rcX and the latest
> userspace tools (currently in the "dangerdonteveruse branch, but
> should be in "master" very soon), and use the restriper after you've
> converted.

Hmmmm - I don't yet dare these experiments with really big disks ...

Viele Gruesse!
Helmut
