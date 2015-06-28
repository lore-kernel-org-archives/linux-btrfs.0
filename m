Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f52.google.com ([209.85.216.52]:33824 "EHLO
	mail-vn0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbbF1Qpx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Jun 2015 12:45:53 -0400
Received: by vnbf1 with SMTP id f1so2753528vnb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jun 2015 09:45:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+xOVSNu547eo6TY_mwLypTGWuE5AmyMqC6GwR06Sir1282vqA@mail.gmail.com>
References: <CA+xOVSOD1YY-=Cm+vmzTUV9cHe9idtDkRr0RmpRP5a0Z6eC4YQ@mail.gmail.com>
	<CA+xOVSNu547eo6TY_mwLypTGWuE5AmyMqC6GwR06Sir1282vqA@mail.gmail.com>
Date: Sun, 28 Jun 2015 10:45:52 -0600
Message-ID: <CAJCQCtSv15DVDju7vhm=Luc5hqWvce__F7iovh87uxq37bNg0Q@mail.gmail.com>
Subject: Re: btrfs replace seems to corrupt the file system
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 27, 2015 at 5:17 PM, Mordechay Kaganer <mkaganer@gmail.com> wrote:

> # uname -a
> Linux <hostname> 3.16.0-41-generic #57~14.04.1-Ubuntu SMP Thu Jun 18
> 18:01:13 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>
> # btrfs --version
> Btrfs v3.12

Well it's over a weekend so many devs may not get around to responding
until Monday, if it's urgent then IRC is probably better. But the
thing is, the kernel and btrfs-progs are kinda old. So I'm reasonably
sure the suggestion is going to be first to upgrade both of them, it's
sorta par for the course with Btrfs problems.

Option A: Maybe someone has advice on how to get the demoted device to
be valid again as if the replace command hadn't been used. Because
then you could try the replace again with newer kernel and progs, and
see if the problem still happens. That's a good question to ask on IRC
if you don't have a response by tomorrow.

Option B: In the meantime, start to check some files to see if they're
actually corrupt or if these csum errors are bogus.

Option C: Well, it's a backup so actually before A or B it's probably
best to start making a new backup in case this one is beyond repair.
So hopefully you have a 3rd location to put it into so you can keep
both of these Btrfs volumes in their current states until you have a
more clear idea what to do with them, but at least you're not delaying
getting a current backup in place. Whether this new backup is Btrfs
based or not is less important than actually having a backup.




-- 
Chris Murphy
