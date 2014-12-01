Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58394 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbaLAJeB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 04:34:01 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XvNMl-0002ok-OG
	for linux-btrfs@vger.kernel.org; Mon, 01 Dec 2014 10:33:59 +0100
Received: from 94.250.180.197 ([94.250.180.197])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 10:33:59 +0100
Received: from gour by 94.250.180.197 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 10:33:59 +0100
To: linux-btrfs@vger.kernel.org
From: Gour <gour@atmarama.net>
Subject: Re: pro/cons of raid1 with mdadm/lvm2
Date: Mon, 1 Dec 2014 10:33:46 +0100
Message-ID: <20141201103346.5ced6500@atmarama>
References: <20141130121147.45884217@atmarama>
	<20141201104236.1506b0a9@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 1 Dec 2014 10:42:36 +0500
Roman Mamedov <rm@romanrm.net> wrote:

> Pros:

[...]

> Con:
> 
>   * You only get the ability to recover from a checksum failure with
> Btrfs RAID1, not with mdadm RAID1 (see Russell's reply).

For the reasons you mentioned I'll keep my root under btrfs' native raid
and do some more thinking in regard to /home and possibility to use XFS
for it.


Sincerely,
Gour

-- 
Abandoning all attachment to the results of his activities, 
ever satisfied and independent, he performs no fruitive action, 
although engaged in all kinds of undertakings.


