Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:45156 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbaASThq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Jan 2014 14:37:46 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfsck does not fix
Date: Sun, 19 Jan 2014 20:37:31 +0100
Message-ID: <6210673.6TYUkLGl6b@merkaba>
In-Reply-To: <52D317CF.2070007@friedels.name>
References: <52C7127F.3060902@friedels.name> <0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com> <52D317CF.2070007@friedels.name>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 12. Januar 2014, 23:31:43 schrieb Hendrik Friedel:
> > It mounts OK with no kernel messages?
> 
> Yes. Here I mount the three subvolumes:

Does scrubbing the volume give any errors?

I´d test this. If scrubbing runs through without errors at least your data is 
currently safe.

As to the error messages: I do not know how critical those are.

I usually just scrub my filesystems once in a while and would only try btrfs 
check on one that fails the scrubbing or has problems mounting or (in some 
cases) yields strange messages in dmesg.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
