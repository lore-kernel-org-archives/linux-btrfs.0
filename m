Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay1.ox.registrar-servers.com ([199.188.203.171]:33748 "EHLO
	relay1.ox.registrar-servers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753735AbbHaSGw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 14:06:52 -0400
Received: from imap1-1.ox.privateemail.com (imap1-1.ox.privateemail.com [198.187.29.239])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay.ox.registrar-servers.com (Postfix) with ESMTPS id 24618B0164
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2015 14:06:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
	by imap1.ox.privateemail.com (Postfix) with ESMTP id 41DCCB00321
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2015 14:06:44 -0400 (EDT)
Received: from imap1.ox.privateemail.com ([127.0.0.1])
	by localhost (imap1.ox.privateemail.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id jIYXRfGoU_vi for <linux-btrfs@vger.kernel.org>;
	Mon, 31 Aug 2015 14:06:44 -0400 (EDT)
Received: from [172.16.7.232] (unknown [132.183.13.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by imap1.ox.privateemail.com (Postfix) with ESMTPSA id EB773B0021B
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2015 14:06:43 -0400 (EDT)
From: =?UTF-8?Q?N=c3=a9stor_Uribe-Patarroyo?= <nesuribe@bloptica.com>
Subject: Kernel bug after changing raid levels
To: linux-btrfs@vger.kernel.org
Reply-To: bloptica.kernel@mailnull.com
Message-ID: <55E497A9.80404@bloptica.com>
Date: Mon, 31 Aug 2015 14:06:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've filed bug https://bugzilla.kernel.org/show_bug.cgi?id=103811 on a 
recent kernel bug I've encountered using btrfs after changing raid level 
online.

Let me know if there's any more info I can provide, I haven't formatted 
that file system yet.
