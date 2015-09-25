Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:39531
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbbIYLWy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 07:22:54 -0400
Subject: Re: [PATCH] Btrfs: change how we wait for pending ordered extents
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <1443128161-31200-1-git-send-email-jbacik@fb.com>
 <56052A60.5000105@googlemail.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56052E8C.6030306@googlemail.com>
Date: Fri, 25 Sep 2015 13:22:52 +0200
MIME-Version: 1.0
In-Reply-To: <56052A60.5000105@googlemail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/25/15 13:05, Holger Hoffstätte wrote:
> Tried this and unexpectedly didn't get any lockups or 'splosions during normal
> operation, but balance now seems very slow and sits idle most of the time.

Meh..this doesn't seem to have anything to do with this particular patch after
all. Whoopdedoo. Sorry for the noise.

-h

