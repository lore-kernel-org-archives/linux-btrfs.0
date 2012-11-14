Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56909 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab2KNCBe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Nov 2012 21:01:34 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so4352783eek.19
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2012 18:01:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121113112002.GA23574@carfax.org.uk>
References: <CAGnBOw-58=g4pZcKC9GYBBJtpaOC_sj2mmQpNS+J6JR9+AY9YQ@mail.gmail.com>
	<CAGnBOw-qpoydiEpgX0dBSh5xdkpZb3HGTMnMO0uYKFL596dM+A@mail.gmail.com>
	<20121113112002.GA23574@carfax.org.uk>
Date: Wed, 14 Nov 2012 10:01:32 +0800
Message-ID: <CAGnBOw-jLCT5r_BLWw4Epd8S5pk2+jDghj9M874cdJah2p9FsA@mail.gmail.com>
Subject: Re: Mixed RAID 1 and 0 in different subvolumes (cont.)
From: Fred Chang <fredchang@qnap.com>
To: Hugo Mills <hugo@carfax.org.uk>, Fred Chang <fredchang@qnap.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear Hugo,
  Thanks so much for your reply.
Sincerely,
Fred

On Tue, Nov 13, 2012 at 7:20 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Tue, Nov 13, 2012 at 06:52:42PM +0800, Fred Chang wrote:
>> Assume I have two disks, said disk1 and disk2, and two subvolumes,
>> said sv1 and sv2. With BTRFS, may I assign sv1 working with raid0 and
>> sv2 working with raid1?
>
>    Not yet. It's planned, but nobody's done it yet.
>
>    Hugo.
>
>> One year ago, this function was not aviliable. If there were test
>> version, I am willing to test it.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>         --- emacs:  Eighty Megabytes And Constantly Swapping. ---
