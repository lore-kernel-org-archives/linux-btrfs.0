Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49785 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753730AbaAaETd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 23:19:33 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: =?windows-1252?Q?Re=3A_Snapshots_=96_noob_questions?=
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52EABE29.6080703@gmail.com>
Date: Thu, 30 Jan 2014 21:19:30 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <361ADB59-CE32-4A2E-8DB3-CDB8272761F2@colorremedies.com>
References: <52E664E0.5070909@gmail.com> <3022B1A5-391E-431C-B5F9-2BE9206B8578@colorremedies.com> <52E808CB.9020005@gmail.com> <ABFB6A50-ACAF-4BAA-8A93-4BC4CB6D0D65@colorremedies.com> <52EABE29.6080703@gmail.com>
To: KC <impactoria@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I wrote:

> They could just as well go in a directory called .snapshots, off hand I'm not thinking of an advantage of putting snapshots into a subvolume.

There isn't an advantage with a top level 5 subvolume being used for rootfs. But if it's not being mounted, rather other named subvolumes are, then the advantage of a subvolume for snapshots is that it can be independently mounted to provide access to all snapshots within from which to create derivative snapshots. And it can also have a nosuid or noexec mount option to prevent old vulnerabilities from being root executable.


Chris Murphy

