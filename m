Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:33351 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbbEUSCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 May 2015 14:02:49 -0400
Received: by iebgx4 with SMTP id gx4so14267177ieb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2015 11:02:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150514173555.GB18480@carfax.org.uk>
References: <1430043165-20641-1-git-send-email-lauri.vosandi@gmail.com>
	<20150426111943.GZ18187@carfax.org.uk>
	<CAJ1pDqR6Q_cfLiKoNKReC1Rx76BkNXj3pY6_CqHeyL3J_hSf6g@mail.gmail.com>
	<20150514173555.GB18480@carfax.org.uk>
Date: Thu, 21 May 2015 21:02:48 +0300
Message-ID: <CAJ1pDqSCcTLDXLkwQ2_YXyQs__cs2RrHZcaHuJHyUYcvn14djg@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: receive explicit parent support
From: lauri <lauri.vosandi@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, lauri <lauri.vosandi@gmail.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dave@jikos.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> My argument is that having this option present will mean that
> people will use it. Getting send/receive right is hard enough as it is
> without giving someone an option which can completely screw things up
> in *most* cases.

I agree that providing workarounds like this is not nice, however considering
the users who are already stuck with the UUID-s of current architecture
should be provided a way to get back on the track with better implementation :)

> The chain rule can (must) be done on the send side. The reference rule
> means that we need both r1 and u1 to be available on the receiving
> side. I haven't checked, but this will probably involve a change to
> the stream format to send r1.

I've also concluded the real solution involves bundling both subvolume
UUID and received UUID with the btrfs stream. This implies btrfs send
stream format change and if I've understood correctly involves kernel
changes as btrfs stream is generated in kernelspace.

>    The other thing that we don't support at all is merging changes
> from divergent snapshots. i.e. snapshot A to B and C, modify both B
> and C, and then later try to merge B and C into D. (Possibly with
> additional sends between all of those stages). This gets into issues
> of semantic merging. I feel entirely justified in telling anyone who
> wants to implement that kind of workflow that it's out of scope for
> send/receive, and referring them to a distributed revision control
> system like git.

I've never suggested merges, when I mentioned Git-like workflow
I was referring to simply push/pull. Obviously implementing
merge is out of the scope of any filesystem ;)




-- 
Lauri Võsandi
tel: +372 53329412
e-mail: lauri.vosandi@gmail.com
blog: http://lauri.vosandi.com/
