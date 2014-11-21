Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-03v.sys.comcast.net ([69.252.207.35]:37446 "EHLO
	resqmta-ch2-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277AbaKUVM4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 16:12:56 -0500
Message-ID: <546FAAD2.80608@pobox.com>
Date: Fri, 21 Nov 2014 13:12:50 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Phillip Susi <psusi@ubuntu.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>	<546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org>	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>	<546BB2EA.5080809@ubuntu.com> <pan$7c051$a7c25939$cafa59e$f63379c9@cox.net> <546CC04F.6040207@ubuntu.com> <546D0609.9040105@pobox.com> <546D0FEA.5000608@ubuntu.com> <546D18D9.60201@pobox.com> <546E4E6A.3060208@ubuntu.com> <546E6F19.40806@pobox.com> <546F5631.5050701@ubuntu.com>
In-Reply-To: <546F5631.5050701@ubuntu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/21/2014 07:11 AM, Phillip Susi wrote:
> On 11/20/2014 5:45 PM, Robert White wrote:
>> If you search for "ACPI ide" you'll find people complaining in
>> 2008-2010 about windows error messages indicating the device is
>> present in their system but no OS driver is available.
>
> Nope... not finding it.  The closest thing was one or two people who
> said ACPI when they meant AHCI ( and were quickly corrected ).  This
> is probably what you were thinking of since windows xp did not ship
> with an ahci driver so it was quite common for winxp users to have
> this problem when in _AHCI_ mode.

I have to give you that one... I should have never trusted any reference 
to windows.

Most of those references to windows support were getting AHCI and ACPI 
mixed up. Lolz windows users... They didn't get into ACPI disk support 
till 2010. I should have known they were behind the times. I had to 
scroll down almost a whole page to find the linux support.

So lets just look at the top of the ide/ide-acpi.c from linux 2.6 to 
consult about when ACPI got into the IDE business...

linux/drivers/ide/ide-acpi.c
/*
  * Provides ACPI support for IDE drives.
  *
  * Copyright (C) 2005 Intel Corp.
  * Copyright (C) 2005 Randy Dunlap
  * Copyright (C) 2006 SUSE Linux Products GmbH
  * Copyright (C) 2006 Hannes Reinecke
  */

Here's a bug from 2005 of someone having a problem with the ACPI IDE 
support...

https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=6&cad=rja&uact=8&ved=0CDkQFjAF&url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D5604&ei=g6VvVL73K-HLsASIrYKIDg&usg=AFQjCNGTuuXPJk91svGJtRAf35DUqVqrLg&sig2=eHxwbLYXn4ED5jG-guoZqg

People debating the merits of the ACPI IDE drivers in 2005.

https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=12&cad=rja&uact=8&ved=0CGUQFjAL&url=http%3A%2F%2Fwww.linuxquestions.org%2Fquestions%2Fslackware-14%2Fbare-ide-and-bare-acpi-kernels-297525%2F&ei=g6VvVL73K-HLsASIrYKIDg&usg=AFQjCNFoyKgH2sOteWwRN_Tdrfw9hOmVGQ&sig2=BmMVcZl24KRz4s4gEvLN_w

So "you got me"... windows was behind the curve by five years instead of 
just three... my bad...

But yea, nobody has ever used that ACPI disk drive support that's been 
in the kernel for nine years.

Even when you "get me" for referencing windows, you're still wrong...

How many times will you try get out of being hideously horribly wrong 
about ACPI supporting disk/storage IO? It is neither "recent" nor "rare".

How much egg does your face really need before you just see that your 
fantasy that it's "new" and uncommon is a delusional mistake?


Methinks Misters Dunning and Kruger need a word with you...


