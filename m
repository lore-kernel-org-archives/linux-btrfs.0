Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.97.166]:51917 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaK0A23 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 19:28:29 -0500
Date: Thu, 27 Nov 2014 05:28:26 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Robert White <rwhite@pobox.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can't cp --reflink files on a Ext4-converted FS w/o checksums
Message-ID: <20141127052826.04bb45f5@natsu>
In-Reply-To: <54766E5C.8010909@pobox.com>
References: <20141127005527.42a7fe59@natsu>
	<54765FC2.2050309@pobox.com>
	<20141127043337.198d6084@natsu>
	<54766E5C.8010909@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 26 Nov 2014 16:20:44 -0800
Robert White <rwhite@pobox.com> wrote:

> I did some double checking and I think you'll find that if you lsattr 
> those files they still have the C (NoCOW) attribute, which also means 
> they are still unsummed.

Indeed, I looked at the top level only, which had just directories.

> (Trying to clear the NOCOW attribute on a file in BTRFS is _silently_ 
> ignored as invalid. That recursive removal only changed the directories.)

And the chattr command even completes with a zero exit code, this is rather
unexpected.

$ lsattr 0000\ MP3.m3u; chattr -C 0000\ MP3.m3u && echo Yay; lsattr 0000\ MP3.m3u 
---------------C 0000 MP3.m3u
Yay
---------------C 0000 MP3.m3u


-- 
With respect,
Roman
