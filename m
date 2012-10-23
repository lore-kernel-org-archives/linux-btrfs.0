Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:45085 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932144Ab2JWTCU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 15:02:20 -0400
Message-ID: <5086E9D6.4070201@inwind.it>
Date: Tue, 23 Oct 2012 21:02:46 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: device delete, error removing device
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com> <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com> <20121022091904.GY25498@carfax.org.uk> <B2B2C037-F5C8-4A75-A0D8-6C0AACDFAF4E@colorremedies.com> <20121022171809.GA25498@carfax.org.uk> <20121023075721.GB391@yeono.kjorling.se> <5086DDAE.3050708@gmail.com> <442D159A-4A4E-4A50-B1DB-0E6E12FA6F5C@colorremedies.com>
In-Reply-To: <442D159A-4A4E-4A50-B1DB-0E6E12FA6F5C@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-10-23 20:17, Chris Murphy wrote:
> 
> On Oct 23, 2012, at 12:10 PM, Goffredo Baroncelli <kreijack@gmail.com> wrote:
>>
>> I think that what Chris [Murphy] was reported is a bug of the btrfs
>> user space program (which is corrected in the latest git).
>> Unfortunately we don't know which version Chris is using so we cannot
>> reach a conclusion (if the bug was corrected, or it is a new bug).
> 
> btrfs-progs-0.20.rc1.20121017git91d9eec-1.fc18.x86_64

Definitely this version contains my patch.

Are you able to reproduce this bug (the missing device warning)? If so,
please could you be so kindly to test the Stefan's tool [*] to dump the
super-blocks of the involved disks ?

Thanks
G.Baroncelli


[*] See
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg19572.html

> 
> 
> 
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
