From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: LABEL only 1 device
Date: 27 Feb 2012 11:27:00 +0100
Message-ID: <C3f2t9RT1uB@helmut.hullen.de>
References: <20120227101154.GE18898@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120227101154.GE18898@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 27.02.12:

>>>    mkfs.btrfs creates a new filesystem. The -L option sets the
>>>    label
>>> for the newly-created FS. It *cannot* be used to change the label
>>> of an existing FS.

>> The safest way may be deleting this option ... it seems to work as
>> expected only when I create a new FS on 1 disk/partition.

>    I've said this several times: Your expectations are wrong. You
> don't label partitions.

Yes - now I know.
But I'm afraid other people also expect wrong - when I use mkfs.ext[234]  
then this option works (in another way than with "mkfs.btrfs").

Viele Gruesse!
Helmut
