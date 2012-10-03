Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62867 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab2JCGWH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 02:22:07 -0400
Received: by eekb15 with SMTP id b15so3658390eek.19
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Oct 2012 23:22:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121002234637.GF3214@shiny>
References: <1349202970-6700-1-git-send-email-kreijack@gmail.com>
	<20121002234637.GF3214@shiny>
Date: Wed, 3 Oct 2012 08:22:06 +0200
Message-ID: <CAJHuE_BmvmEteSg8YgcHH3cuB27Bi-j-B=yS7Y2NFhb1L5_Aog@mail.gmail.com>
Subject: Re: [PATCH][BTRFS-PROGS] btrfs filesystem disk-usage
From: Goffredo Baroncelli <kreijack@gmail.com>
To: Chris Mason <chris.mason@fusionio.com>,
        Goffredo Baroncelli <kreijack@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Hugo Mills <hugo@carfax.org.uk>, Roman Mamedov <rm@romanrm.ru>,
        =?ISO-8859-1?Q?S=E9bastien_Maury?= <sebastien.maury@inserm.fr>,
        Goffredo Baroncelli <kreijack@inwind.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 3, 2012 at 1:46 AM, Chris Mason <chris.mason@fusionio.com> wrote:
[...]
> I like it, thanks.  Could you please update btrfs fi df to show this
> instead of adding a new command though?

Hi Chris,
no problem to update the patches, however I have one suggestion:
- leave "btrfs fi df" as is to no break any script (if any) which
would uses it. Hide it from the help and deprecating it in the man
page. This because the output is very different.
- renaming "btrfs fi disk-usage" in "btrfs fi disk-free", which make sense.

Let me know which choiche you prefer.

BR
G.Baroncelli






>
> -chris
