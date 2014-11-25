Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:63528 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaKYVey (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 16:34:54 -0500
Received: by mail-qg0-f46.google.com with SMTP id z107so1126578qgd.33
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 13:34:53 -0800 (PST)
Message-ID: <5474F5D1.2070908@ubuntu.com>
Date: Tue, 25 Nov 2014 16:34:09 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>	<546AF572.2020101@swiftspirit.co.za>	<20141118153526.GS20972@merlins.org>	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>	<546BB2EA.5080809@ubuntu.com>	<E47EA20E-375D-49A6-B4B0-C6594CE6A633@colorremedies.com>	<546CB332.3080705@ubuntu.com> <CAJCQCtTfhxW2w+mT6rqyr+WwVdj8SAEAGV+LB8_S3mcw0agxaw@mail.gmail.com>
In-Reply-To: <CAJCQCtTfhxW2w+mT6rqyr+WwVdj8SAEAGV+LB8_S3mcw0agxaw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/19/2014 7:05 PM, Chris Murphy wrote:
> I'm not a hard drive engineer, so I can't argue either point. But 
> consumer drives clearly do behave this way. On Linux, the kernel's 
> default 30 second command timer eventually results in what look
> like link errors rather than drive read errors. And instead of the
> problems being fixed with the normal md and btrfs recovery
> mechanisms, the errors simply get worse and eventually there's data
> loss. Exhibits A, B, C, D - the linux-raid list is full to the brim
> of such reports and their solution.

I have seen plenty of error logs of people with drives that do
properly give up and return an error instead of timing out so I get
the feeling that most drives are properly behaved.  Is there a
particular make/model of drive that is known to exhibit this silly
behavior?

>> IIRC, this is true when the drive returns failure as well.  The
>> whole bio is marked as failed, and the page cache layer then
>> begins retrying with progressively smaller requests to see if it
>> can get *some* data out.
> 
> Well that's very course. It's not at a sector level, so as long as
> the drive continues to try to read from a particular LBA, but fails
> to either succeed reading or give up and report a read error,
> within 30 seconds, then you just get a bunch of wonky system
> behavior.

I don't understand this response at all.  The drive isn't going to
keep trying to read the same bad lba; after the kernel times out, it
resets the drive, and tries reading different smaller parts to see
which it can read and which it can't.

> Conversely what I've observed on Windows in such a case, is it 
> tolerates these deep recoveries on consumer drives. So they just
> get really slow but the drive does seem to eventually recover
> (until it doesn't). But yeah 2 minutes is a long time. So then the
> user gets annoyed and reinstalls their system. Since that means
> writing to the affected drive, the firmware logic causes bad
> sectors to be dereferenced when the write error is persistent.
> Problem solved, faster system.

That seems like rather unsubstantiated guesswork.  i.e. the 2 minute+
delays are likely not on an individual request, but from several
requests that each go into deep recovery, possibly because windows is
retrying the same sector or a few consecutive sectors are bad.

> Because now you have a member drive that's inconsistent. At least
> in the md raid case, a certain number of read failures causes the
> drive to be ejected from the array. Anytime there's a write
> failure, it's ejected from the array too. What you want is for the
> drive to give up sooner with an explicit read error, so md can help
> fix the problem by writing good data to the effected LBA. That
> doesn't happen when there are a bunch of link resets happening.

What?  It is no different than when it does return an error, with the
exception that the error is incorrectly applied to the entire request
instead of just the affected sector.

> Again, if your drive SCT ERC is configurable, and set to something 
> sane like 70 deciseconds, that read failure happens at MOST 7
> seconds after the read attempt. And md is notified of *exactly*
> what sectors are affected, it immediately goes to mirror data, or
> rebuilds it from parity, and then writes the correct data to the
> previously reported bad sectors. And that will fix the problem.

Yes... I'm talking about when the drive doesn't support that.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUdPXRAAoJEI5FoCIzSKrw5aUIAJpmAczzc+0flGpDnenNIf9E
HITY2a15lRhrnpfiEBmlTe0EUyc8O+Sv/kWJ61VRJ1KNCtF0Cs0jMEvOk2BGiM9T
rR2KinIFlPZfuR7sUpgns+i5TK3eXpn+bbm5jIUFf8hOdkERFArwaQIqo3qqMybs
3rHdnBo7T+F9oCMwuFyvwHupDd2gCbnibB8mIUhijUcZQwoqU9c/ISGySpM7x04J
VeDCI3hWv2V5hhm+Bfdq3fQpjeIo2AAvCPt+ODuFFHabQ5l78Qu7IlCEFGIYuQqi
VJPxXNUi4n34O/jWEX5KBGgXp3H1RegnvcAt2NFLMVpFVDSB9I5eYLrj/d8KWoE=
=r3AP
-----END PGP SIGNATURE-----
