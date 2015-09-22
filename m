Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34957 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757711AbbIVOnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 10:43:15 -0400
Received: by wicge5 with SMTP id ge5so164859346wic.0
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2015 07:43:14 -0700 (PDT)
Date: Tue, 22 Sep 2015 16:43:12 +0200
From: "S. Fricke" <silvio.fricke@gmail.com>
To: Richard Michael <rmichael@edgeofthenet.org>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: problem with long running btrfs mount operation
Message-ID: <20150922144312.GB14395@sfserver>
References: <20150922133813.GA14395@sfserver>
 <56015D3F.8020406@googlemail.com>
 <CABR0jERXQ9ydE+KAeQBrW5F0DzraePnAyz8m-uVStUCbeFt4WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CABR0jERXQ9ydE+KAeQBrW5F0DzraePnAyz8m-uVStUCbeFt4WQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> On Tue, Sep 22, 2015 at 9:53 AM, Holger Hoffstätte
> <holger.hoffstaette@googlemail.com> wrote:
> > On 09/22/15 15:38, S. Fricke wrote:
> >> I have a problem with one of my btrfs hdds. If I mount it, it needs more than
> >> 135 minutes for this operation. After the mounting it works normaly. This is
> >> reproducible only with this hdd.
> >>
> >> Maybe someone has a clue what is going wrong here.
> >
> > On remount it tries to continue a previously started balance, which fails with
> > an error (as can be seen at the end of your log). You should:
> >
> > a) immediately stop what you're doing on that fs and unmount it
> > b) get btrfs-progs-4.2.1 (not 4.2) and see what it says

What should it say to me? I have to send a command? Should I try to mount the
device after I have unmount it? BTW: Is btrfs-progs needed for mounting?

> >
> > Depending on the outcome of b) you can use -o skip_balance on the next mount.
> >
> > -h
> 
> I'm curious, do the relevant INFO lines also appear earlier in the
> log, near the time the mount began?
> 
> These:
> 
> BTRFS: checking UUID tree
> [  +0.000076] BTRFS info (device sda1): continuing balance
> 
> 
> Otherwise, it requires an unknown amount of patience to diagnose this
> problem -- how long should I wait before giving up?
> 
> It seems to me, from a sysadmin's perspective, the log messages are
> reversed (hung task, 2+ hrs later, BTRFS tells me what it's doing) .
> I'd expect BTRFS to log a "continuing balance" message as soon as I
> mount it, then it's blocked [for as long as I care to wait], but I can
> immediately tell what's happened.

Thats my problem in general with btrfs, and other filesystems, I have a
glitch; I have to wait, but I have no possibilities to look what is going on
on drive X. Okay I could use sysemtaps, has someone good scripts for such
usecase? Or maybe we have other toolings?

Regards,
Silvio

-- 
-- S. Fricke ---------------------------------------- silvio@port1024.net --
   Diplom-Informatiker (FH)
   Linux-Entwicklung             JABBER: silvio@conversation.port1024.net   
----------------------------------------------------------------------------
