Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:44021 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750777AbaFDTdC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jun 2014 15:33:02 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:61437 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WsGvl-001qhS-MI
	for linux-btrfs@vger.kernel.org; Wed, 04 Jun 2014 13:33:01 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: What to do about snapshot-aware defrag
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <lmn64l$s0g$1@ger.gmane.org>
Date: Wed, 4 Jun 2014 13:33:00 -0600
Message-Id: <CAA97D0B-91E9-43C5-80E7-EC86DF354583@colorremedies.com>
References: <5388ED6B.8000706@fb.com> <lmav1p$ih7$1@ger.gmane.org> <538C7A79.8070407@fb.com> <lmln77$ee0$1@ger.gmane.org> <m49fvjlghh2.fsf@coffee.modeemi.fi> <lmn64l$s0g$1@ger.gmane.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 4, 2014, at 7:15 AM, Martin <m_btrfs@ml1.co.uk> wrote:
> 
> Consider using noatime as a /default/ being as there are no known
> 'must-use' use cases.

The quote I'm finding on the interwebs is POSIX  “requires that operating systems maintain file system metadata that records when each file was last accessed". I'm not sure if upstream kernel projects aim for LSB (and thus POSIX) compliance by default and let distros opt out; or the opposite.

> Those users still wanting atime can add that as a
> mount option with the note that atime use reduces the snapshot defrag
> effectiveness.

I can imagine some optimizations for Btrfs that are easier than other file systems, like a way to point metadata chunks to specific devices, for example metadata to persistent memory, while the data goes to conventional hard drives.


Chris Murphy

