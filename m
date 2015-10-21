Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38572 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbbJUVIk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 17:08:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zp0cd-00035Z-E5
	for linux-btrfs@vger.kernel.org; Wed, 21 Oct 2015 23:08:35 +0200
Received: from chello213047196183.tirol.surfer.at ([213.47.196.183])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 23:08:35 +0200
Received: from wertstoffe by chello213047196183.tirol.surfer.at with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 23:08:35 +0200
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Jakob_Sch=c3=bcrz?= <wertstoffe@nurfuerspam.de>
Subject: Re: btrfs-balance causes system-freeze on full disk
Date: Wed, 21 Oct 2015 23:04:42 +0200
Message-ID: <a8blfc-90o.ln1@aldebaran.xundeenergie.at>
References: <c76lfc-jfl.ln1@aldebaran.xundeenergie.at>
 <CAM9fjH4vQki-0UjdMTGZgKEbDy1pRBZNRqro8TtqzLbDPwfsvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAM9fjH4vQki-0UjdMTGZgKEbDy1pRBZNRqro8TtqzLbDPwfsvw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thx!

It seems to be the same bug.

Am 2015-10-21 um 22:51 schrieb Kyle Manna:
> I had a number of similar btrfs balance crashes in the past few days,
> but the disk wasn't full.  You should try tailing the system logs from
> a remote machine when it happens. You'll likely see some bug info
> before the system dies and becomes unusable.
> 
> The issue I encountered is described @
> https://bugzilla.kernel.org/show_bug.cgi?id=105681
> ᐧ
> 
> On Wed, Oct 21, 2015 at 12:38 PM, Jakob Schürz
> <wertstoffe@nurfuerspam.de> wrote:
>> Hi there!
>>
>> Is it possible, what i've recognized now. My system (debian) runs on
>> btrfs, and i have a lot of snapshots on my hard-disk.
>> Since some days my system freezes totally. I recognized, it always
>> happens during btrfs-balance.
>>
>> So i deleted some of the old snapshots and tried another balance-run.
>> Nothing happened... No system-freeze.
>>
>> System-freeze means: No Keyboard-action. The Mouse is frozen, the screen
>> is frozen, no magic-sysreq, no ssh-login.
>>
>> Can btrfs cause such a freeze??
>>
>> greez
>>
>> jakob
>> --
>> http://xundeenergie.at
>> http://verkehrsloesungen.wordpress.com/
>> http://cogitationum.wordpress.com/
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
http://xundeenergie.at
http://verkehrsloesungen.wordpress.com/
http://cogitationum.wordpress.com/

