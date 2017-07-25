Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:59110 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750885AbdGYV3r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 17:29:47 -0400
Reply-To: waxhead@dirtcellar.net
Subject: Re: btrfs raid assurance
To: Hugo Mills <hugo@carfax.org.uk>,
        =?UTF-8?Q?H=c3=a9rikz_Nawarro?= <herikz.nawarro@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAD6NJSxuix4N=kPbQ_=QRnKP4Ny6kLyVyEA4p=PvBfgtbwrUHw@mail.gmail.com>
 <20170725134656.GL7140@carfax.org.uk> <20170725135146.GM7140@carfax.org.uk>
 <CAD6NJSz0qMYhiqmseOQtG-ytVTck1aZykVe+U1FtXQvTMThs4g@mail.gmail.com>
 <20170725135835.GN7140@carfax.org.uk>
From: waxhead <waxhead@dirtcellar.net>
Message-ID: <d07af24a-1689-fce4-296a-af4f10f3058d@dirtcellar.net>
Date: Tue, 25 Jul 2017 23:29:13 +0200
MIME-Version: 1.0
In-Reply-To: <20170725135835.GN7140@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hugo Mills wrote:
>
>>>     You can see about the disk usage in different scenarios with the
>>> online tool at:
>>>
>>> http://carfax.org.uk/btrfs-usage/
>>>
>>>     Hugo.
>>>
As a side note, have you ever considered making this online tool (that 
should never go away just for the record) part of btrfs-progs e.g. a 
proper tool? I use it quite often (at least several timers per. month) 
and I would love for this to be a visual tool 'btrfs-space-calculator' 
would be a great name for it I think.

Imagine how nice it would be to run....

btrfs-space-calculator -mraid1 -draid10 /dev/sda1 /dev/sdb1 /dev/sdc2 
/dev/sdd2 /dev/sde3 for example and instantly get something similar to 
my example below (no accuracy intended)

d=data
m=metadata
.=unusable

{  500mb} [|ddddd|] /dev/sda1
{ 3000mb} [|ddddd|mmmmm|mmmmm|mmmmm|mmmmm|mm...|] /dev/sdb1
{ 3000mb} [|ddddd|mmmmm|mmmmm|mmmmm|mmmmm|mmm..|] /dev/sdc2
{ 5000mb} 
[|ddddd|mmmmm|mmmmm|mmmmm|mmmmm|mmmmm|mmmmm|mmmmm|mmmmm|mmmmm|] /dev/sdb1
--------
{11500mb} Total space

usable for data (raid10): 1000mb / 2000mb
usable for metadata (raid1): 4500mb / 9000mb
unusable: 500mb

Of course this would have to change one (if ever) subvolumes can have 
different raid levels etc, but I would have loved using something like 
this instead of jumping around carfax abbey (!) at night.
