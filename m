Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eagle.jhcloos.com ([207.210.242.212]:50954 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab2LAXDf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Dec 2012 18:03:35 -0500
From: James Cloos <cloos@jhcloos.com>
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: David Rientjes <rientjes@google.com>
Subject: Re: Likely mem leak in 3.7
In-Reply-To: <m31ufrg3d4.fsf@carbon.jhcloos.org> (James Cloos's message of
	"Sat, 17 Nov 2012 19:29:18 -0500")
References: <m3r4nuwipl.fsf@carbon.jhcloos.org>
	<alpine.DEB.2.00.1211161115001.2788@chino.kir.corp.google.com>
	<m31ufrg3d4.fsf@carbon.jhcloos.org>
Date: Sat, 01 Dec 2012 17:48:28 -0500
Message-ID: <m38v9he6cq.fsf@carbon.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've extensively tested 2844a48706e5 (tip at the time I compiled) for
the last few days and have been unable to reproduce.

This bug appears to be fixed.

Thanks.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
