Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:31737 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab2G3Mny (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 08:43:54 -0400
Message-ID: <50168185.9030100@petaramesh.org>
Date: Mon, 30 Jul 2012 14:43:49 +0200
From: =?UTF-8?B?U3fDom1pIFBldGFyYW1lc2g=?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Calvin Walton <calvin.walton@kepstin.ca>
CC: Florian Lindner <mailinglists@xgm.de>, linux-btrfs@vger.kernel.org
Subject: Re: subvolumes: default and IDs
References: <CAJtBfr-ndERMvhG2dEwKJVsUe++sqGk_ZU=0gHDr3vbZLSyo_w@mail.gmail.com> <1343647796.6064.12.camel@ayu>
In-Reply-To: <1343647796.6064.12.camel@ayu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 30/07/2012 13:29, Calvin Walton a écrit :
> It looks like there's currently a bug in btrfs-progs - the 'get-default'
> command is actually doing a 'list' instead of printing the default. With
> any luck it's just a little error in the command-line parsing and should
> be easy to fix...

I've fallen upon this one as well.

That's typically the kind of bug that makes one wonder to what extent
the software has ever been tested, and doubt it's anything close to
production quality... :-/

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

