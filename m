Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:55752 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab2JYTZ4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 15:25:56 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so626076eaa.19
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 12:25:55 -0700 (PDT)
Message-ID: <50899269.8080208@gmail.com>
Date: Thu, 25 Oct 2012 21:26:33 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs@vger.kernel.org, kreijack@inwind.it,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: device delete, error removing device [SOLVED]
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com> <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com> <20121022091904.GY25498@carfax.org.uk> <B2B2C037-F5C8-4A75-A0D8-6C0AACDFAF4E@colorremedies.com> <20121022171809.GA25498@carfax.org.uk> <20121023075721.GB391@yeono.kjorling.se> <5086DDAE.3050708@gmail.com> <442D159A-4A4E-4A50-B1DB-0E6E12FA6F5C@colorremedies.com> <5086E9D6.4070201@inwind.it> <3443D67F-6CCE-48BF-A1DB-12473BE95EE8@colorremedies.com> <5087174A.2060405@inwind.it> <1BE15E02-3DBE-42AB-8900-D82C11BCD1B7@colorremedies.com> <50882E38.4000408@gmail.com> <D0E7C142-9FAE-4233-BA2E-BB1EB341FD93@colorremedies.com> <50885E0D.9040701@gmail.com> <2E8E9E76-5B11-4DDF-A3E8-ECE4350384AA@colorremedies.com>
In-Reply-To: <2E8E9E76-5B11-4DDF-A3E8-ECE4350384AA@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-10-24 23:43, Chris Murphy wrote:
>> However this page
>> > 
>> > https://btrfs.wiki.kernel.org/index.php/Project_ideas#Drive_swapping
>> > 
>> > states that someone is working on this kind of issue.
> Yep, I see I'm merely stating what is already known, sorry about that.


No, please; you are really raising the attention to an hot point of
btrfs. Its capability of working when a disk is failed is not enough.
For example it is impossible to remove a disk which disappeared (I have
umount the filesystem, then mount it in degraded mode)...

Btrfs is a filesystem in development, so it is OK that not everything is
working. The "complaints" raise the attention level.

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
