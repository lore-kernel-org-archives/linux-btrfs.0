Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:53447 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab2LBMor (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Dec 2012 07:44:47 -0500
Message-ID: <50BB4D3A.2050309@csamuel.org>
Date: Sun, 02 Dec 2012 23:44:42 +1100
From: Chris Samuel <chris@csamuel.org>
MIME-Version: 1.0
To: Riccardo Berto <riccardobrt@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [RESEND] btrfs corruption / cannot mount
References: <CAHt5hBH6drsjdzudgwgd8hdyRFOXsZqptu3J5y32z=MGxTmhCg@mail.gmail.com>
In-Reply-To: <CAHt5hBH6drsjdzudgwgd8hdyRFOXsZqptu3J5y32z=MGxTmhCg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hiya Riccardo,

On 02/12/12 19:49, Riccardo Berto wrote:

> I'm a btrfs user since I encountered the ext4 3.6.2 bug and then I
> decided to switch.

You are aware that the ext4 issue you mention only affects people who
turned on journal checksums, and is not turned on by default?

This LWN article has a good summary:

http://lwn.net/Articles/521803/

As Michael wrote btrfs is still considered an experimental filesystem.

All the best,
Chris
-- 
  Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
