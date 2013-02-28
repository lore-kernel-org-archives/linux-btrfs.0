Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57087 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab3B1Pfb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Feb 2013 10:35:31 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Does defragmenting even work
Date: Thu, 28 Feb 2013 16:35:29 +0100
Cc: =?iso-8859-1?q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
References: <512F6B30.1060409@petaramesh.org> (sfid-20130228_163032_092133_B1BF7529)
In-Reply-To: <512F6B30.1060409@petaramesh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302281635.29702.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 28. Februar 2013 schrieb Swâmi Petaramesh:
> BTW...
> 
> I'm not even sure that "btrfs filesystem defrag <somefile>" actually
> does anything...
> 
> If I run "filefrag <somefile>" afterwards, it typically shows the same
> number of fragments that it did prior to running defrag...
> 
> I'm not sure about how it actually works and what I should expect...

Again:

Make sure that you run "sync" before looking at the extent state with 
filefrag -v

btrfs filesystem defrag may not have *immediate* effect.

I explained and demonstrated it in a response to you in the other thread 
that has been about this.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
