Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45990 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932435AbaLKJBp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 04:01:45 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xyzd1-00059v-Fk
	for linux-btrfs@vger.kernel.org; Thu, 11 Dec 2014 10:01:43 +0100
Received: from coffee.modeemi.fi ([130.230.72.140])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 10:01:43 +0100
Received: from flux-btrfs by coffee.modeemi.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 10:01:43 +0100
To: linux-btrfs@vger.kernel.org
From: Erkki Seppala <flux-btrfs@inside.org>
Subject: Re: out of space warning?
Date: Thu, 11 Dec 2014 11:01:33 +0200
Message-ID: <m49iohiblw2.fsf@coffee.modeemi.fi>
References: <CAAe=sHXGpiZN5hKmzv1ynY8x=rH9tMvx86HZP2veLRpAFJN+wg@mail.gmail.com>
	<5488F370.2060604@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White <rwhite@pobox.com> writes:

> You don't check your car's gas tank every time you put your foot on
> the brake, you don't want to check your free space every time your
> system finishes every tiny command you type.

Well, actually my car makes a bling every 10 km once it reaches <=80 km
range, and I don't mind it at all ;-).

As an actual answer, there are monitoring systems that do this, such as
Icinga (fork of Nagios). In fact, I just recently had the same problem -
starting a big download might eat up the space and thus terminate the
download prematurely although I was in position for hours to make up
more space, so I installed Icinga. Haven't yet configured yet, though,
so cannot say if it's going to help me :-).

A practical alternative: one could write a script that outputs only the
amount of free space in a device and add that number to your prompt;
possibly to your RPROMPT as to now take too much space from your command
line. Idea extensible to displaying only space from volumes with space
less than a critical amount etc.

-- 
  _____________________________________________________________________
     / __// /__ ____  __               http://www.modeemi.fi/~flux/\   \
    / /_ / // // /\ \/ /                                            \  /
   /_/  /_/ \___/ /_/\_\@modeemi.fi                                  \/

