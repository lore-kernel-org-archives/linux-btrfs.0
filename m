Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35844 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbbCRXWX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 19:22:23 -0400
Received: by padcy3 with SMTP id cy3so56389088pad.3
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2015 16:22:23 -0700 (PDT)
Subject: Re: syntax for deleting subvolumes?
To: Chris Murphy <lists@colorremedies.com>
references: <5509E34F.6010504@graphitesystems.com>
 <CAJCQCtSmV63H4OnEgv2ZXSFq4s8npEGmDxUBDO5dHb7pmoC0zw@mail.gmail.com>
 <5509F08E.6070702@graphitesystems.com>
 <CAJCQCtQU=KzNqY=MTdqET5-J2JpDrS+O9EE50o9aXbRCJHU+xQ@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: K Richard Pixley <rpixley@graphitesystems.com>
message-id: <550A08AC.7070506@graphitesystems.com>
Date: Wed, 18 Mar 2015 16:22:20 -0700
mime-version: 1.0
in-reply-to: <CAJCQCtQU=KzNqY=MTdqET5-J2JpDrS+O9EE50o9aXbRCJHU+xQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/18/15 15:15 , Chris Murphy wrote:
> On Wed, Mar 18, 2015 at 3:39 PM, K Richard Pixley
> <rpixley@graphitesystems.com> wrote:
>
>> Ah!  Thank you.  That's the piece I was missing.
>>
>> IMO, someone needs to take a clue-by-four to the heads of the
>> Fedora/RHEL/CentOS installer folks.  I see no reason for this with btrfs.
> Other than the technical reasons Hugo mentions regarding nesting...
>
> The problem with the "install normally to top level with Linux FHS"
> approach like Ubuntu and openSUSE follow now, is that snapshots then
> have to go in the mounted path. This arguably exposes old binaries in
> that mounted path and is a possible security risk. There are some ways
> to mitigate that, but better when it's simply not in the mounted path,
> sorta like a chroot.
>
> It's also a better way to organize stateless systems. Myriad trees
> that can be used to form a stateless system existing "out of tree" and
> mounted either by path or subvolid is more sane (or at least less
> madness inducing) than alternatives. See under "what we propose" for
> the subvol naming convention:
> http://0pointer.net/blog/revisiting-how-we-put-together-linux-systems.html
>
> This is also compatible with delivery of such systems with a btrfs seed device.
I see.  Thanks for the education.

I'm not sure what I think about the possible security risk, but I hear 
the concern.

Most of the uses I have for btrfs involve fairly dynamic use of 
snapshots, typically by non-root users. That's what brought me to btrfs 
in the first place and continues to be the biggest driver for me.

Because of this, the top level file system would need to be mounted 
pretty much constantly, which essentially removes any benefit from the 
redundant top level subvol.  It's just a nuisance for my applications.  
And most of my applications try very hard to avoid mounting the 
snapshots.  That takes too much time and isn't reentrant.

It seems to me that it depends on whether you think of snapshots as a 
system admin sort of facility or as a user facility.  As a system admin 
facility, you're probably right.  But as a user level facility, I want 
to be able to snapshot before making a change to a tree full of source 
code and (re)building it all over again.  I may want to keep my new 
build, but I may want to flush it and return to known good state.  It's 
pretty easy to open that facility up to non-root users but the easiest 
way to do that that I've found is to use a single file system on root 
mounted directly.  For an individual user, this can easily save hours 
and hundreds of gigabytes.  For automated build systems, it can mean a 
few orders of magnitude difference in typical build times.

It's not clear to me yet how to set machines up this way from kickstart, 
which makes this scheme look like an impediment, rather than a feature.  
But maybe all I need is an easy way to shut it off and get the more 
familiar arrangement.

--rich
