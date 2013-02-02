Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pipebreaker.pl ([109.107.25.67]:53239 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3BBV6z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Feb 2013 16:58:55 -0500
Date: Sat, 2 Feb 2013 22:51:53 +0100
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: cannot mount with acl
Message-ID: <20130202215153.GA27997@mother.jarsat.pl>
References: <201302021503.48064.csights@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201302021503.48064.csights@fastmail.fm>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 02, 2013 at 03:03:48PM -0600, CSights wrote:
> Hello,
>   btrfs is failing to mount if I use the mount option acl.

  There is no such option. ACLs are enabled by default, you can
only disable them with "noacl" option.

-- 
Tomasz Torcz               "Never underestimate the bandwidth of a station
xmpp: zdzichubg@chrome.pl    wagon filled with backup tapes." -- Jim Gray

