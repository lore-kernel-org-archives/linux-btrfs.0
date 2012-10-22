Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:55505 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab2JVRoT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 13:44:19 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so1572773wey.19
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 10:44:18 -0700 (PDT)
Message-ID: <508585ED.2010909@gmail.com>
Date: Mon, 22 Oct 2012 19:44:13 +0200
From: Andreas Philipp <philipp.andreas@gmail.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: RAID 5/6
References: <CAGJTRch_o4SDnT+n0WnUfRysj-9T-6GmvsUrSd6XiU6C2JoEsA@mail.gmail.com> <20121022160500.GZ25498@carfax.org.uk>
In-Reply-To: <20121022160500.GZ25498@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 10/22/2012 06:05 PM, Hugo Mills wrote:
> On Mon, Oct 22, 2012 at 10:58:07AM -0500, Michael wrote:
>> Does anyone know when RAID 5/6 are planned to be included in the
>> Kernel?
>
> This is in the FAQ:
>
>
https://btrfs.wiki.kernel.org/index.php/FAQ#Can_I_use_RAID.5B56.5D_on_my_Btrfs_filesystem.3F
>
> Short answer: Not yet, probably soon.
>
>> I am starting to buy parts for my next computer and would very
>> much like to use BTRFS because I want a FS that can grow and also
>> recover from undetected read errors - it will be large enough that
>> these are possible. I'm hoping that it will be available for use in
>> the coming months.
>
> You can switch storage types on the fly, so you could at least
> start with RAID-1, and then restripe to RAID-5 (or -6) when it's
> stable enough for you. This assumes that you can manage to use RAID-1
> in the first place and expand later.
If you can live without redundancy at the beginning, you could also
start with RAID-0, and then restripe to RAID-5.

Andreas

