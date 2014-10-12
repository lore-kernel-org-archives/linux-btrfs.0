Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:33003 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaJLKOE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Oct 2014 06:14:04 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: What is the vision for btrfs fs repair?
Date: Sun, 12 Oct 2014 12:14:01 +0200
Message-ID: <2313804.P0rE2GFdbV@merkaba>
In-Reply-To: <93B9D2BD-1F0F-4C94-899F-16A3A2A0D57E@colorremedies.com>
References: <54358C77.2070808@redhat.com> <5437BAB2.1040605@shiftmail.org> <93B9D2BD-1F0F-4C94-899F-16A3A2A0D57E@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 10. Oktober 2014, 10:37:44 schrieb Chris Murphy:
> On Oct 10, 2014, at 6:53 AM, Bob Marley <bobmarley@shiftmail.org> wrote:
> > On 10/10/2014 03:58, Chris Murphy wrote:
> >>> * mount -o recovery
> >>> 
> >>> 	"Enable autorecovery attempts if a bad tree root is found at mount
> >>> 	time."
> >> 
> >> I'm confused why it's not the default yet. Maybe it's continuing to
> >> evolve at a pace that suggests something could sneak in that makes
> >> things worse? It is almost an oxymoron in that I'm manually enabling an
> >> autorecovery
> >> 
> >> If true, maybe the closest indication we'd get of btrfs stablity is the
> >> default enabling of autorecovery.> 
> > No way!
> > I wouldn't want a default like that.
> > 
> > If you think at distributed transactions: suppose a sync was issued on
> > both sides of a distributed transaction, then power was lost on one side,
> > than btrfs had corruption. When I remount it, definitely the worst thing
> > that can happen is that it auto-rolls-back to a previous known-good
> > state.
> For a general purpose file system, losing 30 seconds (or less) of
> questionably committed data, likely corrupt, is a file system that won't
> mount without user intervention, which requires a secret decoder ring to
> get it to mount at all. And may require the use of specialized tools to
> retrieve that data in any case.
> 
> The fail safe behavior is to treat the known good tree root as the default
> tree root, and bypass the bad tree root if it cannot be repaired, so that
> the volume can be mounted with default mount options (i.e. the ones in
> fstab). Otherwise it's a filesystem that isn't well suited for general
> purpose use as rootfs let alone for boot.

To understand this a bit better:

What can be the reasons a recent tree gets corrupted?

I always thought with a controller and device and driver combination that 
honors fsync with BTRFS it would either be the new state of the last known 
good state *anyway*. So where does the need to rollback arise from?

That said all journalling filesystems have some sort of rollback as far as I 
understand: If the last journal entry is incomplete they discard it on journal 
replay. So even there you use the last seconds of write activity.

But in case fsync() returns the data needs to be safe on disk. I always 
thought BTRFS honors this under *any* circumstance. If some proposed 
autorollback breaks this guarentee, I think something is broke elsewhere.

And fsync is an fsync is an fsync. Its semantics are clear as crystal. There 
is nothing, absolutely nothing to discuss about it.

An fsync completes if the device itself reported "Yeah, I have the data on 
disk, all safe and cool to go". Anything else is a bug IMO.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
