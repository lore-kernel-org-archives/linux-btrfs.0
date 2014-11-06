Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postler.lichtfels.com ([78.46.92.195]:33999 "EHLO
	postler.lichtfels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaKFSDf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Nov 2014 13:03:35 -0500
Received: from localhost (localhost [127.0.0.1])
	by postler.lichtfels.com (Postfix) with ESMTP id AFF92123EE
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Nov 2014 19:03:33 +0100 (CET)
Received: from postler.lichtfels.com ([127.0.0.1])
 by localhost (postler.lichtfels.com [127.0.0.1]) (amavisd-maia, port 10024)
 with LMTP id 32479-05 for <linux-btrfs@vger.kernel.org>;
 Thu,  6 Nov 2014 19:03:31 +0100 (CET)
Received: from [172.32.99.66] (mail.oops.co.at [213.129.238.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by postler.lichtfels.com (Postfix) with ESMTPSA id 57D1B123CE
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Nov 2014 19:03:31 +0100 (CET)
Message-ID: <545BB7F2.9070106@xunil.at>
Date: Thu, 06 Nov 2014 19:03:30 +0100
From: "Stefan G. Weichinger" <lists@xunil.at>
Reply-To: lists@xunil.at
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: "corrupt leaf" on kernel 3.17.2, w/ btrfs-progs 3.17
References: <545B8981.2010603@xunil.at> <545B9D97.3040206@xunil.at> <545B9ECB.1040903@xunil.at>
In-Reply-To: <545B9ECB.1040903@xunil.at>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Copied a tarball of btrfs-progs v 3.17-r1 over and ran:

btrfs check --repair /dev/sda2

it tells me

incorrect offsets 12499 blabla
items overlap, can't fix
cmds-check.c:2918 fix_item_offset: Assertion `ret` failed

... and crashes

Any help appreciated!

