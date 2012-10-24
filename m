Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46937 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161047Ab2JXVaS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 17:30:18 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so380259eek.19
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2012 14:30:17 -0700 (PDT)
Message-ID: <50885E0D.9040701@gmail.com>
Date: Wed, 24 Oct 2012 23:30:53 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: device delete, error removing device [SOLVED]
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com> <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com> <20121022091904.GY25498@carfax.org.uk> <B2B2C037-F5C8-4A75-A0D8-6C0AACDFAF4E@colorremedies.com> <20121022171809.GA25498@carfax.org.uk> <20121023075721.GB391@yeono.kjorling.se> <5086DDAE.3050708@gmail.com> <442D159A-4A4E-4A50-B1DB-0E6E12FA6F5C@colorremedies.com> <5086E9D6.4070201@inwind.it> <3443D67F-6CCE-48BF-A1DB-12473BE95EE8@colorremedies.com> <5087174A.2060405@inwind.it> <1BE15E02-3DBE-42AB-8900-D82C11BCD1B7@colorremedies.com> <50882E38.4000408@gmail.com> <D0E7C142-9FAE-4233-BA2E-BB1EB341FD93@colorremedies.com>
In-Reply-To: <D0E7C142-9FAE-4233-BA2E-BB1EB341FD93@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-10-24 21:13, Chris Murphy wrote:
> 
> On Oct 24, 2012, at 12:06 PM, Goffredo Baroncelli
> <kreijack@gmail.com> wrote:
>>> 
>> 
>> I was able to reproduce it:
>> 
>> - I filled the filesystem until I got "No space left on device".
> 
> I didn't even need to get that far.
> 
> 
>> So it seems that I spread all the data to the other disk, filling
>> up the smaller ones. So it stuck to "No space left on device".
>> 
>> Now I rebalanced with -dconvert=single, as suggested by Hugo, then
>> I was able to remove the disk:
>> 
>> Label: 'test2'  uuid: 11d0f1a8-2770-4ff2-8df5-f772f1056edc Total
>> devices 3 FS bytes used 7.63GB devid    4 size 12.00GB used 9.48GB
>> path /dev/vdf devid    3 size 3.00GB used 492.94MB path /dev/vdd 
>> devid    2 size 3.00GB used 64.00MB path /dev/vdc
> 
> It's an interesting solution, but difficult for a larger file system.
> Or at least, could be very time consuming.
It is not a solution but a workaround.

> Aside from the "no space left" problem, the 'device delete' behavior
> itself has kindof a high penalty: a successful 'device delete' on a
> five disk raid10 (one was added in advance of the delete), all disks
> are significantly written to, not merely a reconstruction of the
> replaced disk. It means a lot of writing to do disk removals in the
> face of an impending disk failure.

I am not telling that this is the right solution, I am telling that this
is the only solution available now :-(

However this page

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Drive_swapping

states that someone is working on this kind of issue.

G.Baroncelli
> 
> 
> Chris Murphy
> 
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
