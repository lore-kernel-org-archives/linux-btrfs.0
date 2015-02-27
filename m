Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361AbbB0QuH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 11:50:07 -0500
Date: Fri, 27 Feb 2015 17:50:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: root subvol id is 0 or 5?
Message-ID: <20150227165005.GH8720@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAH-HCWWVR=g6mZFZyu6wYRfP7Harr5bxokJi+_qW8QHsniFPFg@mail.gmail.com>
 <20141130115908.GF32735@carfax.org.uk>
 <CAH-HCWWk7J6N0M1z=2N__T0TQ1qffORnxdVNrpjGHh1gtQx3dg@mail.gmail.com>
 <CAH-HCWW+dWbiGMNJuOExdy_NudQjPvZ4APp56++zK_k-4VSkaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAH-HCWW+dWbiGMNJuOExdy_NudQjPvZ4APp56++zK_k-4VSkaQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 30, 2014 at 07:12:46PM +0530, Shriramana Sharma wrote:
> On Sun, Nov 30, 2014 at 7:08 PM, Shriramana Sharma <samjnaa@gmail.com> wrote:
> >
> > So why 5 and not just 0 which seems a logical choice? On top of this,
> > one needs to alias 0 to 5!
> 
> Attached patch clarifying this in the documentation. (Should have done
> this with the previous mail. Sorry for multiple mails.)
> 
> -- 
> Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा

> From 54387ff2155423d990b5a9aca95315fe6e649303 Mon Sep 17 00:00:00 2001
> From: Shriramana Sharma <samjnaa@gmail.com>
> Date: Sun, 30 Nov 2014 19:11:39 +0530
> Subject: [PATCH 2/2] btrfs subvolume doc clarifications

Applied, thanks.
