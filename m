Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:12778 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750802AbaKVWGw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Nov 2014 17:06:52 -0500
Message-ID: <547108FB.9070507@ubuntu.com>
Date: Sat, 22 Nov 2014 17:06:51 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>	<546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org>	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>	<546BB2EA.5080809@ubuntu.com> <pan$7c051$a7c25939$cafa59e$f63379c9@cox.net> <546CC04F.6040207@ubuntu.com> <546D0609.9040105@pobox.com> <546D0FEA.5000608@ubuntu.com> <546D18D9.60201@pobox.com> <546E4E6A.3060208@ubuntu.com> <546E6F19.40806@pobox.com> <546F5631.5050701@ubuntu.com> <546FAAD2.80608@pobox.com>
In-Reply-To: <546FAAD2.80608@pobox.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 11/21/2014 04:12 PM, Robert White wrote:
> Here's a bug from 2005 of someone having a problem with the ACPI
> IDE support...

That is not ACPI "emulation".  ACPI is not used to access the disk,
but rather it has hooks that give it a chance to diddle with the disk
to do things like configure it to lie about its maximum size, or issue
a security unlock during suspend/resume.

> People debating the merits of the ACPI IDE drivers in 2005.

No... that's not a debate at all; it is one guy asking if he should
use IDE or "ACPI" mode... someone who again meant AHCI and typed the
wrong acronym.

> Even when you "get me" for referencing windows, you're still 
> wrong...
> 
> How many times will you try get out of being hideously horribly
> wrong about ACPI supporting disk/storage IO? It is neither "recent"
> nor "rare".
> 
> How much egg does your face really need before you just see that
> your fantasy that it's "new" and uncommon is a delusional mistake?

Project much?

It seems I've proven just about everything I originally said you got
wrong now so hopefully we can be done.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUcQj4AAoJENRVrw2cjl5RwmcH+gOW0LUQE4OXEToMY33brK8Z
QMKw7T1y4dtXIeeWihugNs+vbwmoI2Wheeej4WPdiqvgqIfX4ov9+N9Nb39JiIsI
7frPJ638n98Et5sirCGKfaVvDTwlF85ApHHtXrVLg2dBY3A+oLM9jVU7jpRBvW1m
IFjhJH/SMGDpMhix9SFg6w6cALRh1U5WYV4zMZ1f5/ri/05TYmNJ/M23cjtBicPZ
LaIFxOMGef4lylysNaVh0W03424oIJit6d7DB1gxCyjnkUvVuJ43NjuS5ay+y2sP
FFrepKrOfhK1oOib9e63zNfRHhWrX4KN0Dqcu/3+/+lhD3q5G1fd4YK2RV/oaso=
=nm9l
-----END PGP SIGNATURE-----
