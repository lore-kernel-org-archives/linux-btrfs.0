Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58132 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab2ISIcp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Sep 2012 04:32:45 -0400
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 55FE23EE0AE
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:44 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 3B57B45DE59
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:44 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 237F045DE56
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:44 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 17D191DB804F
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:44 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id C2D551DB8046
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:43 +0900 (JST)
Received: from m1000.css.fujitsu.com (m1000 [127.0.0.1])
	by m1000.s.css.fujitsu.com (Postfix) with ESMTP id 9DD8B61069
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:43 +0900 (JST)
Received: from [127.0.0.1] (unknown [10.124.101.112])
	by m1000.s.css.fujitsu.com (Postfix) with ESMTP id 6E8F760FB7
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:43 +0900 (JST)
Message-ID: <50598320.4060501@jp.fujitsu.com>
Date: Wed, 19 Sep 2012 17:32:32 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs-progs: add mount-option command
References: <5057CDA7.3090201@jp.fujitsu.com> <5057CEA9.3070707@jp.fujitsu.com> <20120918123018.GA17430@twin.jikos.cz>
In-Reply-To: <20120918123018.GA17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2012/09/18 21:30), David Sterba wrote:
> On Tue, Sep 18, 2012 at 10:30:17AM +0900, Hidetoshi Seto wrote:
...
> 
> So, you're basically implementing subset of the whole-filesystem
> options. As has been mentioned, alternate way is to use the 'properties'
> interface as a global entry point from the management tool. It would be
> great if you base your patches on top of it.
> 
> (The props haven't been acked, but we've reached a wider consensus on
> irc, patches are in the mailinglist, so we can bring it up again and
> discuss outstanding issues or objections. I'm mainly concerned about
> priority of setting the defaults and not-bloating the 'btrfs' interface
> too much.)

Thank you very much for your review!
I'll rework my patch to reflect all comments.
Please let me know if there are still outstanding issues or objections
about/against this feature.


Thanks,
H.Seto

