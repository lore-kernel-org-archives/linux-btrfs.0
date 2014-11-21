Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:41422 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394AbaKUPMH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 10:12:07 -0500
Received: by mail-qg0-f50.google.com with SMTP id i50so606409qgf.37
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Nov 2014 07:12:06 -0800 (PST)
Message-ID: <546F5631.5050701@ubuntu.com>
Date: Fri, 21 Nov 2014 10:11:45 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>	<546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org>	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>	<546BB2EA.5080809@ubuntu.com> <pan$7c051$a7c25939$cafa59e$f63379c9@cox.net> <546CC04F.6040207@ubuntu.com> <546D0609.9040105@pobox.com> <546D0FEA.5000608@ubuntu.com> <546D18D9.60201@pobox.com> <546E4E6A.3060208@ubuntu.com> <546E6F19.40806@pobox.com>
In-Reply-To: <546E6F19.40806@pobox.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/20/2014 5:45 PM, Robert White wrote:
> Nice attempt at saving face, but wrong as _always_.
> 
> The CONFIG_PATA_ACPI option has been in the kernel since 2008 and
> lots of people have used it.
> 
> If you search for "ACPI ide" you'll find people complaining in
> 2008-2010 about windows error messages indicating the device is
> present in their system but no OS driver is available.

Nope... not finding it.  The closest thing was one or two people who
said ACPI when they meant AHCI ( and were quickly corrected ).  This
is probably what you were thinking of since windows xp did not ship
with an ahci driver so it was quite common for winxp users to have
this problem when in _AHCI_ mode.

> That you "have yet to see a single system that implements it" is
> about the worst piece of internet research I've ever seen. Do you
> not _get_ that your opinion about what exists and how it works is
> not authoritative?

Show me one and I'll give you a cookie.  I have disassembled a number
of acpi tables and yet to see one that has it.  What's more,
motherboard vendors tend to implement only the absolute minimum they
have to.  Since nobody actually needs this feature, they aren't going
to bother with it.  Do you not get that your hand waving arguments of
"you can google for it" are not authoritative?

> You can also find articles about both windows and linux systems
> actively using ACPI fan control going back to 2009

Maybe you should have actually read those articles.  Linux supports
acpi fan control, unfortunately, almost no motherboards actually
implement it.  Almost everyone who wants fan control working in linux
has to install lm-sensors and load a driver that directly accesses one
of the embedded controllers that motherboards tend to use and run the
fancontrol script to manipulate the pwm channels on that controller.
These days you also have to boot with a kernel argument to allow
loading the driver since ACPI claims those IO ports for its own use
which creates a conflict.

Windows users that want to do this have to install a program... I
believe a popular one is called q-fan, that likewise directly accesses
the embedded controller registers to control the fan, since the acpi
tables don't bother properly implementing the acpi fan spec.

Then there are thinkpads, and one or two other laptops ( asus comes to
mind ) that went and implemented their own proprietary acpi interfaces
for fancontrol instead of following the spec, which required some
reverse engineering and yet more drivers to handle these proprietary
acpi interfaces.  You can google for "thinkfan" if you want to see this.

> These are not hard searches to pull off. These are not obscure 
> references. Go to the google box and start typing "ACPI fan..."
> and check the autocomplete.
> 
> I'll skip ovea all the parts where you don't know how a chipset
> works and blah, blah, blah...
> 
> You really should have just stopped at "I don't know" and "I've
> never" because you keep demonstrating that you _don't_ know, and
> that you really _should_ _never_.
> 
> Tell us more about the lizard aliens controlling your computer, I
> find your versions of realty fascinating...

By all means, keep embarrassing yourself with nonsense and trying to
cover it up by being rude and insulting.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUb1YxAAoJEI5FoCIzSKrwi54H/Rkd7DloqC9x9QwN4QdmWcAZ
/UQg3hcRbtB3wpmp34Mnb3SS0Ii2mCh/dtKmdRGBNE/x5nU1WiQEHHCicKX3Avvq
8OXLNQrsf+xZL9/HGtUJ3RefpEkmwIG5NgFfKJHtv6Iq204Umq32JUxRla+ZQE5s
MrUparigpUlj26lrnShc6ByDUqYK3wOTsDxEMxrOyAgi/n/7ESHV/dZVaqsE6jGQ
OvPynf1FqJoJSSYC7sNE0XLqfHMu2wnSxcoF6MpuHXlDiwtrSH07tuwgrhCNPagY
j7gQyxucew8oim8lcfs+4rrQ60wwVzlsEJwjA9rAXQF7U2x/WoB+ArYhgmJUMgA=
=cXJr
-----END PGP SIGNATURE-----
