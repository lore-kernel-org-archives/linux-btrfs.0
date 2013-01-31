Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:57064 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756366Ab3AaEQ0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 23:16:26 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [RFC] Move btrfsck in to the btrfs command
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130131101055.44c138d5@natsu>
Date: Wed, 30 Jan 2013 21:16:22 -0700
Cc: Ian Kumlien <pomac@demius.net>, linux-btrfs@vger.kernel.org
Message-Id: <852FE3A8-45AC-41ED-94AC-6B5ADDDD3D0D@colorremedies.com>
References: <1359500633-7219-1-git-send-email-pomac@demius.net> <20130131101055.44c138d5@natsu>
To: Roman Mamedov <rm@romanrm.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 30, 2013, at 9:10 PM, Roman Mamedov <rm@romanrm.ru> wrote:
> 
> How about "btrfs check"?

For that matter, separate out check and repair. Is there a potential for a btrfsck repair to make things worse? And if so, could this be determined with a check?


Chris Murphy