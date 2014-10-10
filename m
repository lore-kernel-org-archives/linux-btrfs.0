Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:1757 "EHLO
	srv2.trombetti.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbaJJRoG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 13:44:06 -0400
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: SASL)
	by srv2.trombetti.net (Postfix) with ESMTPSA id CDA9B313AB
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:56:52 -0400 (EDT)
Message-ID: <54381ADB.2030002@shiftmail.org>
Date: Fri, 10 Oct 2014 19:43:55 +0200
From: Bob Marley <bobmarley@shiftmail.org>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: What is the vision for btrfs fs repair?
References: <54358C77.2070808@redhat.com> <9251D9EB-5B12-4885-8C6B-FFA10B1CDA24@colorremedies.com> <5437BAB2.1040605@shiftmail.org> <93B9D2BD-1F0F-4C94-899F-16A3A2A0D57E@colorremedies.com>
In-Reply-To: <93B9D2BD-1F0F-4C94-899F-16A3A2A0D57E@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/10/2014 16:37, Chris Murphy wrote:
> The fail safe behavior is to treat the known good tree root as the default tree root, and bypass the bad tree root if it cannot be repaired, so that the volume can be mounted with default mount options (i.e. the ones in fstab). Otherwise it's a filesystem that isn't well suited for general purpose use as rootfs let alone for boot.
>

A filesystem which is suited for "general purpose" use is a filesystem 
which honors fsync, and doesn't *ever* auto-roll-back without user 
intervention.

Anything different is not suited for database transactions at all. Any 
paid service which has the users database on btrfs is going to be at 
risk of losing payments, and probably without the company even knowing. 
If btrfs goes this way I hope a big warning is written on the wiki and 
on the manpages telling that this filesystem is totally unsuitable for 
hosting databases performing transactions.

At most I can suggest that a flag in the metadata be added to 
allow/disallow auto-roll-back-on-error on such filesystem, so people can 
decide the "tolerant" vs. "transaction-safe" mode at filesystem creation.

