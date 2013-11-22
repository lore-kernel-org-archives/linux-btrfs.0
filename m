Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56158 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab3KVTu2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 14:50:28 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VjwkF-0000w7-AL
	for linux-btrfs@vger.kernel.org; Fri, 22 Nov 2013 20:50:27 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2013 20:50:27 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2013 20:50:27 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: progs integration branch moved to master (new default leafsize)
Date: Fri, 22 Nov 2013 19:50:17 +0000
Message-ID: <l6oche$7sa$1@ger.gmane.org>
References: <20131108220135.3802.39092@localhost.localdomain> <l5jtgo$6q1$1@ger.gmane.org> <20131121233751.5312.13383@localhost.localdomain> <l6n6l2$ln6$1@ger.gmane.org> <20131122134038.5312.42200@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20131122134038.5312.42200@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 22/11/13 13:40, Chris Mason wrote:
> Quoting Martin (2013-11-22 04:03:41)

>>  * QA Notice: Package triggers severe warnings which indicate that it
>>  *            may exhibit random runtime failures.
>>  * disk-io.c:91:5: warning: dereferencing type-punned pointer will break
>> strict-aliasing rules [-Wstrict-aliasing]
>>  * volumes.c:1930:5: warning: dereferencing type-punned pointer will
>> break strict-aliasing rules [-Wstrict-aliasing]
>>  * volumes.c:1931:6: warning: dereferencing type-punned pointer will
>> break strict-aliasing rules [-Wstrict-aliasing]
> 
> Does gentoo modify the optimizations from the Makefile?  We actually
> have many strict-aliasing warnings, but I didn't think they came up
> until -O2.

For that system, I have -Os set in the Gentoo "make.conf".


> At any rate, I'm adding -fno-strict-aliasing just to be sure.

Good to catch to avoid unexpectedness,


Regards,
Martin



