Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp5.hushmail.com ([65.39.178.142]:58801 "EHLO
	smtp5.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbbDSNvM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Apr 2015 09:51:12 -0400
Received: from smtp5.hushmail.com (localhost [127.0.0.1])
	by smtp5.hushmail.com (Postfix) with SMTP id 5587E60165
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2015 13:51:11 +0000 (UTC)
Received: from smtp.hushmail.com (w8.hushmail.com [65.39.178.52])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp5.hushmail.com (Postfix) with ESMTPS
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2015 13:51:11 +0000 (UTC)
MIME-Version: 1.0
Date: Sun, 19 Apr 2015 15:51:10 +0200
To: linux-btrfs@vger.kernel.org
Subject: Re: Background corrections don't show up in device stats, and have low syslog priority. How do I reliably find out about them?
From: ivarun_ml@nym.hush.com
In-Reply-To: <pan.2015.04.17.20.35.59@googlemail.com>
References: <20150417194609.1192EA03BC@smtp.hushmail.com> <pan.2015.04.17.20.35.59@googlemail.com> 
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20150419135111.16D86E042D@smtp.hushmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/17/2015 at 10:36 PM, "Holger Hoffstaette" <holger.hoffstaette@googlemail.com> wrote:
>I don't know about the device stats, but at least the log level for
>read errors was already fixed in a patch series:
>
>http://www.spinics.net/lists/linux-btrfs/msg40556.html
>
>This was merged into 4.0.

Thanks! Very narrow coincidence that openSUSE tumbleweed was still on 3.19.3 instead of 4.0 when I ran my test :-).

I would still be interested to know whether we can expect the device stats to be updated in the future, or if the syslog will be the best way to look up these numbers. Finding out how many errors there have been of the different kinds per device would be much easier to do through device stats rather than searching the syslog.

Regards,
Ivar Ursin Nikolaisen

