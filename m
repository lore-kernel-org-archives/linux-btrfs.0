Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab3BNFgl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 00:36:41 -0500
Date: Wed, 13 Feb 2013 21:35:52 -0800
From: Zach Brown <zab@redhat.com>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        chris.mason@fusionio.com, dsterba@suse.cz, kreijack@gmail.com
Subject: Re: [PATCH] Btrfs-progs: check out if the swap device
Message-ID: <20130214053552.GE22221@lenny.home.zabbo.net>
References: <201302120125.AA00019@FM-323941448.jp.fujitsu.com>
 <5119C379.7080305@redhat.com>
 <5119D813.40101@jp.fujitsu.com>
 <511A8228.9060109@redhat.com>
 <20130212205731.GA11872@lenny.home.zabbo.net>
 <511B18BD.7070706@jp.fujitsu.com>
 <20130213215833.GC22221@lenny.home.zabbo.net>
 <511C29B7.9060805@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <511C29B7.9060805@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I think realpath() is unnecessary if it checks it by using only
> stat() information. (if do not compare path)
> 
> Am I misunderstanding anything?

Sure, that'd be fine, but then you'd want to try unescaping the paths
before stati()ng them.

- z
