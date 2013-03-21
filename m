Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f47.google.com ([209.85.212.47]:60832 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab3CUGVD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 02:21:03 -0400
Received: by mail-vb0-f47.google.com with SMTP id e21so1646129vbm.6
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2013 23:21:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130320232956.GD31559@twin.jikos.cz>
References: <CADCGFBVwqqLc40TWn6cX_2y4bZGKMbW4hRAt6CmLTWfsxknPzg@mail.gmail.com>
	<20130320232956.GD31559@twin.jikos.cz>
Date: Wed, 20 Mar 2013 23:21:01 -0700
Message-ID: <CAPkEcwhTvRAw4kDGMmA2Fa-K-w=QoAvQGu-tvpmhOY+NFe36QA@mail.gmail.com>
Subject: Re: Fwd: +1 for xz
From: james northrup <northrup.james@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

with lzo, and presumably lz4 the 128k extents of packed data are livable.
on bootable thumbdrive images esp. with merged metadata I think
favoring greater fragmentation vs. the current 128k would help, and
giving larger files momentum to occupy more than 128k extents would
also help.

On Wed, Mar 20, 2013 at 4:29 PM, David Sterba <dsterba@suse.cz> wrote:
> On Wed, Mar 20, 2013 at 01:27:11PM -0600, Roger Pack wrote:
>> I see from https://btrfs.wiki.kernel.org/index.php/Compression#How_do_I_enable_compression.3F
>> "LZ4" support is currently being added.  Here's my +1 for also adding
>> something with "high" compression like xz or lzma, since they

> First tests showed that it was really slow for normal use, but for
> backup purposes it might be not that bad.
