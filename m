Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpoutz25.laposte.net ([194.117.213.100]:38659 "EHLO
	smtp.laposte.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932250AbbLNMr2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 07:47:28 -0500
Received: from smtp.laposte.net (localhost [127.0.0.1])
	by lpn-prd-vrout013 (Postfix) with ESMTP id 3903D103DF3
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 13:47:26 +0100 (CET)
Received: from lpn-prd-vrin004 (lpn-prd-vrin004.prosodie [10.128.63.5])
	by lpn-prd-vrout013 (Postfix) with ESMTP id 27F1510357F
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 13:47:26 +0100 (CET)
Received: from lpn-prd-vrin004 (localhost [127.0.0.1])
	by lpn-prd-vrin004 (Postfix) with ESMTP id E9C0770E257
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 13:47:25 +0100 (CET)
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <56455073.1060406@cn.fujitsu.com> <564F48FE.4000400@laposte.net>
 <1448047478.6878.4.camel@scientia.net> <564FBF0F.4050705@gmx.com>
 <564FC3FE.9020905@lukas-pirl.de> <565122AA.90904@gmx.com>
 <56519644.8060105@laposte.net> <56526543.4090301@cn.fujitsu.com>
 <565462F7.8040601@laposte.net> <5654F6BC.8020900@gmx.com>
 <565579DB.2040105@laposte.net> <56607848.5040705@laposte.net>
 <5660E2BD.3050000@cn.fujitsu.com> <566ADBF6.9090507@laposte.net>
Cc: Lukas Pirl <btrfs@lukas-pirl.de>, linux-btrfs@vger.kernel.org,
        calestyo@scientia.net
From: Laurent Bonnaud <L.Bonnaud@laposte.net>
Message-ID: <566EBA5D.5030200@laposte.net>
Date: Mon, 14 Dec 2015 13:47:25 +0100
MIME-Version: 1.0
In-Reply-To: <566ADBF6.9090507@laposte.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/12/2015 15:21, Laurent Bonnaud wrote:

> The next step will we to run a "btrfs scrub" to check if data loss did happen...

Scrubbing is now finished and it detected no errors.

-- 
Laurent.
