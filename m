Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553Ab3FXSK6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Jun 2013 14:10:58 -0400
Date: Mon, 24 Jun 2013 11:10:54 -0700
From: Zach Brown <zab@redhat.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 1/8] Btrfs: introduce a tree for items that map UUIDs
 to something
Message-ID: <20130624181054.GD25321@lenny.home.zabbo.net>
References: <cover.1371749051.git.sbehrens@giantdisaster.de>
 <ef484aa41751485fc6301ce78b5e3cddaa3f9a52.1371749051.git.sbehrens@giantdisaster.de>
 <20130620194704.GC32674@lenny.home.zabbo.net>
 <51C41318.8070703@giantdisaster.de>
 <20130621161138.GA25321@lenny.home.zabbo.net>
 <51C876E5.4060802@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51C876E5.4060802@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> >> This would save some CPU cycles for the repeated le64_to_cpu() and for
> >> the memcpy(). The number of lines of code is equal for both ways.
> > 
> > Hmm?  It would be many fewer lines of code.
> 
> Are you thinking of something shorter than the following?

That's better, yeah, but there's still some room left to go.  Almost all
of the remaining code is boiler-plate iteration that could be done with
a for(;;).

This could be a mini OCC contest! :)

> offset = (unsigned long)ptr;
> subid = cpu_to_le64(subid);

> while (sub_item_len > 0) {
> 	if (memcmp_extent_buffer(eb, &subid, offset,
> 				 sizeof(subid)) == 0) {
> 		ret = 0;
> 		break;
> 	}
> 	offset += sizeof(subid);
> 	sub_item_len--;
> }

roughly:

unsigned long end = offset + sub_item_len;

for (ret = 1; offset < end && ret; offset += sizeof(subid))
	ret = !!memcmp_extent_buffer(eb, &subid, offset,
				     sizeof(subid));

- z
