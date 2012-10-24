Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:37199 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422671Ab2JXVnI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 17:43:08 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: device delete, error removing device [SOLVED]
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <50885E0D.9040701@gmail.com>
Date: Wed, 24 Oct 2012 15:43:08 -0600
Cc: Stefan Behrens <sbehrens@giantdisaster.de>
Message-Id: <2E8E9E76-5B11-4DDF-A3E8-ECE4350384AA@colorremedies.com>
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com> <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com> <20121022091904.GY25498@carfax.org.uk> <B2B2C037-F5C8-4A75-A0D8-6C0AACDFAF4E@colorremedies.com> <20121022171809.GA25498@carfax.org.uk> <20121023075721.GB391@yeono.kjorling.se> <5086DDAE.3050708@gmail.com> <442D159A-4A4E-4A50-B1DB-0E6E12FA6F5C@colorremedies.com> <5086E9D6.4070201@inwind.it> <3443D67F-6CCE-48BF-A1DB-12473BE95EE8@colorremedies.com> <5087174A.2060405@inwind.it> <1BE15E02-3DBE-42AB-8900-D82C11BCD1B7@colorremedies.com> <50882E38.4000408@gmail.com> <D0E7C142-9FAE-4233-BA2E-BB1EB341FD93@colorremedies.com> <50885E0D.9040701@gmail.com>
To: linux-btrfs@vger.kernel.org, kreijack@inwind.it
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 24, 2012, at 3:30 PM, Goffredo Baroncelli <kreijack@gmail.com> wrote:

> On 2012-10-24 21:13, Chris Murphy wrote:
>> 
>> It's an interesting solution, but difficult for a larger file system.
>> Or at least, could be very time consuming.
> It is not a solution but a workaround.

Understood.

> 
>> Aside from the "no space left" problem, the 'device delete' behavior
>> itself has kindof a high penalty: a successful 'device delete' on a
>> five disk raid10 (one was added in advance of the delete), all disks
>> are significantly written to, not merely a reconstruction of the
>> replaced disk. It means a lot of writing to do disk removals in the
>> face of an impending disk failure.
> 
> I am not telling that this is the right solution, I am telling that this
> is the only solution available now :-(

Fair enough.
> 
> However this page
> 
> https://btrfs.wiki.kernel.org/index.php/Project_ideas#Drive_swapping
> 
> states that someone is working on this kind of issue.

Yep, I see I'm merely stating what is already known, sorry about that.

Chris Murphy
