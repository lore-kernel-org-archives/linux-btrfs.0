Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mta02.helmholtz-muenchen.de ([146.107.4.101]:39775 "EHLO
        mta02.helmholtz-muenchen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753784AbdJaTyk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 15:54:40 -0400
Date: Tue, 31 Oct 2017 20:54:35 +0100 (CET)
From: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Btrfs ML <linux-btrfs@vger.kernel.org>
Message-ID: <2032233997.441324.1509479675722.JavaMail.zimbra@helmholtz-muenchen.de>
In-Reply-To: <56f78e50-bfc1-66cc-141e-41cfa446f855@gmail.com>
References: <cc9e6302-125b-b120-cc45-35a2e12a3d6a@gmail.com> <973325765.400970.1509453637439.JavaMail.zimbra@helmholtz-muenchen.de> <a9accdcd-9f0a-86a2-64a9-faaf19d882cd@gmail.com> <551550025.428652.1509468869372.JavaMail.zimbra@helmholtz-muenchen.de> <56f78e50-bfc1-66cc-141e-41cfa446f855@gmail.com>
Subject: Re: btrfs-subv-backup v0.1b
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

----- On Oct 31, 2017, at 6:00 PM, Austin S. Hemmelgarn ahferroin7@gmail.com wrote:

> Assuming you're careful about how you install it (that is, put it in a
> custom prefix that isn't in $PATH), you could always build a local
> version of Python.  Once you've got that, it's pretty trivial to change
> the #! line at the beginning of the script to point to the appropriate
> location.
> 
> For what it's worth, it shouldn't be _too_ hard to get the script
> working with Python 2.7.  The only big syntax difference that's liable
> to be an issue is the except clauses.  I'll take a look at this and see
> if I can't get it working for both 3.X and 2.7.

Austin,

do i understand correctly what i've read on github, that your script is worthless for SLES because they mount the subvolumes ?
"this of course does not work if you explicitly mount subvolumes, but the only distro I know of that does that is SUSE, and they do their own thing anyway."

Bernd
 

Helmholtz Zentrum Muenchen
Deutsches Forschungszentrum fuer Gesundheit und Umwelt (GmbH)
Ingolstaedter Landstr. 1
85764 Neuherberg
www.helmholtz-muenchen.de
Aufsichtsratsvorsitzende: MinDir'in Baerbel Brumme-Bothe
Geschaeftsfuehrer: Prof. Dr. Guenther Wess, Heinrich Bassler, Dr. Alfons Enhsen
Registergericht: Amtsgericht Muenchen HRB 6466
USt-IdNr: DE 129521671

