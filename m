Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:44351 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932508AbdJZPzY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 11:55:24 -0400
Received: by mail-io0-f170.google.com with SMTP id m16so6436249iod.1
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 08:55:23 -0700 (PDT)
Subject: Re: btrfs-subv-backup v0.1b
To: Marat Khalili <mkh@rqc.ru>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
References: <cc9e6302-125b-b120-cc45-35a2e12a3d6a@gmail.com>
 <49c49e21-0834-5038-2059-5171a6a154d5@rqc.ru>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <caaa3503-102e-176e-85d0-b9c81a19eea3@gmail.com>
Date: Thu, 26 Oct 2017 11:55:21 -0400
MIME-Version: 1.0
In-Reply-To: <49c49e21-0834-5038-2059-5171a6a154d5@rqc.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-26 11:25, Marat Khalili wrote:
> Hello Austin,
> 
> Looks very useful. Two questions:
> 
> 1. Can you release it under some standard license recognized by github, 
> in case someone wants to include it in other projects? AGPL-3.0 would be 
> nice.
The intent is for it to be under what Github calls the BSD 'new' 
3-clause license, I'll attempt to get it updated so that Github 
recognizes it properly shortly.  It's most likely not matching correctly 
due to the differences between the 'official' version of the license 
text, and the version I pulled out of the Gentoo portage tree on my 
local system (in particular, the portage copy uses numbers instead of 
bullet points, and assumes the project creators will be referenced 
directly in the third clause like in the original BSD licenses, instead 
of in an abstract manner like the text that Github uses).
> 
> 2. I don't understand mentioned restore performance issues. It shouldn't 
> apply if data is restored _after_ subvolume structure is re-created, but 
> even if (1) data is already there, and (2) copyless move doesn't work 
> between subvolumes (really a limitation of some older systems, not 
> Python), there's a known workaround of creating a reflink and then 
> removing the original.
As of right now, if the data is there, it will use the shutil.copytree() 
function to copy it.  This is roughly equivalent to calling `cp -a` on 
the directory in a shell, so it's potentially very slow compared to what 
it could be, and will temporarily duplicate data on-disk.  I hope to 
have it using reflinks eventually, but for the time being, I wanted to 
get something working out there so that people can use it, and then 
worry about improving performance, and I'm still not 100% confident 
about mucking around with ioctls from Python.  I'll get the README 
updated to clarify that the performance issues are only present when 
recreating subvolumes after the data has been restored.

As far as restoring subvolume structure first, that will work too, and I 
should probably mention that in the README file, I just didn't see that 
as being the most likely case (in the backup software I've dealt with, 
it's simpler to just extract everything and run a script afterwards than 
to extract one file, run a script, and then extract the rest).
