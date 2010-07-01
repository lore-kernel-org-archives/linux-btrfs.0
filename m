From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: [PATCH] btrfs-convert: add reiserfs support
Date: Thu, 1 Jul 2010 01:16:40 -0400
Message-ID: <AANLkTinVgAodpgF5Vtlb5W5G-6pCBEAxZFku4XQcriuO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello, I just want to thank you for the ReiserFS convertion patch.

>Now that the semester's over, I've finally gotten around to finishing this.
>Ironically, I no longer have a ReiserFS partition I want to convert :P.
>
On my side I had my root filesystem which has been running for quite a
while, I decided to convert it in an LVM snapshot to see if everything
is fine, seems to be, I'll be trying to convert the real filesystem
soon.

>This depends on my previous four patches for btrfs-convert.
>
I applied the four patch, the correction to patch 2 and finally
reiserfs conversion, compiled, make convert and ran the converter,
took 10 minutes for 25GB.
All data is accessible, and seem accessible. I will try to boot it
then do the real conversion (I will first make a backup :) and let you
know!
