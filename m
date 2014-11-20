Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-04v.sys.comcast.net ([69.252.207.36]:52100 "EHLO
	resqmta-ch2-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756063AbaKTWpy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 17:45:54 -0500
Message-ID: <546E6F19.40806@pobox.com>
Date: Thu, 20 Nov 2014 14:45:45 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Phillip Susi <psusi@ubuntu.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>	<546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org>	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>	<546BB2EA.5080809@ubuntu.com> <pan$7c051$a7c25939$cafa59e$f63379c9@cox.net> <546CC04F.6040207@ubuntu.com> <546D0609.9040105@pobox.com> <546D0FEA.5000608@ubuntu.com> <546D18D9.60201@pobox.com> <546E4E6A.3060208@ubuntu.com>
In-Reply-To: <546E4E6A.3060208@ubuntu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/20/2014 12:26 PM, Phillip Susi wrote:
> Yes, ACPI 4.0 added this mess.  I have yet to see a single system that
> actually implements it.  I can't believe they even bothered adding
> this driver to the kernel.  Is there anyone in the world who has ever
> used it?  If no motherboard vendor has bothered implementing the ACPI
> FAN specs, I very much doubt anyone will ever bother with this.

Nice attempt at saving face, but wrong as _always_.

The CONFIG_PATA_ACPI option has been in the kernel since 2008 and lots 
of people have used it.

If you search for "ACPI ide" you'll find people complaining in 2008-2010 
about windows error messages indicating the device is present in their 
system but no OS driver is available.

That you "have yet to see a single system that implements it" is about 
the worst piece of internet research I've ever seen. Do you not _get_ 
that your opinion about what exists and how it works is not authoritative?

You can also find articles about both windows and linux systems actively 
using ACPI fan control going back to 2009

These are not hard searches to pull off. These are not obscure 
references. Go to the google box and start typing "ACPI fan..." and 
check the autocomplete.

I'll skip ovea all the parts where you don't know how a chipset works 
and blah, blah, blah...

You really should have just stopped at "I don't know" and "I've never" 
because you keep demonstrating that you _don't_ know, and that you 
really _should_ _never_.

Tell us more about the lizard aliens controlling your computer, I find 
your versions of realty fascinating...
