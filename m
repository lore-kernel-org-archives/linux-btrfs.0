Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33409 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbdGGQuI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Jul 2017 12:50:08 -0400
Date: Fri, 7 Jul 2017 09:50:06 -0700
From: Marc MERLIN <marc@merlins.org>
To: Omar Sandoval <osandov@osandov.com>,
        Cerem Cem ASLAN <ceremcem@ceremcem.net>
Cc: linux-btrfs@vger.kernel.org, pwnall@chromium.org
Subject: Re: Leveldb in google-chrome incompatible with btrfs?
Message-ID: <20170707165006.GC6083@merlins.org>
References: <20170707054608.GA28035@vader> <CAN4oSBe8x3jpMGzdo2F2unqvNT7V+P4VxkaWG3df4DDY+q=TRA@mail.gmail.com> <20170706150046.GB12959@merlins.org> <20170706211320.GA12206@vader.DHCP.thefacebook.com> <20170706212422.GH30689@merlins.org> <20170706230141.GA22242@vader.DHCP.thefacebook.com> <20170706233152.GI30689@merlins.org> <20170706234451.GB22242@vader.DHCP.thefacebook.com> <20170706235939.GJ30689@merlins.org> <20170707054608.GA28035@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAN4oSBe8x3jpMGzdo2F2unqvNT7V+P4VxkaWG3df4DDY+q=TRA@mail.gmail.com> <20170707054608.GA28035@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(removing pwnall at chromium.org to cut spam)

On Thu, Jul 06, 2017 at 10:46:08PM -0700, Omar Sandoval wrote:
> ┌[osandov@vader ~/.config]
> └$ ls -al google-chrome-busted/**
> ls: cannot access 'google-chrome-busted/Local State': No such file or directory
> google-chrome-busted/Default:
> ls: cannot access 'google-chrome-busted/Default/Preferences': No such file or directory
> ls: cannot access 'google-chrome-busted/Default/.com.google.Chrome.VfAUNx': No such file or directory
> total 0
> drwx------ 1 osandov users 12 Feb  7 16:50 .
> drwx------ 1 osandov users 14 Feb  7 16:50 ..
> -????????? ? ?       ?      ?            ? .com.google.Chrome.VfAUNx
> -????????? ? ?       ?      ?            ? Preferences

Yeah, that's definitely not chrome's fault :)

On Fri, Jul 07, 2017 at 06:05:39PM +0300, Cerem Cem ASLAN wrote:
> I was also struggling with this issue for quite some time. Today my 2
> months old disk is crashed (which really surprises me). It doesn't
> even being shown by `fdisk -l`.
> 
> After buying this this disk, I installed a Debian on a BTRFS partition
> on an LVM partition on a LUKS partition. From that day till today,
> while doing my work, there was always a video running on Youtube in
> the background. Sometimes my editor (atom, it also shares a lot with
> chromium) was slowing down which was making me end up restarting the
> Chromium (and it was restarting barely with `killall -9 chromium`.
> Another mentionable event is, 3 days ago my laptop suddenly restarted.

Sorry, I'm not quite making sense out of this.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
