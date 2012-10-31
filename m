Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:42501 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932452Ab2JaDxF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 23:53:05 -0400
Message-ID: <50909F1D.7040609@csamuel.org>
Date: Wed, 31 Oct 2012 14:46:37 +1100
From: Chris Samuel <chris@csamuel.org>
MIME-Version: 1.0
To: Franke <ttfranke@googlemail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Crashes in extent_io.c after "btrfs bad mapping eb" notice
References: <20121031005736.306fd86b@googlemail.com>
In-Reply-To: <20121031005736.306fd86b@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 31/10/12 10:57, Franke wrote:

> I have been having some crashes like this. Since I upgraded to 3.6.4
> they have become common. The crashes happen pretty randomly during
> normal system usage. After the syslog messages the system stays semi
> usable for a minute, but when I run any new program it hangs. I had
> to downgrade to 3.6.2 to get my system usable again.

There were no btrfs changes in either 3.6.3 or 3.6.4, so it must be an
interaction with another change - you will probably need to bisect
between 3.6.2 and 3.6.3 to see what's causing it to happen.

Worth noting that Greg K-H is looking for people to help him with the
stable series...

http://www.kroah.com/log/linux/minion-wanted.html

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
