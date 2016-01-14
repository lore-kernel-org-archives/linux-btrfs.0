Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:46922 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbcANNsi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 08:48:38 -0500
Subject: Re: Btrfs progs pre-release 4.4-rc1
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
References: <20160114124748.GV4227@suse.cz>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <5697A734.1000700@googlemail.com>
Date: Thu, 14 Jan 2016 14:48:36 +0100
MIME-Version: 1.0
In-Reply-To: <20160114124748.GV4227@suse.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/14/16 13:47, David Sterba wrote:
[..]
> * free space tree (aka space_cache=v2, kernel 4.5+)

I'd like to suggest to maybe add a BIG WARNING to the release notes that
enabling the fst will currently prevent btrfsck from fixing a filesystem,
due to the incompatible feature flag.

-h

