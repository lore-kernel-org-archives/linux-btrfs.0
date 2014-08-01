Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:60129 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaHAB61 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 21:58:27 -0400
Received: by mail-vc0-f178.google.com with SMTP id la4so5636958vcb.37
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jul 2014 18:58:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140731191240.GQ31950@carfax.org.uk>
References: <CAPDOMVi7fS9zwpZcENiSxhWWn02VfV5H9qnHrK-4kfjLW1zaXg@mail.gmail.com>
	<20140731191240.GQ31950@carfax.org.uk>
Date: Thu, 31 Jul 2014 21:58:26 -0400
Message-ID: <CAPDOMViWLoCaizZAzS3h81Pi106AY24sLfwGtVsG1sHQoAm9_g@mail.gmail.com>
Subject: Re: Implement new FALLOC_FL_* modes
From: Nick Krause <xerofoify@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Nick Krause <xerofoify@gmail.com>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 31, 2014 at 3:12 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Thu, Jul 31, 2014 at 02:08:15PM -0400, Nick Krause wrote:
>> I am doing this project from the btrfs wiki, since I am new after
>> reading the code using lxr I am wondering if
>> we can base the code off that already in ext4 for these modes as they
>> seem to work rather well. I am wondering
>> through as a newbie some of the data structures are ext4 based and the
>> same goes for some of the functions.
>> I am wondering what the equivalent structures and functions are in
>> btrfs as I can't seem to find them after reading
>> the code as a newbie for the last few hours in lxr. Maybe I just
>> missing something?
>
>    The fundamental on-disk structures for btrfs and ext4 are totally
> different. You will get very confused if you expect the ext4 code to
> work in the btrfs module, or even if you expect structures to be
> similar.
>
>    But first -- answer my questions in the reply I made to your patch
> just now. Do nothing else until you can answer all three of those
> questions sensibly.
>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>         --- Great films about cricket:  200/1: A Pace Odyssey ---

I believed I answered your questions , seems I need to fucking test my patches.
And about the reply about data structures , thanks seems the other fallocate
functions are there and I need to read these first , I sent out my patch by
accident as I didn't realize I have removed the error return by mistake.
Sorry Nick
